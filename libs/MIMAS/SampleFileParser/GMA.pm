#!/usr/bin/perl

# MIMAS Parser for SampleFiles in GMA format
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::SampleFileParser::GMA;

use strict;
use warnings;

use MIMAS::SampleFileParser::RMA;
use base qw(MIMAS::SampleFileParser::RMA);

sub _format {
	my ($self) = @_;
	return 'TXT';
}

1;
