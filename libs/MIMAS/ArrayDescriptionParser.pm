# ArrayDescriptionParser.pm
# MIMAS Base Class for all ArrayDescriptionParser Objects
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::ArrayDescriptionParser;

use strict;
use warnings;
use base qw(Root);

our $VERSION = 1.00;

use MIMAS::Utils qw(io_string);
use IO::Zlib;

sub array_name: lvalue {$_[0]->{_array_name}}
sub num_probesets: lvalue {$_[0]->{_num_probesets}}
sub num_cel_features: lvalue {$_[0]->{_num_cel_features}}
sub bgx_probe_id_to_arrayaddressid: lvalue {$_[0]->{_bgx_probe_id_to_arrayaddressid}}

sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    my $self  = { };
    bless $self, $class;
    
    return $self;
}


sub parse {
	my ($self, $fh, $file_basename, $file_ext) = @_;


	if (lc $file_ext eq "bgx" or lc $file_ext eq ".bgx") {
		bless $fh, "IO::File"; #necessary for Archive::Zip
		my $gzip = IO::Zlib->new($fh, 'rb') or return "Cannot parse BGX compressed file";
		# Format is "Illumina BGX Array Description"
		my @errors = _parse_BGX($self, $gzip, $file_basename);
		return @errors;
	}

# File Parsing & Integrity Checking
	my $line_delim;
	my $line = <$fh>;
	$line_delim = $1 if $line =~ /([\r\n]+)/;
	if ($line =~ /^\[CDF\]/) {
		# Format is "Affymetrix CDF"
		return _parse_CDF($self, $fh, $file_basename, $line_delim);
	}
	#Bytes EFBBBF may be present at the beginning of the file to indicate UTF-8 encoding.
	if ($line =~ /^(\xEF\xBB\xBF)<\?xml/) {
		$line = <$fh>;
		if ($line =~ /^<MAGE-ML identifier="Illumina MAGE-ML Array Description">/) {
			# Format is "Illumina MAGE-ML Array Description"
			return _parse_Illumina_MAGE($self, $fh, $file_basename, $line_delim);
		}
	}

	return "Unknown file format for Array definition file";
}

sub _parse_CDF {
	my ($self, $fh, $file_basename, $line_delim) = @_;
	my $array_name;
	my $section;
	while (<$fh>) {
		$section = $1, next if /^\[(.*)\]/;
		$array_name = $1, last if $section eq 'Chip' and /^Name=(\S+)/;
	}
	close $fh;

	return "Invalid CDF file: no Chip Name found" unless $array_name;
	$self->array_name = $array_name;
	return (); #no errors
}


sub _parse_BGX {
	my ($self, $fh, $file_basename) = @_;

	<$fh> =~ /^\? Illumina, Inc.$/ or return "Expected Illumina header";
	<$fh> =~ /^\[Heading\]$/ or return "Expected Heading";
	<$fh> =~ /^Date\t\d+\/\d+\/\d+$/ or return "Expected Date";
	<$fh> =~ /^ContentVersion\t/ or return "Expected ContentVersion";
	<$fh> =~ /^FormatVersion\t/ or return "Expected FormatVersion";
	my ($num_probesets) = <$fh> =~ /^Number of Probes\t([1-9]\d*)$/ or return "Expected Number of Probes";
	<$fh> =~ /^Number of Controls\t(\d+)$/ or return "Expected Number of Controls";

	#read Array_address_id mapping
	my %bgx_probe_id_to_arrayaddressid;
	my ($pidpos, $aaidpos);
	while (my $line = <$fh>) {
		my @fields = split /\t/, $line;
		my $probe_id;
		my $aa_id;
		for (my $fp = 0; $fp<@fields; $fp++) {
			my $f = $fields[$fp];
			$pidpos = $fp, next if $f eq "Probe_Id";
			$aaidpos = $fp, next if $f eq "Array_Address_Id";
			if (defined($pidpos) && $pidpos == $fp) {
				$probe_id = $f;
			}
			if (defined($aaidpos) && $aaidpos == $fp) {
				($aa_id = $f) =~ s/^0+//;
			}
		}
		if ($aa_id && $probe_id)
		{
			$bgx_probe_id_to_arrayaddressid{$aa_id} = $probe_id;
		}

	}
	$self->bgx_probe_id_to_arrayaddressid = \%bgx_probe_id_to_arrayaddressid;


	close $fh;

	return "Invalid Illumina description file: no Chip Name found" unless $file_basename;
	$self->array_name = $file_basename;
	$self->num_probesets = $num_probesets;
	return (); #no errors
}


sub _parse_Illumina_MAGE {
	my ($self, $fh, $file_basename, $line_delim) = @_;
	my $section;
	my $num_probesets = 0;
	while (<$fh>) {
		$num_probesets++ if /<\/ReporterCompositeMap>/;
	}
	close $fh;

	return "Invalid Illumina description file: no Chip Name found" unless $file_basename;
	return "Invalid Illumina description file: no ReporterCompositeMap tags found" unless $num_probesets > 0;
	#Design name is in uppercase in output files
	$self->array_name = uc $file_basename;
	$self->num_probesets = $num_probesets;
	return (); #no errors
}


1;
