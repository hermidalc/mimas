#!/usr/bin/perl

# startup.pl
# MIMAS mod_perl 1.0 Startup Script
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

use strict;
use warnings;

print "\nLoading MIMAS mod_perl startup file...\n\n";

# Make sure we are in MOD_PERL environment
die "Not running under mod_perl!\n" unless $ENV{MOD_PERL};


# Extend @INC
BEGIN {
    my $home = $ENV{MIMAS_HOME} or die "Fatal: environment variable MIMAS_HOME not set";
    push @INC, "$home/libs";
}


# Apache::Registry for things in the "/perl/" URL
# Apache::PerlRun  for things in the "/cgi-perl/" URL
# Apache::Status for status information
use Apache ();
use Apache::Registry ();
# use Apache::PerlRun ();
use Apache::Status ();


# Load Perl modules of my choice here (remember to use '()' so that we don't import)
# Remember that this code is interpreted only once at server startup
# make sure to always load Apache::DBI BEFORE DBI!
use Apache::DBI ();
use DBI ();


# Tell me more about warnings
use Carp ();
$SIG{__WARN__} = \&Carp::cluck;


# Load CGI.pm and precompile (but not import) its autoloaded methods
use CGI ();
CGI->compile();


# Compile and Preload any custom modules (saves memory)
use MIMAS::Apache::Handlers ();
# use MIMAS::DB ();
# use MIMAS::Web ();
# use MIMAS::Consts ();
# use MIMAS::Utils ();


# Preload all web scripts in perl directory (saves memory)
# use Apache::RegistryLoader ();


# Initialize any database connections (DBI connect_on_init stuff)
# none right now


1;

