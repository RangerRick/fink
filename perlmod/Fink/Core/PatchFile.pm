package Fink::Core::PatchFile;

use 5.008008;
use strict;
use warnings;

use Carp;
use Fink::Checksum::MD5;

use base qw(Fink::Core::File);

=head1 NAME

Fink::Core::PatchFile - Perl extension for manipulating patch files

=cut

our $VERSION = '1.0';

=head1 CONSTRUCTOR

Fink::Core::PatchFile->new($name, [$index])

Given a file name and an optional index, create a new Fink::Core::PatchFile object.

=cut

sub new {
	my $proto   = shift;
	my $class   = ref($proto) || $proto;

	my $name    = shift;
	my $index   = shift || 0;

	if (not defined $name) {
		carp "You must provide a file name!";
		return undef;
	}

	return bless($class->SUPER::new('Patch', $name, $index), $class);
}

=head1 METHODS

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
