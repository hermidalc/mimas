#!/usr/bin/perl

# MIMAS Parser for SampleFiles in CEL GCOS v3 format
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::SampleFileParser::CEL::GCOSv3;

use strict;
use warnings;

use Time::Local;
use MIMAS::Utils;
use MIMAS::SampleFileParser;
use MIMAS::SampleFileParser::Data::CEL;
use base qw(MIMAS::SampleFileParser);

use constant AFFY_CEL_SECTIONS  => { map { $_ => 1 } qw( CEL  HEADER  INTENSITY  MASKS  OUTLIERS  MODIFIED ) };

sub parse {
	@_ == 4 or die "Invalid number of arguments";
	my ($self, $fh, $basename, $hybridization_name) = @_;

	$fh->seek(0, 0) or die "Cannot seek: $!";

	my @errors;

	my ($array_name, $num_rows, $num_cols, $section);
	my ($num_cel_features);
	my ($hybridization_date_str, $version);
	while (<$fh>) {
		s/^\s+//;
		s/\s+$//;
# CEL Data
		if ( m/^\d+\s+\d+/ ) { # MASKS,OUTLIERS,MODIFIED sections
			s/\s+/\t/g;
			my @field_data = split /\t/, $_, -1;
			my ($x, $y)    = @field_data[0..1];
			if (!is_integer($x) or !is_integer($y)) {
				die "X [$x] or Y [$y] coordinate not an integer";
			} elsif ($x < 0 or $x > $num_rows - 1 or $y < 0 or $y > $num_cols - 1) {
				die "$section X [$x] Y [$y] coordinate out of range X: 0 - " . $num_rows - 1 . " Y: 0 - " . $num_cols - 1;
			}
		}
# Section Header
		elsif ( m/^\[(\w+)\]\s*$/ ) {
			$section = $1;
			if ( $section eq 'INTENSITY' ) {
				# Finished with CEL File header so do some checks
				die "Number of CEL rows not found in CEL file.  Check CEL file header."    unless defined $num_rows;
				die "Number of CEL columns not found in CEL file.  Check CEL file header." unless defined $num_cols;
				die "Chip name not found in CEL file.  Check CEL file header."             unless defined $array_name;
				die "Hybridization date not found in CEL file.  Check CEL file header."    unless defined $hybridization_date_str;
				die "CEL version not found in CEL file.  Check CEL file header."           unless defined $version;
				die "CEL file version [$version] not Version 3"                            unless $version == 3;

				#speed up parsing of millions of rows
				# Section Number of Cells
				($num_cel_features) = <$fh> =~ m/^NumberCells=(\d+)\s*$/ or die "Bad format in CEL file INTENSITY section";
				# Section Column Names
				<$fh> =~ m/^CellHeader=(.+)$/ or die "Bad format in CEL file INTENSITY section";
				<$fh> =~ m/\t/ or die "Bad format in CEL file INTENSITY section";
				{
					local $/ = "[";
					<$fh>;
				}
				<$fh>  =~ m/^(\w+)\]\s*$/ or die "Bad format after CEL file INTENSITY section";
				$section = $1;
			}

			if (AFFY_CEL_SECTIONS->{$section}) {
				$section = $1;
			} else {
				die "CEL file has an unknown section: $section. Please check CEL file.";
			}
		}
# CEL File Version
		elsif ( $section eq 'CEL' and m/^Version=(.+)$/ ) {
			$version = $1;
		}
# Header, Chip Name, Rows, Cols
		elsif ( $section eq 'HEADER' ) {
			if    ( m/^Rows=(.+)$/ )                                         { $num_rows = $1 }
			elsif ( m/^Cols=(.+)$/ )                                         { $num_cols = $1 }
			elsif ( m/^DatHeader=.+?(\d{2}\/\d{2}\/\d{2}).+?([\w-]+)\.1sq/ ) { ($hybridization_date_str, $array_name) = ($1, $2) }
		}
	}

	warn "TD:$hybridization_date_str";
	my $hybridization_date = _to_date($hybridization_date_str);
	return new MIMAS::SampleFileParser::Data::CEL($fh, $basename, $array_name, $hybridization_date, $num_cel_features);
}


sub _to_date {
	my ($date) = @_;
	warn "DATE:>$date<";
	if ($date =~ m!\A(\d{2})/(\d{2})/(\d{2})\Z!) {
	warn "DATE2:>$date<";
		my $time = timegm(0,0,0,$2,$1-1,100+$3);
		return $time;
	}
	warn "DATE3:>$date<";
	die "Unparseable date format '$date'";
}


sub package {
	return __PACKAGE__;
}


1;
