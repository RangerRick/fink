package Fink::Core::Package::Base;

use 5.008008;
use strict;
use warnings;

use Carp;
use File::Basename;
use File::Copy qw();
use Expect;

# hack!
use Fink::Config qw($config);
use Fink::Core::Version;

=head1 NAME

Fink::Core::Package::Base - Perl extension for manipulating packages

=head1 SYNOPSIS

  use Fink::Core::Package::Base;

  by $package_a = Fink::Core::Package::Base->new('opennms', Fink::Core::DebVersion->new('1.0', '1'))
  by $package_b = Fink::Core::Package::Base->new('opennms', Fink::Core::DebVersion->new('2.0', '1'))
  if ($package_b->is_newer_than($package_b)) {
    print "yeah!\n";
  }

=head1 DESCRIPTION

This is just a perl module for manipulating packages, including
version and path comparisons.

=cut

our $VERSION = '1.0';

=head1 CONSTRUCTOR

Fink::Core::Package::Base->new($name, $version)

Given a name and Fink::Core::Version, create a new Fink::Core::Package::Base object.

=cut

sub new {
	my $proto   = shift;
	my $class   = ref($proto) || $proto;
	my $self    = {};

	my $name    = shift;
	my $version = shift;

	if (not defined $version) {
		carp "You must provide a name and a Fink::Core::Version object!";
		return undef;
	}

	$self->{NAME}    = $name;
	$self->{VERSION} = $version;

	return bless($self, $class);
}

=head1 METHODS

=over 4

=item name

The name of the package, i.e., "opennms".

=cut

sub name {
	my $self = shift;
	return $self->{NAME};
}

=item version

The package version, as an Fink::Core::Version object.

=cut

sub version {
	my $self = shift;
	return $self->{VERSION};
}

=item architecture

The architecture of this package.

=cut

sub architecture {
	my $self = shift;
	if (@_) { $self->{ARCHITECTURE} = shift; }
	return $self->{ARCHITECTURE};
}

=item distribution

The distribution of this package.

=cut

sub distribution {
	my $self = shift;
	if (@_) { $self->{DISTRIBUTION} = shift; }
	return $self->{DISTRIBUTION};
}

=item build_depends_only

Boolean. Whether or not this package should only be depended on at build time.

=cut

sub build_depends_only {
	my $self = shift;
	if (@_) { $self->{BUILD_DEPENDS_ONLY} = shift; }
	return $self->{BUILD_DEPENDS_ONLY};
}

=item essential

Boolean. Whether or not this package is considered essential.

=cut

sub essential {
	my $self = shift;
	if (@_) { $self->{ESSENTIAL} = shift; }
	return $self->{ESSENTIAL};
}

=item provides

Set of Fink::Core::Dependency objects representing 0 or more things this package provides.

=cut

sub provides {
	my $self = shift;
	if (not exists $self->{PROVIDES}) {
		$self->{PROVIDES} = Fink::Core::Set->new();
	}
	return $self->{PROVIDES};
}

=item license

The license(s) for this package.

=cut

sub license {
	my $self = shift;
	if (@_) { $self->{LICENSE} = shift; }
	return $self->{LICENSE};
}

=item description

The description of this package.

=cut

sub description {
	my $self = shift;
	if (@_) { $self->{DESCRIPTION} = shift; }
	return $self->{DESCRIPTION};
}

=item homepage

The homepage for this package.

=cut

sub homepage {
	my $self = shift;
	if (@_) { $self->{HOMEPAGE} = shift; }
	return $self->{HOMEPAGE};
}

=item maintainer

The maintainer of this package.

=cut

sub maintainer {
	my $self = shift;
	if (@_) { $self->{MAINTAINER} = shift; }
	return $self->{MAINTAINER};
}

=item compare_to($package)

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

	return $thisversion->compare_to($thatversion);
}

=item equals($package)

Given a package, returns true if both packages have the same name and version.

=cut

sub equals {
	my $this = shift;
	my $that = shift;

	return int($this->compare_to($that) == 0);
}

=item is_newer_than($package)

Given a package, returns true if the current package is newer than the
given package, and they have the same name.

=cut

sub is_newer_than {
	my $this = shift;
	my $that = shift;

	if ($this->name ne $that->name) {
		croak "You can't compare 2 different package names with is_newer_than! (" . $this->name . " != " . $that->name .")";
	}
	return int($this->compare_to($that) == 1);
}

=item is_older_than($package)

Given a package, returns true if the current package is older than the
given package, and they have the same name.

=cut

sub is_older_than {
	my $this = shift;
	my $that = shift;

	if ($this->name ne $that->name) {
		croak "You can't compare 2 different package names with is_older_than! (" . $this->name . " != " . $that->name .")";
	}
	return int($this->compare_to($that) == -1);
}

=item to_string

Returns a string representation of the package, suitable for printing.

=cut

sub to_string {
	my $self = shift;
	return $self->name . '-' . $self->version->full_version;
}

=item canonical_name

Returns a string representation of the "canonical name" of the package, eg:

	opennms-1.0-1

Note that for historical reasons, the canonical name does *not* include the epoch.

=cut

sub canonical_name {
	my $self = shift;
	return sprintf('%s-%s-%s', $self->name, $self->version->version, $self->version->revision);
}


1;
__END__
=back

=head1 AUTHOR

Benjamin Reed, E<lt>rangerrick@users.sourceforge.netE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Benjamin Reed

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
