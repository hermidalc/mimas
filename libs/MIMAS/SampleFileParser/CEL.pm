#!/usr/bin/perl

# MIMAS Parser for SampleFiles in CEL format
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::SampleFileParser::CEL;

use strict;
use warnings;

use Time::Local;
use MIMAS::Utils;
use MIMAS::SampleFileParser;
use MIMAS::SampleFileParser::CEL::GCOSv3;
use MIMAS::SampleFileParser::CEL::GCOSv4;
use MIMAS::SampleFileParser::CEL::CCGv1;
use base qw(MIMAS::SampleFileParser);

use constant AFFY_CEL_SECTIONS  => { map { $_ => 1 } qw( CEL  HEADER  INTENSITY  MASKS  OUTLIERS  MODIFIED ) };


sub is_normalized {
	my ($self) = @_;
	return 0;
}


sub parse {
	@_ == 4 or die "Invalid number of arguments";
	my ($self, $fh, $basename, $hybridization_name) = @_;

	my @errors;

############# CEL File Parsing & Integrity Checking
	read($fh, my $buffer, 20) or die "Problem reading CEL file header";
	$fh->seek(0, 0) or die "Cannot seek: $!";

# check if its Affymetrix CCG Version 1 (Calvin) Binary CEL File
	my ($cel_v1_magic, $cel_v1_version, $nd) = unpack('CCN', $buffer);
	if ($cel_v1_magic == 59 and $cel_v1_version == 1) {
		bless $self, MIMAS::SampleFileParser::CEL::CCGv1->package;
		return $self->parse($fh, $basename, $hybridization_name);
	}

# check if its Affymetrix Version 4 Binary CEL File
	my ($cel_v4_magic, $cel_v4_version) = unpack('l5', $buffer);
	if ($cel_v4_magic == 64 and $cel_v4_version == 4) {
		bless $self, MIMAS::SampleFileParser::CEL::GCOSv4->package;
		return $self->parse($fh, $basename, $hybridization_name);
	} else {
# check if its Affymetrix Version 3 ASCII CEL File
		my $header      = <$fh>;
		my $version_str = <$fh>;
		if ($header and $version_str) {
			$header      =~ s/\s+//g;
			$version_str =~ s/\s+//g;
			my ($version) = $version_str =~ m/^Version=(.+)$/;
			if ($header eq '[CEL]' and $version == 3) {
				bless $self, MIMAS::SampleFileParser::CEL::GCOSv3->package;
				return $self->parse($fh, $basename, $hybridization_name);
			}
		}
	}
# error if its is an unknown file type
	die "Unknown CEL file type/version (not Version 3 (ascii) or 4 (binary) or CCG 1 (calvin binary))";
}

1;
