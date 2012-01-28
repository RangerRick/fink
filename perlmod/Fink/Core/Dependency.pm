package Fink::Core::Dependency;

use 5.008008;
use strict;
use warnings;

use Carp;

=head1 NAME

Fink::Core::Dependency - Perl extension for manipulating package dependencies

=cut

our $VERSION = '1.0';

=head1 CONSTRUCTOR

=over 2

=item Fink::Core::Dependency->new($name, $comparator, $version)

Given a package name, a comparator, and a Fink::Core::Version object, create a
Fink::Core::Dependency package.

Comparators can be the standard debian comparisons:

=over 2

=item << - less than
=item <= - less than or equal to
=item = or == - equals
=item != - not equals
=item >= - greater than or equal to
=item >> - greater than

=back

=cut

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self = {};

	my $name       = shift;
	my $comparator = shift;
	my $version    = shift;

	if (not defined $version) {
		carp "You must provide a name, comparator, and version!";
		return undef;
	}

	$self->{NAME}       = $name;
	$self->{COMPARATOR} = $comparator;
	$self->{VERSION}    = $version;

	return bless($self, $class);
}

=item Fink::Core::Dependency->new_from_string($dependency)

Given a full dependency string, parse and return a Fink::Core::Dependency package.

=back

=cut

sub new_from_string {
	my $proto  = shift;
	my $class  = ref($proto) || $proto;
	my $string = shift;

	my ($name, $comparator, $version_string) = $string =~ /^\s*(\S*?)\s*(?:\(\s*[<>=]+\s*(\S+)\s*\))?\s*$/;

	$comparator     = '>=' unless (defined $comparator);
	$version_string = '0-0' unless (defined $version_string);

	return $class->new($name, $comparator, Fink::Core::DebVersion->new_from_string($version_string));
}

=head1 METHODS

=over 4

=item name

The package name.

=cut

sub name {
	my $self = shift;
	return $self->{NAME};
}

=item comparator

The version comparison operator.

=cut

sub comparator {
	my $self = shift;
	return $self->{COMPARATOR};
}

=item version

The version to compare.

=cut

sub version {
	my $self = shift;
	return $self->{VERSION};
}

=item compare_to($dep)

Given a Fink::Core::Dependency object, performs a cmp-style comparison, for the purposes of sorting.

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

	if (this->comparator ne $that->comparator) {
		return $this->comparator cmp $that->comparator;
	}

	return $this->version->compare_to($that->version);
}

=item equals

Given a Fink::Core::Dependency object, returns 1 if the object is the same as this one, 0 otherwise.

=cut

sub equals {
	my $this = shift;
	my $that = shift;

	return $this->compare_to($that) == 0;
}

=item to_string

Returns a string representation of the file, suitable for printing.

=cut

sub to_string {
	my $self = shift;
	return sprintf('%s %s %s', $self->name, $self->comparator, $self->version->to_string);
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
