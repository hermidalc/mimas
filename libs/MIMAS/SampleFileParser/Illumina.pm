#!/usr/bin/perl

# MIMAS Parser for SampleFiles in Illumina format
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::SampleFileParser::Illumina;

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

# Illumina File Parsing & Integrity Checking
	my $header = '';
	my $line_delim;
	while (<$fh>) {
		$header .= $_;
		$line_delim = $1 if /([\r\n]+)/;

		if ($_ =~ /\AIllumina Inc. BeadStudio version /m) {
			return _parse_Illumina($self, $fh, $header, $line_delim, $basename, $hybridization_name);
		}
	}
	die "Unknown file format for Illumina file";
}



sub _parse_Illumina {
	my ($self, $fh, $header, $line_delim, $basename, $hybridization_name) = @_;

	my ($normalization) = <$fh> =~ /^Normalization = (.*\S)\s*$/ or die "Invalid line in Illumina file header (expected Normalization)";
	my ($array_name) = <$fh> =~ /^Array Content = (.*\S).(?i:bgx)\s*$/ or die "Invalid line in Illumina file header (expected Array Content with bgx). You must use the BeadStudio 'ArrayExpress Data Submission Report Plug-in' to export your data.";
	<$fh> =~ /^Error Model = (.*\S)\s*$/ or die "Invalid line in Illumina file header (expected Error Model)";
	my ($hybridization_date_str) = <$fh> =~ /^DateTime = (.*\S)\s*$/ or die "Invalid line in Illumina file header (expected DateTime)";
	<$fh> =~ /^Local Settings = (.*\S)\s*$/ or die "Invalid line in Illumina file header (expected Local Settings)";
	<$fh> =~ /^\s*$/ or die "Invalid line in Illumina file header (expected blank line)";
	my ($column_headers) = <$fh> =~ /^PROBE_ID\t(.*\S)\s*$/ or die "Invalid line in Illumina file header (expected PROBE_ID)";
	my @column_headers = split /\t/, $column_headers;

	my $num_cols_minus_one = @column_headers;

	my @HEADERS = (
			"AVG_Signal",
			"Avg_NBEADS",
			"BEAD_STDERR",
			"Detection Pval",
		      );

	my $header_pos = 0;
	my $last_hyb_name;
	my @hybridization_names;
	my $signal_col;
	for (my $i=0; $i<@column_headers; $i++) {
		my $column_header = $column_headers[$i];
		my ($column_hyb_name, $column_type) = split /\./, $column_header, 2;
		die "Invalid column header $column_header" unless $column_hyb_name && $column_type;
		die "Invalid column type, expected $HEADERS[$header_pos]" if $column_type ne $HEADERS[$header_pos];
		if ($header_pos == 0) {
			$last_hyb_name = $column_hyb_name;
			push @hybridization_names, $column_hyb_name;
		}
		die "Invalid hyb name $column_hyb_name should match that of previous column $last_hyb_name" if $column_hyb_name ne $last_hyb_name;

		$signal_col = $i+2 if defined $hybridization_name and $column_hyb_name eq $hybridization_name and $column_type eq "AVG_Signal";

		$header_pos++; $header_pos = 0 if $header_pos > $#HEADERS;
	}
	die "Missing columns for $last_hyb_name" unless $header_pos == 0;
	die "Hybridization name '$hybridization_name' not found in file" if defined $hybridization_name and not defined $signal_col;

	my $format = $normalization eq "none" ? "Illumina" : "TXT";
	my $hybridization_date = _to_date($hybridization_date_str);

	my $regexp = qr/[\S ]+(?:\t(?:[\deE+\-.]+|Inf|NaN|Non Num..?rique)){$num_cols_minus_one}\t?/;

	return new MIMAS::SampleFileParser::Data::TXT($fh, $line_delim, $hybridization_name, $signal_col, $regexp, $format, \@hybridization_names, $array_name, $hybridization_date, 0);
}


sub _to_date {
	my ($date) = @_;
	if ($date =~ m!\A(\d{1,2})/(\d{1,2})/(\d{4}) (\d{2}):(\d{2})\Z!) {
		my $time = timegm(0,$5,$4,$2,$1-1,$3-1900);
		return $time;
	}
	elsif ($date =~ m!\A(\d{1,2})/(\d{1,2})/(\d{4}) (\d{1,2}):(\d{2}) (AM|PM)\Z!) {
		my $hour = $6 eq "AM" ? $4 : $4+12;
		my $time = timegm(0,$5,$hour,$2,$1-1,$3-1900);
		return $time;
	}
	elsif ($date =~ m!\A(\d{1,2})\.(\d{1,2})\.(\d{4}) (\d{1,2}):(\d{2})\Z!) {
		#With Local Settings fr-CH, day and month are still reversed like in US format, e.g.:
		#DateTime = 06.13.2008 04:26
		#Local Settings = fr-CH
		my $time = timegm(0,$5,$4,$2,$1-1,$3-1900);
		return $time;
	}
	die "Unparseable date format '$date'";
}


sub package {
	return __PACKAGE__;
}


1;
