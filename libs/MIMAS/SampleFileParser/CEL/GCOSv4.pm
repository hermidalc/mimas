#!/usr/bin/perl

# MIMAS Parser for SampleFiles in CEL GCOS v4 format
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::SampleFileParser::CEL::GCOSv4;

use strict;
use warnings;

use Time::Local;
use MIMAS::Utils;
use MIMAS::SampleFileParser;
use MIMAS::SampleFileParser::Data::CEL;
use base qw(MIMAS::SampleFileParser);

sub parse {
	@_ == 4 or die "Invalid number of arguments";
	my ($self, $fh, $basename, $hybridization_name) = @_;

# CEL File Header
# Primary Statistics: 5 32-bit signed integers
	read($fh, my $buffer, 20) or die "Problem reading CEL file primary statistics";
	my ($magic_num, $version, $num_cols, $num_rows, $num_cel_features) = unpack('l5', $buffer);
# Header length: 1 32-bit signed integer
	read($fh, $buffer, 4) or die "Problem reading CEL file header length";
	read($fh, $buffer, unpack('l', $buffer)) or die "Problem reading CEL file header";
	my $header = unpack('a*', $buffer);
# Algorithm Name length: 1 32-bit signed integer
	read($fh, $buffer, 4) or die "Problem reading CEL file algorithm name length";
	read($fh, $buffer, unpack('l', $buffer)) or die "Problem reading CEL file algorithm name";
	my $alg_name = unpack('a*', $buffer);
# Algorithm Parameters length: 1 32-bit signed integer
	read($fh, $buffer, 4) or die "Problem reading CEL file algorithm parameters length";
	read($fh, $buffer, unpack('l', $buffer)) or die "Problem reading CEL file algorithm parameters";
	my $alg_params = unpack('a*', $buffer);
# Secondary Statistics: 1 32-bit signed integer, 2 32-bit unsigned integers, 1 32-bit signed integer
	read($fh, $buffer, 16) or die "Problem reading CEL file secondary statistics";
	my ($cell_margin, $num_outliers, $num_masked, $num_subgrids) = unpack('l L L l', $buffer);

	my ($hybridization_date_str, $array_name) = ( $header =~ m/^DatHeader=.+?(\d{2}\/\d{2}\/\d{2}).+?([\w-]+)\.1sq/m );

	my $hybridization_date = _to_date($hybridization_date_str);

	die "Number of CEL rows not found in CEL file.  Check CEL file header."    unless defined $num_rows;
	die "Number of CEL columns not found in CEL file.  Check CEL file header." unless defined $num_cols;
	die "Chip name not found in CEL file.  Check CEL file header."             unless defined $array_name;
	die "Hybridization date not found in CEL file.  Check CEL file header."    unless defined $hybridization_date;
	die "CEL version not found in CEL file.  Check CEL file header."           unless defined $version;
	die "CEL file version [$version] not Version 4"                            unless $version == 4;

# CEL INTENSITY Features: 2 32-bit floats, 1 16-bit signed integer
#	for (1 .. $num_cel_features) {
#		read($fh, $buffer, 10) or die "Problem reading CEL file INTENSITY feature";
#		my ($mean_intensity, $std_dev, $num_pixels) = unpack('f f s', $buffer);
## no checks really possible
#	}
	seek($fh, 10 * $num_cel_features, 1) or die "Problem reading CEL file INTENSITY feature";
# CEL MASKS: 2 16-bit signed integers
	for (1 .. $num_masked) {
		read($fh, $buffer, 4) or die "Problem reading CEL file MASKS feature";
		my ($x, $y) = unpack('s2', $buffer);
		if ($x < 0 or $x > $num_rows - 1 or $y < 0 or $y > $num_cols - 1) {
			die "MASKS feature X [$x] Y [$y] coordinate out of allowable range X: 0 - " . ($num_rows - 1) . " Y: 0 - " . ($num_cols - 1);
		}
	}
# CEL Outliers: 2 16-bit signed integers
	for (1 .. $num_outliers) {
		read($fh, $buffer, 4) or die "Problem reading CEL file OUTLIERS feature";
		my ($x, $y) = unpack('s2', $buffer);
		if ($x < 0 or $x > $num_rows - 1 or $y < 0 or $y > $num_cols - 1) {
			die "OUTLIERS feature X [$x] Y [$y] coordinate out of allowable range X: 0 - " . $num_rows - 1 . " Y: 0 - " . $num_cols - 1;
		}
	}
# CEL Subgrids: 2 32-bit signed integers, 8 32-bit floats, 4 32-bit signed integers
	for (1 .. $num_subgrids) {
		read($fh, $buffer, 56) or die "Problem reading CEL file SUBGRIDS feature";
		my ($row_num,       $col_num,      $up_left_x,      $up_left_y,       $up_right_x,
				$up_right_y,    $lower_left_x, $lower_left_y,   $lower_right_x,   $lower_right_y,
				$left_cell_pos, $top_cell_pos, $right_cell_pos, $bottom_cell_pos                  ) = unpack('l2 f8 l4', $buffer);
# no checks really possible
	}

	return new MIMAS::SampleFileParser::Data::CEL($fh, $basename, $array_name, $hybridization_date, $num_cel_features);
}

# Affymetrix Version 3 ASCII CEL File


sub _to_date {
	my ($date) = @_;
	if ($date =~ m!\A(\d{2})/(\d{2})/(\d{2})\Z!) {
		my $time = timegm(0,0,0,$2,$1-1,100+$3);
		return $time;
	}
	die "Unparseable date format '$date'";
}


sub package {
	return __PACKAGE__;
}


1;
