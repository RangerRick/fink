package Fink::Core::Package::Deb;

use 5.008008;
use strict;
use warnings;

use Carp;

use base qw(Fink::Core::Package::Base);

=head1 NAME

Fink::Core::Package::Deb - Perl extension for manipulating .deb package files

=cut

our $VERSION = '1.0';

=head1 CONSTRUCTOR

Fink::Core::Package::Deb->new($name, $version)

Given a name and Fink::Core::Version, create a new Fink::Core::Package::Deb object.

=cut

sub new {
	my $proto   = shift;
	my $class   = ref($proto) || $proto;

	my $name    = shift;
	my $version = shift;

	if (not defined $version) {
		carp "You must provide a name and a Fink::Core::Version object!";
		return undef;
	}

	my $self = bless($class->SUPER::new($name, $version), $class);
}

=head1 METHODS

=over 4

=cut

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
