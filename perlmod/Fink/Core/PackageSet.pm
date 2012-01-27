package Fink::Core::PackageSet;

use 5.008008;
use strict;
use warnings;

use base qw(Fink::Core::Set);

our $VERSION = '1.0';

sub _required_methods {
	my $self = shift;

	my @required = $self->SUPER::_required_methods();
	push(@required, 'is_obsolete', 'is_newer_than');

	return @required;
}

sub find_obsolete {
	my $self = shift;

	my @ret = grep { $self->is_obsolete($_) } @{$self->find_all()};
	return \@ret;
}

sub is_obsolete($) {
	my $self    = shift;
	my $package = shift;

	my $newest = $self->find_newest_by_name($package->name);
	return 0 unless (defined $newest);
	return $newest->is_newer_than($package);
}

1;
