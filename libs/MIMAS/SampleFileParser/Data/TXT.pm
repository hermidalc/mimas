# TXT.pm
# Accessor for SampleFile TXT data
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::SampleFileParser::Data::TXT;

use strict;
use warnings;
use base qw(MIMAS::SampleFileParser::Data);

our $VERSION = 1.00;

#Regexp for excluding control probes from GeneChip.
#Ch\d{6}_ is used to exclude extraneous probes from the custom A.gossypii
#chip used in the Philippsen lab (the chip contains probes for distinct two genomes
		#but we are only interested in the A.gossypii probes)
#PSEUDOSPOT etc. are from ChIP-chip spotted arrays
our $CONTROL_PROBE_REGEXP = qr/^AFFX[\-_]|^Ctrl_|^DapX-|^HG\d+-HT|^synthstep_|^Ch\d{6}_|^_(PSEUDOSPOT|UNDEFINED|TEDMSO)_$/;


sub fh: lvalue {$_[0]->{fh}}
sub line_delim: lvalue {$_[0]->{line_delim}}
sub signal_col: lvalue {$_[0]->{signal_col}}
sub regexp: lvalue {$_[0]->{regexp}}
sub allow_empty_lines: lvalue {$_[0]->{allow_empty_lines}}
sub stack: lvalue {$_[0]->{stack}}


sub new {
	@_ == 11 or die "Invalid number of arguments";
	my ($invocant, $fh, $line_delim, $hybridization_name, $signal_col, $regexp, $format, $hybridization_names, $array_name, $hybridization_date, $allow_empty_lines) = @_;

	my $self = $invocant->SUPER::new($format, $hybridization_names, $array_name, $hybridization_date);
	$self->fh = $fh;
	$self->line_delim = $line_delim;
	$self->signal_col = $signal_col;
	$self->regexp = $regexp;
	$self->allow_empty_lines = $allow_empty_lines;
	$self->stack = [];

	return $self;
}


sub num_probesets {
	my $self = shift;
	return $self->{num_probesets} if defined $self->{num_probesets};
	my $fh = $self->fh;
	my $line_delim = $self->line_delim;
	my $num_probesets = 0;
	my $regexp = $self->regexp;
	my @err = _quickparse($fh, $regexp, $line_delim,
		sub {
		my ($pbuffer, $nmatches) = @_;
		$num_probesets += $nmatches;
		$$pbuffer = "" if $$pbuffer eq "!series_matrix_table_end$line_delim"; #FIXME: for SeriesMatrix format
		return (); #no errors
		}
		);
	die @err if @err;
	$self->{num_probesets} = $num_probesets;
	return $num_probesets;
}


sub _quickparse {
	my ($fh, $regexp, $line_delim, $callback) = @_;
	my $buffer = "";
	my $n = 100_000;
	my $regexp1 = qr/$regexp$line_delim/m;
	while (read($fh, $buffer, $n, length $buffer)) {

		if (eof $fh and $buffer !~ /\Q$line_delim\E\Z/) {
			$buffer .= $line_delim;
		}

		my $nmatches = $buffer =~ s/$regexp1//g;
		my @err = &$callback(\$buffer, $nmatches);
		return @err if @err;

		$buffer =~ s/\A($line_delim)+//; #allow extra empty lines

		if ($buffer =~ /$line_delim/) {
            my $buf = substr($buffer, 0, 1000);
            $buf .= "..." if length($buf) == 1000;
			return "Invalid data format for file [" . substr($buf, 0, 200) . "]";
		}
	}
	return "Invalid data format for file" if $buffer;
	return (); #no errors
}


sub quickcheck {
	my $self = shift;
	$self->num_probesets;
}


sub getline {
	my $self = shift;
	my $max_batchsize = shift || 50000;
	my $fh = $self->fh;
	my $signal_col = $self->signal_col or die "No hybridization_name passed to parser, cannot fetch signal";
	my $allow_empty_lines = $self->allow_empty_lines;
	my $stack = $self->stack;

	my $n=0;
	while (my $line = <$fh>) {
		next if $line =~ /^#/; #comments in GEO files
		if ($line =~ /^[\r\n]/) { #empty line
			next if $allow_empty_lines;
			die "Empty line";
		}
		last if $line =~ /^!series_matrix_table_end/; #GEO series_matrix format
		my ($probeset, @columns) = split /[\t\r\n]/, $line;
		$probeset = $1 if $probeset =~ /\A"(.*)"\Z/;
		$probeset =~ s/^Affymetrix:CompositeSequence:.*?://; #new-format RMA files
		next if $probeset =~ /$CONTROL_PROBE_REGEXP/o;

		my $signal = $columns[$signal_col-2];
		die "Undefined signal for column $signal_col at line $line" unless defined $signal;
		if ($signal =~ /^([+-]?)(?=\d|\.\d)\d*(\.\d*)?([Ee]([+-]?\d+))?$/) { #from perlfaq4
		}
		elsif ($signal eq 'NA' or $signal eq '-' or $signal eq '') {
			$signal = undef;
		}
		else {
			die("Invalid expression data: Invalid value for signal '$signal' in column $signal_col, got '$line'");
		}
		push @$stack, [$probeset, $signal];
		#avoid letting the stack grow to much by storing it
		#if it's become larger than the max chunk size
		if (@$stack >= $max_batchsize) {
			return splice @$stack, 0, $max_batchsize;
		}
	}

	#insert what's left on the stack, one item at a time
	return @$stack ? shift @$stack : ();
}


sub validate_on_sample {
	my ($self, $sample, $no_num_check) = @_;

	my @super = $self->SUPER::validate_on_sample($sample, $no_num_check);
	return @super if @super;

	return "Sample has no attached array" unless $sample->array;
	my $array = $sample->array;

	defined $self->num_probesets or die "Invalid state";
	# Check number of RMA, GC-RMA probesets
	if (!$no_num_check) {
		if (!defined $array->num_probesets) {
			$array->adaptor->update(-set        => [ -num_probesets => $self->num_probesets       ],
					-qualifiers => [ -array_id         => $array->dbID ]);
		}
		elsif ($array->num_probesets != $self->num_probesets) {
			return "Number of probesets read [" . $self->num_probesets . "] not equal to array library probesets specification ".
				"[@{[$array->num_probesets]}]";
		}
	}

	return (); #no errors
}


1;
