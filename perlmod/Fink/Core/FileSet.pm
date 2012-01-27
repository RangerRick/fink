file Fink::Core::FileSet;

use 5.008008;
use strict;
use warnings;

our $VERSION = '1.0';

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self  = {};

	my $field = shift;

	if (not defined $field) {
		croak "You must specify a field!";
	}

	$self->{FIELD} = $field;
	$self->{FILES} = {};

	bless($self);

	if (@_) {
		$self->add(@_);
	}

	return $self;
}

sub _hash {
	my $self = shift;
	return $self->{FILES};
}

sub add {
	my $self = shift;

	my @files = ();
	for my $item (@_) {
		if (ref($item) eq "ARRAY") {
			$self->add(@{$item});
		} else {
			if ($item->field ne $self->field) {
				croak "Attempted to add a file of field '" . $item->field . "' to a '" . $self->field . "' set!";
			}
			push(@files, $item);
		}
	}

	for my $file (@files) {
		$self->remove($file);
		push(@{$self->_hash->{$file->name}}, $file);
		@{$self->_hash->{$file->name}} = sort { $b->compare_to($a) } @{$self->_hash->{$file->name}};
	}
}

sub remove {
	my $self    = shift;
	my $file = shift;

	my $deleted = 0;
	my $entries = $self->_hash->{$file->name};

	my @keep = grep { $_->path ne $file->path } @{$entries};
	$self->_hash->{$file->name} = \@keep;

	if (exists $self->_hash->{$file->name} and scalar(@{$self->_hash->{$file->name}}) == 0) {
		delete $self->_hash->{$file->name};
	}
	return $deleted;
}

sub set {
	my $self = shift;
	$self->{PACKAGES} = {};
	$self->add(@_);
}

sub find_all {
	my $self = shift;
	my @ret = ();
	for my $name (sort keys %{$self->_hash}) {
		push(@ret, @{$self->_hash->{$name}});
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

	if (exists $self->_hash->{$name}) {
		return $self->_hash->{$name}->[0];
	}
	return undef;
}

sub find_obsolete {
	my $self = shift;

	my @ret = grep { $self->is_obsolete($_) } @{$self->find_all()};
	return \@ret;
}

sub is_obsolete($) {
	my $self    = shift;
	my $file = shift;

	my $newest = $self->find_newest_by_name($file->name);
	return 0 unless (defined $newest);
	return $newest->is_newer_than($file);
}

1;
