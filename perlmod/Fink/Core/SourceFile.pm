package Fink::Core::SourceFile;

use 5.008008;
use strict;
use warnings;

use Carp;

use base qw(Fink::Core::File);

=head1 NAME

Fink::Core::SourceFile - Perl extension for manipulating files

=cut

our $VERSION = '1.0';

=head1 CONSTRUCTOR

Fink::Core::SourceFile->new($name, [$index])

Given a file name and an optional index, create a new Fink::Core::SourceFile object.

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

	return bless($class->SUPER::new('Source', $name, $index), $class);
}

=head1 METHODS

=over 4

=item directory

The directory that the source file extracts into.  Corresponds to the InfoFile
"SourceDirectory" or "SourceNExtractDir" fields.

=cut

sub directory {
	my $self = shift;
	if (@_) { $self->{DIRECTORY} = shift; }
	return $self->{DIRECTORY};
}

=item effective_name

The effective name to use when referring to this source file.  Usually the same as
"name", but can be something else if you wish to store the file as something else
on-disk. Corresponds to the InfoFile "SourceNRename" field.

=cut

sub effective_name {
	my $self = shift;
	if (@_) { $self->{EFFECTIVE_NAME} = shift; }
	return exists $self->{EFFECTIVE_NAME}? $self->{EFFECTIVE_NAME} : $self->name;
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
