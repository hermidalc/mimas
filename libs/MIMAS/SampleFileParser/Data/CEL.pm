# CEL.pm
# Accessor for SampleFile CEL data
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::SampleFileParser::Data::CEL;

use strict;
use warnings;
use base qw(MIMAS::SampleFileParser::Data);

our $VERSION = 1.00;

sub fh: lvalue {$_[0]->{fh}}
sub num_cel_features: lvalue {$_[0]->{num_cel_features}}


sub new {
	@_ == 6 or die "Invalid number of arguments";
	my ($invocant, $fh, $basename, $array_name, $hybridization_date, $num_cel_features) = @_;

	my $self = $invocant->SUPER::new('CEL', [$basename], $array_name, $hybridization_date);

	$self->fh = $fh;
	$self->num_cel_features = $num_cel_features;

	return $self;
}


sub quickcheck {
	my $self = shift;
	#nothing to do, CEL files parsed by constructor
}


sub validate_on_sample {
	my ($self, $sample, $no_num_check) = @_;

	my @super = $self->SUPER::validate_on_sample($sample, $no_num_check);
	return @super if @super;

	return "Sample has no attached array" unless $sample->array;
	my $array = $sample->array;

	defined $self->num_cel_features or die "Invalid state";
	# Check number of CEL features
	if (!defined $array->num_cel_features) {
		$array->adaptor->update(-set        => [ -num_cel_features => $self->num_cel_features       ],
				-qualifiers => [ -array_id         => $array->dbID ]);
	} elsif ($array->num_cel_features != $self->num_cel_features) {
		return "Number of CEL features read [" . $self->num_cel_features . "] not equal to array library CEL features specification ",
			   "[@{[$array->num_cel_features]}]";
	}

	return (); #no errors
}

1;

