#!/usr/bin/perl

# fix_countries.pl
# Fix Countries Script
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

use strict;
use warnings;

open(OUTFILE, ">new_countries.txt");

while (<>) {
    # s/^\('/\("/;
    # s/'\),$/"\),/;
    
    s/^\("/!/;
    s/"\)(,|)$/!/;
    
    print OUTFILE "$_";

}

close(OUTFILE);

