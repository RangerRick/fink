package Fink::Core::Package::Info;

use 5.008008;
use strict;
use warnings;

use Carp;
use Fink::Core::PackageSet;

use base qw(Fink::Core::Package::Base);

=head1 NAME

Fink::Core::Package::Info - Perl extension for manipulating .info package files

=cut

our $VERSION = '1.0';

=head1 CONSTRUCTOR

Fink::Core::Package::Info->new($name, $version)

Given a name and Fink::Core::Version, create a new Fink::Core::Package::Info object.

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

=item type

The Fink package 'type'.

=cut

sub type {
	my $self = shift;
	if (@_) { $self->{TYPE} = shift; }
	return $self->{TYPE};
}

=item configure_params

The configuration parameters.

=cut

sub configure_params {
	my $self = shift;
	if (@_) { $self->{CONFIGURE_PARAMS} = shift; }
	return $self->{CONFIGURE_PARAMS};
}

=item default_script

The default script type. Must be one of:

=over 2

=item AutoTools - AutoTools compile (configure; make)

=item MakeMaker - Perl MakeMaker (Makefile.PL)

=item ModuleBuild - Perl Module::Build (Build.PL)

=item Ruby - Ruby (extconf.rb)

=back

=cut

sub default_script {
	my $self = shift;
	if (@_) { $self->{DEFAULT_SCRIPT} = shift; }
	return $self->{DEFAULT_SCRIPT};
}

=item info_test

The test configuration for this package.

=cut

sub info_test {
	my $self = shift;
	if (@_) { $self->{INFO_TEST} = shift; }
	return $self->{INFO_TEST};
}

=item sources

The source files for this package.

=cut

sub sources {
	my $self = shift;
	if (@_) { $self->{SOURCES} = shift; }
	if (not exists $self->{SOURCES}) {
		$self->{SOURCES} = Fink::Core::FileSet->new();
	}
	return $self->{SOURCES};
}

=item splitoffs

The splitoffs of this package.

=cut

sub splitoffs {
	my $self = shift;
	if (not exists $self->{SPLITOFFS}) {
		$self->{SPLITOFFS} = Fink::Core::PackageSet->new();
	}
	return $self->{SPLITOFFS};
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
