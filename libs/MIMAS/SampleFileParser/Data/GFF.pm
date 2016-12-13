# GFF.pm
# Accessor for SampleFile GFF data
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::SampleFileParser::Data::GFF;

use strict;
use warnings;
use base qw(MIMAS::SampleFileParser::Data);

our $VERSION = 1.00;

sub fh: lvalue {$_[0]->{fh}}
sub headers: lvalue {$_[0]->{headers}}


sub new {
	@_ == 3 or die "Invalid number of arguments";
	my ($invocant, $fh, $basename) = @_;

	my $self = $invocant->SUPER::new('GFF', [$basename], undef, undef);

	$self->fh = $fh;
	$self->headers = {};

	return $self;
}


sub quickcheck {
	my $self = shift;
	1 while $self->getline();
}


sub getline {
	my $self = shift;
	my $max_batchsize = shift || 50000;
	my @stack;
	while(my $ft = $self->next_feature()) {
		push @stack, $ft;
		last if @stack >= $max_batchsize;
	}
	return @stack;
}

sub all_headers {
	my $self = shift;
	return $self->headers();
}

sub next_feature {
	my ($self) = @_;
	my $fh = $self->fh;

	my $gff_string;

	while($gff_string = <$fh>) {
		if ($gff_string =~ /^\#\#\#/) {
			# all forward refs have been seen; TODO
		}
		if ($gff_string =~ /^\#\#(\S+)\s*(.*)/) {
			push @{$self->headers->{$1}}, $2;
		}
		next if($gff_string =~ /^\#/ || $gff_string =~ /^\s*$/ ||
				$gff_string =~ m{^//});

		while ($gff_string =~ /^\>(.+)/) {
			die "FASTA currently not supported";
		}
		last; 
	}
	return unless $gff_string;

	return $self->_from_gff3_string($gff_string);
}

sub _from_gff3_string {
	my ($self, $string) = @_;
	$string =~ s/\s+\Z//;

	my ($seqname, $source, $primary, $start, $end,
			$score, $strand, $frame, $groups) = split(/\t/, $string);

	if ( !defined $frame ) {
		die("[$string] does not look like GFF3 to me");
	}
	$score = undef if $score eq '.';
	my $fstrand = $strand eq '+' ? 1 : $strand eq '-' ? -1 : $strand eq '.' ? 0 : undef;

	my @groups = split(/\s*;\s*/, $groups || '');
	my %attrib;
	for my $group (@groups) {
		next if $group eq '.' or $group eq '';
		my ($tag,$value) = split /=/,$group;
		$tag             = unescape($tag);
		my @values       = map {unescape($_)} split /,/,$value;
		push @{$attrib{$tag} ||= []}, @values;
#		for my $v ( @values ) {  $feat->add_tag_value($tag,$v); }
	}

	return [
		$primary, #"probeset"
		$score, #"signal"
		$seqname, #seq_region_id
		$start, #seq_region_start
		$end, #seq_region_end
		$fstrand, #seq_region_strand
		$attrib{'Name'}[0] || $attrib{'Target'}[0] || $attrib{'Site'}[0], #label
		$attrib{'Note'}[0] || $attrib{'Description'}[0], #note
		$attrib{'Dbxref'}[0], #dbxref
		];
}

# taken from Bio::DB::GFF
sub unescape {
	my $v = shift;
	$v =~ tr/+/ /;
	$v =~ s/%([0-9a-fA-F]{2})/chr hex($1)/ge;
	return $v;
}


1;
