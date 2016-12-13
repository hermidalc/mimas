# ArraySeries.pm
# MIMAS Library Array Series Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Library::ArraySeries;

use strict;
use warnings;
use base qw(MIMAS::DB::BaseDataEntity);

our $VERSION = 1.00;


sub name {
    my $self = shift;
    $self->{name} = shift if @_;
    return $self->{name};
}


sub display_name {
    my $self = shift;
    $self->{display_name} = shift if @_;
    return $self->{display_name};
}


sub alt_name {
    my $self = shift;
    $self->{alt_name} = shift if @_;
    return $self->{alt_name};
}


sub manufacturer {
    my $self = shift;
    $self->{manufacturer} = shift if @_;
    return $self->{manufacturer};
}


sub type {
    my $self = shift;
    $self->{type} = shift if @_;
    return $self->{type};
}


sub description {
    my $self = shift;
    $self->{description} = shift if @_;
    return $self->{description};
}


sub arrays {
    my $self = shift;
    $self->{arrays} = $self->adaptor->area->ArrayAdaptor->select_all_by_seriesID($self->dbID) unless defined $self->{arrays};
    return $self->{arrays};
}


sub cel_files {
    my $self = shift;
    $self->{cel_files} = $self->adaptor->area->db->Repository->CelFileAdaptor->select_all_by_seriesID($self->dbID) unless defined $self->{cel_files};
    return $self->{cel_files};
}


1;

