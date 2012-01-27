package Fink::Core::File;

use 5.008008;
use strict;
use warnings;

=head1 NAME

Fink::Core::File - Perl extension for manipulating files

=cut

our $VERSION = '1.0';

=head1 CONSTRUCTOR

Fink::Core::File->new($field, $name, [$index])

Given a field (Source, PatchFile, etc.), a file name and an optional index, create a new Fink::Core::File object.

=cut

sub new {
	my $proto   = shift;
	my $class   = ref($proto) || $proto;
	my $self    = {};

	my $field   = shift;
	my $name    = shift;
	my $index   = shift || 0;

	if (not defined $name) {
		carp "You must provide a field and a file name!";
		return undef;
	}

	$self->{FIELD} = $field;
	$self->{NAME}  = $name;
	$self->{INDEX} = $index;

	return bless($self, $class);
}

=head1 METHODS

=over 4

=item field

The field this package is associated with.

=cut

sub field {
	my $self = shift;
	return $self->{FIELD};
}

=item name

The file name.

=cut

sub name {
	my $self = shift;
	return $self->{NAME};
}

=item index

The file index, defaults to 0.

=cut

sub index {
	my $self = shift;
	return $self->{INDEX};
}

=item compare_to($file)

Given a Fink::Core::File object, performs a cmp-style comparison on the file's index, for use in sorting.

=cut

# -1 = self before(compared)
#  0 = equal
#  1 = self after(compared)
sub compare_to {
	my $this = shift;
	my $that = shift;

	return 1 unless (defined $that);

	if ($this->field ne $that->field) {
		croak "can't compare 2 different field types! (" . $this->field . " != " . $that->field . ")";
	}

	return $this->index <=> $that->index;
}

=item to_string

Returns a string representation of the file, suitable for printing.

=cut

sub to_string {
	my $self = shift;
	return sprintf
	return sprintf('%s%s: %s', $self->field, ($self->index == 0? '' : $self->index), $self->name);
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
