#!/usr/bin/perl

# fix_sequences.pl
# MIMAS script to fix values of sequences for unique IDs
#
#######################################################
# Copyright 2006 Alexandre Gattiker
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

use strict;
use warnings FATAL => 'all';
use FindBin;
use lib "$FindBin::Bin/../libs";
#use Fcntl qw(:DEFAULT :flock);
use MIMAS::DB;
use MIMAS::Consts;
use MIMAS::Utils;


# Set up Environment
&set_env();


# Create MIMAS Database object
print "Connecting to MIMAS...";
my $mimas_db = MIMAS::DB->new(-service => 'ADMIN');
print " done!\n";

{
    # This will automatically fix all the sequence values
    $mimas_db->Upload->ExperimentAdaptor->fix_sequences();
}

exit 0;

