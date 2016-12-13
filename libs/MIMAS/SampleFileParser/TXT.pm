#!/usr/bin/perl

# MIMAS Parser for SampleFiles in TXT format
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::SampleFileParser::TXT;

use strict;
use warnings;

use MIMAS::Utils;
use MIMAS::SampleFileParser;
use MIMAS::SampleFileParser::Illumina;
use MIMAS::SampleFileParser::SeriesMatrix;
use MIMAS::SampleFileParser::Data::TXT;
use base qw(MIMAS::SampleFileParser);


sub _format {
	my ($self) = @_;
	return 'TXT';
}


sub is_normalized {
	my ($self) = @_;
	return 1;
}


sub parse {
	@_ == 4 or die "Invalid number of arguments";
	my ($self, $fh, $basename, $hybridization_name) = @_;

	$fh->seek(0, 0) or die "Cannot seek: $!";

# TXT File Parsing & Integrity Checking
	my $header = '';
	my $line_delim;
	while (<$fh>) {
		$header .= $_;
		$line_delim = $1 if /([\r\n]+)/;
		if ($_ =~ /^Probe Set Name\tStat Pairs\tStat Pairs Used\tSignal\tDetection\tDetection p-value/) {
			# Format is "Affymetrix MAS/GCOS" version 4 (?)
			# Don't reset filehandle, read data starting after the header
			return _parse_TXT($self, $fh, $basename, $hybridization_name, $header, $line_delim, 4, "4", 1);
		}
		if ($_ =~ /^\tAnalysis Name\tProbe Set Name\tStat Pairs\tStat Pairs Used\tSignal\tDetection\tDetection p-value/) {
			# Format is "Affymetrix MAS/GCOS" version 5
			# Don't reset filehandle, read data starting after the header
			return _parse_TXT($self, $fh, $basename, $hybridization_name, $header, $line_delim, 5, "5", 0);
		}

		if ($_ =~ /^ID_REF\tVALUE/) {
			# Format is "GEO MAS" version 5
			# Don't reset filehandle, read data starting after the header
			return _parse_TXT($self, $fh, $basename, $hybridization_name, $header, $line_delim, 2, "GEO", 0);
		}

		if ($_ =~ /^ID_REF\tABS_CALL\tVALUE/) {
			# Format is "GEO MAS" version 5
			# Don't reset filehandle, read data starting after the header
			return _parse_TXT($self, $fh, $basename, $hybridization_name, $header, $line_delim, 3, "GEO", 0);
		}

		if ($_ =~ /\AGene\tSignal[\r\n]+$/m) {  # carriage return can be for Unix, DOS, Mac
			#Format is "ArrayAssist (2-column no header)"
			# Don't reset filehandle, read data starting after the header
			return _parse_TXT($self, $fh, $basename, $hybridization_name, $header, $line_delim, 2, "ArrayAssist", 0);
		}

		if ($_ =~ /\AIllumina Inc. BeadStudio version /m) {
			#Format is "Illumina BeadStudio", delegate to specialized package
			#(changes file format from 'TXT' to 'Illumina')
			bless $self, MIMAS::SampleFileParser::Illumina->package;
			return $self->parse($fh, $basename, $hybridization_name);
		}

		if ($_ =~ /\A!Series_title\t/m) {
			#Format is "GEO series_matrix", delegate to specialized package
			#(changes file format from 'TXT' to 'SeriesMatrix')
			bless $self, MIMAS::SampleFileParser::SeriesMatrix->package;
			return $self->parse($fh, $basename, $hybridization_name);
		}
	}
	die "Unknown file format for TXT file\n";
}

sub _parse_TXT {
	@_ == 9 or die "Invalid number of arguments";
	my ($self, $fh, $basename, $hybridization_name, $header, $line_delim, $signal_col, $version, $allow_empty_lines) = @_;

# Check TXT header parameters
	if ($version eq "4") { #no header in version 5 output
		my ($nf) = $header =~ /NF=(\d*\.\d+)/;
		my ($sf) = $header =~ /SF=(\d*\.\d+)/;
		if (defined $nf and defined $sf) {
			if (is_numeric($nf) and is_numeric($sf)) {
				if ($nf != 1) {
					die "Normalization (NF=${nf}) is not equal to 1";
				}
			} else {
				die "Normalization (NF=${nf}) and/or scaling (SF=${sf}) are not numeric";
			}
		} else {
			die "Could not obtain normalization (NF) and/or scaling (SF) factor values";
		}

	}

	my $regexp = qr/\S+\t\S+\t\S+\t\S+\t\S+.*/;
	if ($version eq "GEO") {
		$regexp = qr/\S+\t\S+.*/;
	}
	if ($version eq "ArrayAssist") {
		$regexp = qr/\S+\t([\deE+\-.]+|Inf|NA)/m;
	}

	return new MIMAS::SampleFileParser::Data::TXT($fh, $line_delim, $hybridization_name, $signal_col, $regexp, $self->_format, [$basename], undef, undef, $allow_empty_lines);
}


1;
