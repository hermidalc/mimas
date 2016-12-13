# Data.pm
# Accessor for SampleFile data
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::SampleFileParser::Data;

use strict;
use warnings;
use base qw(Root);

our $VERSION = 1.00;

sub format: lvalue {$_[0]->{_format}}
sub hybridization_names: lvalue {$_[0]->{_hybridization_names}}
sub array_name: lvalue {$_[0]->{_array_name}}
sub hybridization_date: lvalue {$_[0]->{_hybridization_date}}


sub new {
	@_ == 5 or die "Invalid number of arguments";
    my ($invocant, $format, $hybridization_names, $array_name, $hybridization_date) = @_;
	ref $hybridization_names eq "ARRAY" or die "Invalid type of argument 3";
    
    my $class = ref($invocant) || $invocant;
    my $self  = { };
    bless $self, $class;

	$self->format = $format;
	$self->hybridization_names = $hybridization_names;
	$self->array_name = $array_name;
	$self->hybridization_date = $hybridization_date;
    
    return $self;
}


sub getline {
	my $self = shift;
	die "MIMAS::SampleFileParser::Data->getline is abstract. It must be overridden in package $self";
}


sub all_headers {
	return undef;
}


sub validate_on_sample {
	my ($self, $sample, $no_num_check) = @_;

	return "Sample has no attached array" unless $sample->array;
	my $array = $sample->array;

	if (defined $self->array_name and lc $self->array_name ne lc $array->design_name) {
		return "Upload DB sample array name [" . $array->design_name. "] " .
			"not equal to file array name [" . $self->array_name . "]";
	}

	return (); #no errors
}


1;
