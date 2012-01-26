package Fink::Core::Package;

use 5.008008;
use strict;
use warnings;

use Carp;
use File::Basename;
use File::Copy qw();
use Expect;

use Fink::Core::Version;

=head1 NAME

Fink::Core::Package - Perl extension for manipulating packages

=head1 SYNOPSIS

  use Fink::Core::Package;

  by $package_a = Fink::Core::Package->new('opennms', Fink::Core::DebVersion->new('1.0', '1'), 'amd64')
  by $package_b = Fink::Core::Package->new('opennms', Fink::Core::DebVersion->new('2.0', '1'), 'amd64')
  if ($package_b->is_newer_than($package_b)) {
    print "yeah!\n";
  }

=head1 DESCRIPTION

This is just a perl module for manipulating packages, including
version and path comparisons.

=cut

our $VERSION = '1.0';

=head1 CONSTRUCTOR

Fink::Core::Package->new($name, $version, $arch)

Given a name, Fink::Core::Version, and architecture, create a new Fink::Core::Package object.

=cut

sub new {
	my $proto   = shift;
	my $class   = ref($proto) || $proto;
	my $self    = {};

	my $name    = shift;
	my $version = shift;
	my $arch    = shift;

	if (not defined $arch) {
		carp "You must provide a name, a Fink::Core::Version object, and an architecture!";
		return undef;
	}

	$self->{NAME}    = $name;
	$self->{VERSION} = $version;
	$self->{ARCH}    = $arch;

	return bless($self, $class);
}

=head1 METHODS

=head2 * name

The name of the package, i.e., "opennms".

=cut

sub name {
	my $self = shift;
	return $self->{NAME};
}

=head2 * version

The package version, as an Fink::Core::Version object.

=cut

sub version {
	my $self = shift;
	return $self->{VERSION};
}

=head2 * arch

The package arch, as an Fink::Core::Version object.

=cut

sub arch {
	my $self = shift;
	return $self->{ARCH};
}

=head2 * compare_to($package)

Given a package, performs a cmp-style comparison on the packages' name and version, for
use in sorting.

=cut

# -1 = self before(compared)
#  0 = equal
#  1 = self after(compared)
sub compare_to {
	my $this = shift;
	my $that = shift;

	return 1 unless (defined $that);

	if ($this->name ne $that->name) {
		return $this->name cmp $that->name;
	}

	my $thisversion = $this->version;
	my $thatversion = $that->version;

	my $ret = $thisversion->compare_to($thatversion);

	if ($ret == 0 and $this->arch ne $that->arch) {
		return $this->arch cmp $that->arch;
	}

	return $ret;
}

=head2 * equals($package)

Given a package, returns true if both packages have the same name and version.

=cut

sub equals {
	my $this = shift;
	my $that = shift;

	return int($this->compare_to($that) == 0);
}

=head2 * is_newer_than($package)

Given a package, returns true if the current package is newer than the
given package, and they have the same name.

=cut

sub is_newer_than {
	my $this = shift;
	my $that = shift;

	if ($this->name ne $that->name) {
		croak "You can't compare 2 different package names with is_newer_than! (" . $this->name . " != " . $that->name .")";
	}
	if ($this->arch ne $that->arch) {
		croak "You can't compare 2 different package architectures with is_newer_than! (" . $this->to_string . " != " . $that->to_string .")";
	}
	return int($this->compare_to($that) == 1);
}

=head2 * is_older_than($package)

Given a package, returns true if the current package is older than the
given package, and they have the same name.

=cut

sub is_older_than {
	my $this = shift;
	my $that = shift;

	if ($this->name ne $that->name) {
		croak "You can't compare 2 different package names with is_older_than! (" . $this->name . " != " . $that->name .")";
	}
	if ($this->arch ne $that->arch) {
		croak "You can't compare 2 different package architectures with is_older_than! (" . $this->to_string . " != " . $that->to_string .")";
	}
	return int($this->compare_to($that) == -1);
}

=head2 * to_string

Returns a string representation of the package, suitable for printing.

=cut

sub to_string {
	my $self = shift;
	return $self->name . '-' . $self->version->full_version;
}

=head2 * canonical_name

Returns a string representation of the "canonical name" of the package, eg:

	opennms-1.0-1

=cut

sub canonical_name {
	my $self = shift;
	return sprintf('%s-%s', $self->name, $self->version->display_version);
}

=head2 * deb_name

Returns a string representation of the name of this package as a debian file, eg:

	opennms_1.0-1_darwin-x86_64.deb

=cut

sub deb_name {
	my $self = shift;

	return sprintf('%s_%s_%s.deb', $self->name, $self->version->display_version, $self->arch);
}

1;
__END__
=head1 AUTHOR

Benjamin Reed, E<lt>rangerrick@users.sourceforge.netE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Benjamin Reed

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
