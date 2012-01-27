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

=item detailed_description

The detailed description of this package. Corresponds to the InfoFile "DescDetail" field.

=cut

sub detailed_description {
	my $self = shift;
	if (@_) { $self->{DETAILED_DESCRIPTION} = shift; }
	return $self->{DETAILED_DESCRIPTION};
}

=item usage_description

The description on how to use the package. Corresponds to the InfoFile "DescUsage" field.

=cut

sub usage_description {
	my $self = shift;
	if (@_) { $self->{USAGE_DESCRIPTION} = shift; }
	return $self->{USAGE_DESCRIPTION};
}

=item type

The Fink package 'type'.

=cut

sub type {
	my $self = shift;
	if (@_) { $self->{TYPE} = shift; }
	return $self->{TYPE};
}

=item gcc_abi

The compiler ABI that this package must conform to.

=cut

sub gcc_abi {
	my $self = shift;
	if (@_) { $self->{GCC_ABI} = shift; }
	return $self->{GCC_ABI};
}

=item custom_mirror

The custom mirror configuration (if any) for this package.

=cut

sub custom_mirror {
	my $self = shift;
	if (@_) { $self->{CUSTOM_MIRROR} = shift; }
	return $self->{CUSTOM_MIRROR};
}

=item config_guess_dir

The path in which to write config.guess and config.sub.  If empty, nothing is written.

=cut

sub config_guess_dir {
	my $self = shift;
	if (@_) { $self->{CONFIG_GUESS_DIR} = shift; }
	return $self->{CONFIG_GUESS_DIR};
}

=item libtool_dir

The path in which to write ltconfig and ltmain.sh. If empty, nothing is written.

=cut

sub libtool_dir {
	my $self = shift;
	if (@_) { $self->{LIBTOOL_DIR} = shift; }
	return $self->{LIBTOOL_DIR};
}

=item po_makefile_dir

The path in which to write po/Makefile.in.in. If empty, nothing is written.

=cut

sub po_makefile_dir {
	my $self = shift;
	if (@_) { $self->{PO_MAKEFILE_DIR} = shift; }
	return $self->{PO_MAKEFILE_DIR};
}

=item update_pod

Boolean. Whether or not to update Perl documentation inside the package.

=cut

sub update_pod {
	my $self = shift;
	if (@_) { $self->{UPDATE_POD} = shift; }
	return $self->{UPDATE_POD};
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

=item sourcefiles

The source files for this package.

=cut

sub sourcefiles {
	my $self = shift;
	if (not exists $self->{SOURCES}) {
		$self->{SOURCES} = Fink::Core::Set->new();
	}
	return $self->{SOURCES};
}

=item patchfiles

The patch files for this package.

=cut

sub patchfiles {
	my $self = shift;
	if (not exists $self->{PATCHES}) {
		$self->{PATCHES} = Fink::Core::Set->new();
	}
	return $self->{PATCHES};
}

=item runtime_variables

A reference to a hash containing environment variables that should be set
at runtime in the built package.

=cut

sub runtime_variables {
	my $self = shift;
	if (@_) { $self->{RUNTIME_VARIABLES} = shift; }
	return $self->{RUNTIME_VARIABLES};
}

=item files

The files that will be in the binary that results from this package.

=cut

sub files {
	my $self = shift;
	if (not exists $self->{FILES}) {
		$self->{FILES} = Fink::Core::Set->new();
	}
	return $self->{FILES};
}

=item documentation_files

The files that will be copied into the documentation directory in the binary
that results from this package.

=cut

sub documentation_files {
	my $self = shift;
	if (not exists $self->{DOCUMENTATION_FILES}) {
		$self->{DOCUMENTATION_FILES} = Fink::Core::Set->new();
	}
	return $self->{DOCUMENTATION_FILES};
}

=item app_bundles

Application bundles that should be installed in the Applications folder in the
Fink prefix.

=cut

sub app_bundles {
	my $self = shift;
	if (not exists $self->{APP_BUNDLES}) {
		$self->{APP_BUNDLES} = Fink::Core::Set->new();
	}
	return $self->{APP_BUNDLES};
}

=item jar_files

Java JAR files that should be installed in the fink Java share directory.

=cut

sub jar_files {
	my $self = shift;
	if (not exists $self->{JAR_FILES}) {
		$self->{JAR_FILES} = Fink::Core::Set->new();
	}
	return $self->{JAR_FILES};
}

=item parent

The parent (if any) of this package.

=cut

sub parent {
	my $self = shift;
	if (@_) { $self->{PARENT} = shift; }
	return $self->{PARENT};
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
