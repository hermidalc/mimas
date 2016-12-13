#!/usr/bin/perl

# MIMAS Parser for SampleFiles in GFF format
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::SampleFileParser::GFF;

use strict;
use warnings;

use MIMAS::Utils;
use MIMAS::SampleFileParser;
use MIMAS::SampleFileParser::Data::GFF;
use base qw(MIMAS::SampleFileParser);


sub is_normalized {
	my ($self) = @_;
	return 1;
}


sub parse {
	@_ == 4 or die "Invalid number of arguments";
	my ($self, $fh, $basename, $hybridization_name) = @_;

	$fh->seek(0, 0) or die "Cannot seek: $!";
	return new MIMAS::SampleFileParser::Data::GFF($fh, $basename);
}


sub validate_on_sample {
	#no validation possible

	return (); #no errors
}


1;
