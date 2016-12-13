#!/usr/bin/perl

# MIMAS Parser for SampleFiles in CEL CCG v1 format
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::SampleFileParser::CEL::CCGv1;

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
	my $magic_num = readByte($fh);
	my $version = readByte($fh);
	my $num_data_group = readUInteger($fh);
	my $pos_data_group = readInteger($fh);

	my $dataTypeId = readString($fh, 0);
	my $fileId = readString($fh, 0);
	my $timestamp = readString($fh, 1);
	my $locale = readString($fh, 1);

	my %params = readParamList($fh);
	my $array_name = $params{"affymetrix-array-type"} or die "Parameter affymetrix-array-type missing from header";

	my $hybridization_date_str;
	my $num_parents = readInteger($fh);
	for (my $parent=0; $parent <$num_parents; $parent++) {
		my $dataTypeId = readString($fh, 0);
		my $fileId = readString($fh, 0);
		my $timestamp = readString($fh, 1);
		my $locale = readString($fh, 1);

		my %params = readParamList($fh);
		$hybridization_date_str ||= $params{"affymetrix-scan-date"};

	}
	$hybridization_date_str or die "Parameter affymetrix-scan-date missing from parent headers";


	my $num_cel_features;

	for (my $data_group=0; $data_group <$num_data_group; $data_group++) {
		$fh->seek($pos_data_group, 0);
		$pos_data_group = readInteger($fh);
		my $pos_data_set = readInteger($fh);
		my $num_data_sets = readUInteger($fh);

		for (my $data_set=0; $data_set <$num_data_sets; $data_set++) {
			$fh->seek($pos_data_set, 0);
			my $pos_elements = readInteger($fh);
			my $pos_data_set = readUInteger($fh);

			my $data_set_name = readString($fh, 1);
			readParamList($fh);
			my $num_columns = readUInteger($fh);
			for (my $column=0; $column<$num_columns; $column++) {
				my $name = readString($fh, 1);
				my $type = readByte($fh);
				my $size = readInteger($fh);
			}
			my $num_rows = readUInteger($fh);

			$num_cel_features = $num_rows if !defined $num_cel_features;
			die "Inconsistent number of features across data sets {$num_cel_features, $num_rows}" if $num_cel_features != $num_rows ;
		}
	}

	die "Missing number of features (number of rows in data sets)" unless $num_cel_features;
	die "Missing array name" unless $array_name;

	my $hybridization_date = _to_date($hybridization_date_str);

	return new MIMAS::SampleFileParser::Data::CEL($fh, $basename, $array_name, $hybridization_date, $num_cel_features);
}



sub readUInteger {
	my ($fh) = @_;
	return unpack 'l*', pack 'L*', readInteger($fh);
}

sub readInteger {
	my ($fh) = @_;
	read($fh, my $buffer, 4) or die "Problem reading CEL file binary data";
	return unpack('N', $buffer);
}

sub readByte {
	my ($fh) = @_;
	read($fh, my $buffer, 1) or die "Problem reading CEL file binary data";
	return unpack('C', $buffer);
}

sub readString {
	my ($fh, $is_wide) = @_;
	my $mul = $is_wide ? 2 : 1;
    my $length = readInteger($fh);
	return "" unless $length;
	read($fh, my $out, $length*$mul) or die "Problem reading CEL file binary data";
    if ($is_wide){
        $out = fromUTF16($out);
    }
	return $out;
}

sub fromUTF16 {
    my ($str) = @_;
    use Encode;
    $str = Encode::decode("utf16be", $str, Encode::FB_CROAK);
    my $pos = index $str, "\0";
    return $pos < 0 ? $str : substr($str, 0, $pos);
}

sub readParamList {
    my ($fh) = @_;
    my $num_par = readInteger($fh);
    my %out;
    for (my $param=0; $param<$num_par; $param++) {
        my $name = readString($fh, 1);
        my $raw_param = readString($fh, 0);
        my $type = readString($fh, 1);
        $raw_param = fromUTF16($raw_param) if $type eq "text/plain";
        $out{$name} = $raw_param;
    }
    return %out;
}

# Affymetrix Ccg Version 1 (Calvin) Binary CEL file


sub _to_date {
    my ($date) = @_;
    if ($date =~ m!\A(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})\Z!) {
        my $time = timegm($6,$5,$4,$3,$2-1,$1-1900);
        return $time;
    }
    die "Unparseable date format '$date'";
}


sub package {
	return __PACKAGE__;
}


1;
