package Fink::Core::Set;

use 5.008008;
use strict;
use warnings;

use Carp;

our $VERSION = '1.0';

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self  = { ITEMS => {} };

	bless($self, $class);

	if (@_) {
		$self->add(@_);
	}

	return $self;
}

sub _hash {
	my $self = shift;
	return $self->{ITEMS};
}

sub _required_methods {
	my $self = shift;

	return ('name', 'equals', 'compare_to');
}

sub add {
	my $self = shift;

	my @required = $self->_required_methods;

	my @items = ();
	for my $item (@_) {
		if (ref($item) eq "ARRAY") {
			$self->add(@{$item});
		} else {
			for my $required (@required) {
				if (not $item->can($required)) {
					my $desc = $item;
					if ($item->can('to_string')) {
						$desc = $item->to_string;
					}
					croak "Attempted to add an item ($desc) that does not answer to required method '->${required}'!";
				}
			}
			push(@items, $item);
		}
	}

	my $names = {};
	for my $item (@items) {
		my $name = $item->name;

		# replace existing file
		$self->remove($item);
		push(@{$self->_hash->{$item->name}}, $item);

		# remember the name for sorting
		$names->{$name}++;
	}

	# re-sort any name objects that have changed
	for my $name (keys %$names) {
		@{$self->_hash->{$name}} = sort { $b->compare_to($a) } @{$self->_hash->{$name}};
	}
}

sub remove {
	my $self = shift;
	my $item = shift;

	my $deleted = 0;
	my $items   = $self->_hash;
	my $name    = $item->name;
	my $entries = $items->{$name};

	my @keep = grep { not $_->equals($item) } @{$entries};
	$items->{$name} = \@keep;

	if (exists $items->{$name} and scalar(@{$items->{$name}}) == 0) {
		delete $items->{$name};
	}
	return $deleted;
}

sub set {
	my $self = shift;
	$self->{ITEMS} = {};
	$self->add(@_);
}

sub find_all {
	my $self = shift;
	my @ret = ();

	my $items = $self->_hash;

	for my $name (sort keys %{$items}) {
		push(@ret, @{$items->{$name}});
	}
	return \@ret;
}

sub find_newest {
	my $self = shift;
	my @ret = ();

	for my $name (sort keys %{$self->_hash}) {
		my $newest = $self->find_newest_by_name($name);
		if (defined $newest) {
			push(@ret, @{$newest});
		}
	}
	return \@ret;
}

sub find_by_name {
	my $self = shift;
	my $name = shift;

	return $self->_hash->{$name};
}

sub find_newest_by_name {
	my $self = shift;
	my $name = shift;

	my $items = $self->_hash;

	if (exists $items->{$name}) {
		return $items->{$name}->[0];
	}
	return undef;
}

1;
