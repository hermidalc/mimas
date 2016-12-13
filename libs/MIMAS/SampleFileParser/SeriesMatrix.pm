#!/usr/bin/perl

# MIMAS Parser for SampleFiles in GEO series_matrix format
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::SampleFileParser::SeriesMatrix;

use strict;
use warnings;

use Time::Local qw(timegm);

use MIMAS::Utils;
use MIMAS::SampleFileParser;
use MIMAS::SampleFileParser::Data::TXT;
use base qw(MIMAS::SampleFileParser);


sub is_normalized {
	my ($self) = @_;
	return 0;
}


sub parse {
	@_ == 4 or die "Invalid number of arguments";
	my ($self, $fh, $basename, $hybridization_name) = @_;

	$fh->seek(0, 0) or die "Cannot seek: $!";

# SeriesMatrix File Parsing & Integrity Checking
	my $header = '';
	my $line_delim;
	while (<$fh>) {
		$header .= $_;
		$line_delim = $1 if /([\r\n]+)/;

		if ($_ =~ /\A!Series_title\t/m) {
			return _parse_SeriesMatrix($self, $fh, $header, $line_delim, $basename, $hybridization_name);
		}
	}
	die "Unknown file format for SeriesMatrix file";
}



sub _parse_SeriesMatrix {
	my ($self, $fh, $header, $line_delim, $basename, $hybridization_name) = @_;

	while (<$fh>) {
		/^$/ and last;
		/^!Series_/ or die "Expected !Series_";
	}
	while (<$fh>) {
		/^!series_matrix_table_begin$/ and last;
		/^!Sample_/ or die "Expected !Sample_ or !series_matrix_table_begin";
	}

	my ($hybridization_names) = <$fh> =~ /^"ID_REF"\t(.*\S)\s*$/ or die "Invalid line in SeriesMatrix file header (expected \"ID_REF\")";
	my @hybridization_names;
	my $signal_col;
	my @hybridization_names_str = split /\t/, $hybridization_names;
	for (my $i=0; $i<@hybridization_names_str; $i++) {
		my $sample_name = $hybridization_names_str[$i];
		$sample_name =~ /\A"([^"]*)"\Z/ or die "Invalid column name in ID_REF line";
		push @hybridization_names, $1;
		$signal_col = $i+2 if defined $hybridization_name and $1 eq $hybridization_name;
	}
	die "Hybridization name '$hybridization_name' not found in file" if defined $hybridization_name and not defined $signal_col;

	my $num_cols_minus_one = @hybridization_names;

	#missing values are empty (e.g. in GSE5810_series_matrix.txt)
	my $regexp = qr/[\S ]+(?:\t(?:[\deE+\-.]+|)){$num_cols_minus_one}\t?/;

	return new MIMAS::SampleFileParser::Data::TXT($fh, $line_delim, $hybridization_name, $signal_col, $regexp, 'TXT', \@hybridization_names, undef, undef, 0);
}


sub package {
	return __PACKAGE__;
}


1;
