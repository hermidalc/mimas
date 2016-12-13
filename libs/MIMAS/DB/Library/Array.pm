# Array.pm
# MIMAS Library Array Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Library::Array;

use strict;
use warnings;
use base qw(MIMAS::DB::BaseDataEntity);

our $VERSION = 1.00;


sub design_name {
    my $self = shift;
    $self->{design_name} = shift if @_;
    return $self->{design_name};
}


sub display_name {
    my $self = shift;
    $self->{display_name} = shift if @_;
    return $self->{display_name};
}


sub num_probesets {
    my $self = shift;
    $self->{num_probesets} = shift if @_;
    return $self->{num_probesets};
}


sub num_cel_features {
    my $self = shift;
    $self->{num_cel_features} = shift if @_;
    return $self->{num_cel_features};
}


sub description {
    my $self = shift;
    $self->{description} = shift if @_;
    return $self->{description};
}


sub technology {
    my $self = shift;
    $self->{technology} = $self->adaptor->area->TechnologyAdaptor->select_by_dbID($self->{technology_id}) unless defined $self->{technology};
    return $self->{technology};
}

sub arrayexpress_accession {
    my $self = shift;
    $self->{arrayexpress_accession} = shift if @_;
    return $self->{arrayexpress_accession};
}

sub manufacturer {
    my $self = shift;
    $self->{manufacturer} = shift if @_;
    return $self->{manufacturer};
}

sub cel_files {
    my $self = shift;
    $self->{cel_files} = $self->adaptor->area->db->Repository->CelFileAdaptor->select_all_by_arrayID($self->dbID) unless defined $self->{cel_files};
    return $self->{cel_files};
}


1;

