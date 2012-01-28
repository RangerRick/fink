package Fink::Core::Util;

use 5.008008;
use strict;
use warnings;

use Carp;
require Exporter;

our @ISA = qw(Exporter);

=head1 NAME

Fink::Core::Util - a collection of utility functions.

=head1 SYNOPSIS

  use Fink::Core::Util;

=cut

our @EXPORT_OK = qw(
	boolean
	ternary
	find_executable
	read_properties
	slurp
	gpg_write_key
	gpg_detach_sign_file
);

our @EXPORT = qw(
);

our $VERSION = '1.0';

=head1 METHODS

=over 4

=item boolean($value)

Return 1 of 2 values:

=over 2

=item 1 (true) if passed "true", "yes", or 1, case-insensitively

=item 0 (false) otherwise

=back

=cut

sub boolean($) {
	my $value = shift;
	return (defined $value and $value =~ /^(true|yes|1)$/i) ? 1 : 0;
}

=item ternary($value)

Returns 1 of 3 values:

=over 2

=item undef if passed undef

=item 1 (true) if passed "true", "yes", or 1, case-insensitively

=item 0 (false) otherwise

=back

=cut

sub ternary($) {
	my $value = shift;
	return undef if (not defined $value);
	return 1 if ($value =~ /^(true|yes|1)$/i);
	return 0;
}


=item find_executable($exe)

Locate an executable. It will first look for an all-caps environment variable
pointing to the binary  (RPM = rpm, APT_FTPARCHIVE = apt-ftparchive, etc.), and
check that it is executable, and barring that, look for it in the path.

=cut

sub find_executable($) {
	my $name = shift;

	my $envname = uc($name);
	$envname =~ s/[^[:alnum:]]+/_/g;

	if (exists $ENV{$envname} and -x $ENV{$envname}) {
		return $ENV{$envname};
	}

	my $exe = `which $name 2>/dev/null`;
	if ($? == 0) {
		chomp($exe);
		return $exe;
	} else {
		return undef;
	}
}

=item read_properties($file)

Reads a property file and returns a hash of the contents.

=cut

sub read_properties {
	my $file = shift;
	my $return = {};

	open (FILEIN, $file) or die "unable to read from $file: $!";
	while (<FILEIN>) {
		chomp;
		next if (/^\s*$/);
		next if (/^\s*\#/);
		my ($key, $value) = /^\s*([^=]*)\s*=\s*(.*?)\s*$/;
		$return->{$key} = $value;
	}
	close (FILEIN);
	return $return;
}

=item slurp($file)

Reads the contents of a file and returns it as a string.

=cut

sub slurp {
	my $file = shift;
	open (FILEIN, $file) or die "unable to read from $file: $!";
	local $/ = undef;
	my $ret = <FILEIN>;
	close (FILEIN);
	return $ret;
}

=item gpg_write_key($id, $password, $file)

Given a GPG ID and password, and an output file, writes
the ASCII-armored version of the GPG key to the given file.

=cut

sub gpg_write_key {
	my $id       = shift;
	my $password = shift;
	my $output   = shift;

	system("gpg --passphrase '$password' --batch --yes -a --export '$id' > $output") == 0 or croak "unable to write public key for '$id' to '$output': $!";
	return 1;
}

=item gpg_detach_sign_file($id, $password, $inputfile, [$outputfile])

Given a GPG ID and password, and a file, detach-signs the
specified file and outputs to C<$outputfile>. If no output file
is specified, it creates a file named C<$inputfile.asc>.

=cut

sub gpg_detach_sign_file {
	my $id       = shift;
	my $password = shift;
	my $file     = shift;
	my $output   = shift || $file . '.asc';

	system("gpg --passphrase '$password' --batch --yes -a --default-key '$id' --detach-sign -o '$output' '$file'") == 0 or croak "unable to detach-sign '$file' with GPG id '$id': $!";
	return 1;
}

1;
__END__
=back

=head1 AUTHOR

Benjamin Reed E<lt>rangerrick@fink.sourceforge.netE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Benjamin Reed

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
