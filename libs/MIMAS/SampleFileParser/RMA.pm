#!/usr/bin/perl

# MIMAS Parser for SampleFiles in RMA format
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::SampleFileParser::RMA;

use strict;
use warnings;

use MIMAS::SampleFileParser::TXT;
use base qw(MIMAS::SampleFileParser::TXT);


sub _format {
	my ($self) = @_;
	return 'RMA';
}

1;
