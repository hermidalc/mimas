# SampleFileParser.pm
# MIMAS Base Class for all SampleFileParser Objects
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::SampleFileParser;

use strict;
use warnings;
use base qw(Root);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    my $self  = { };
    bless $self, $class;
    
    my $order = [qw(
		     FORMAT
		     )];
    
    # Arguments
    my ($format, $basename) = $self->rearrange_params($order, @_);

	my $subclass = "MIMAS::SampleFileParser::$format";
	my $package = "MIMAS/SampleFileParser/$format.pm";
	require $package;

	bless $self, $subclass;
    
    return $self;
}


sub is_normalized {
	my ($self) = @_;
	die "MIMAS::SampleFileParser->is_normalized is abstract. It must be overridden in package $self";
}


sub parse {
	my ($self, $fh, $basename, $hybridization_name) = @_; #fh must be IO::Seekable object
	die "MIMAS::SampleFileParser->parse is abstract. It must be overridden in package $self";
}


1;
