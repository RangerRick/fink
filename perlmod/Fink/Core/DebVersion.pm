package Fink::Core::DebVersion;

use 5.008008;
use strict;
use warnings;

use Carp;

use Fink::Core::Util qw(find_executable);

use base qw(Fink::Core::Version);

=head1 NAME

Fink::Core::DebVersion - Perl extension for manipulating Debian Versions

=head1 SYNOPSIS

  use Fink::Core::DebVersion;

=head1 DESCRIPTION

This is just a perl module for manipulating Debian versions.

=cut

our $VERSION       = '1.0';
our $DPKG          = undef;
our $DPKG_SEARCHED = 0;

=head1 CONSTRUCTOR

Fink::Core::DebVersion->new($version, $revision)

Given a version and revision, create a Debian version object.

=cut

sub new {
	my $proto    = shift;
	my $class    = ref($proto) || $proto;

	my $version  = shift;
	my $revision = shift;
	my $epoch    = shift;

	my $self     = bless($class->SUPER::new($version, $revision, $epoch), $class);

	if (not $DPKG_SEARCHED) {
		$DPKG = find_executable('dpkg');
		if (not defined $DPKG and not $ENV{HARNESS_ACTIVE}) {
			carp "Unable to locate \`dpkg\` executable: $! (if you are bootstrapping, this is normal)\n";
		}
		$DPKG_SEARCHED = 1;
	}

	return $self;
}

=head1 METHODS

=over 4

=item _compare_to($version)

Given a version, performs a cmp-style comparison, for use in sorting.

=cut

# -1 = self before(compared)
#  0 = equal
#  1 = self after(compared)
sub _compare_to {
	my $this = shift;
	my $that = shift;

	if (not defined $DPKG) {
		return $this->SUPER::compare_to($that);
	}

	my $thisversion = $this->full_version;
	my $thatversion = $that->full_version;

	if ($thisversion eq $thatversion) {
		return 0;
	}

	# dpkg --compare-versions 1.8.19-2 gt 1.9.19-0.20111213.1
	if (system("$DPKG --compare-versions '$thisversion' 'eq' '$thatversion'") == 0) {
		return 0;
	}
	if (system("$DPKG --compare-versions '$thisversion' 'lt' '$thatversion'") == 0) {
		return -1;
	} else {
		return 1;
	}
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
