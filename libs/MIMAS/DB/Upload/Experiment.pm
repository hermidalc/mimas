# Experiment.pm
# MIMAS Upload Experiment Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Upload::Experiment;

use strict;
use warnings;
use MIMAS::Consts;
use base qw(MIMAS::DB::BaseDataEntity);

our $VERSION = 1.00;


sub name {
    my $self = shift;
    $self->{name} = shift if @_;
    return $self->{name};
}


sub num_hybrids {
    my $self = shift;
    $self->{num_hybrids} = shift if @_;
    return $self->{num_hybrids};
}


sub progress {
    my $self = shift;
    $self->{progress} = shift if @_;
    return $self->{progress};
}


sub state {
    my $self = shift;
    $self->{state} = shift if @_;
    return $self->{state};
}

sub is_curated {
    my $self = shift;
    return defined $self->{curator_id};
}

sub is_germonline {
    my $self = shift;
    $self->{is_germonline} = $self->adaptor->area->SampleToFileAdaptor->select_all_germonline_by_expID($self->dbID) unless defined $self->{is_germonline};
    return $self->{is_germonline};
}

sub owner {
    my $self = shift;
    $self->{owner} = $self->adaptor->area->db->User->UserAdaptor->select_by_dbID($self->{owner_id}) unless defined $self->{owner};
    return $self->{owner};
}


sub curator {
    my $self = shift;
    $self->{curator} = $self->adaptor->area->db->User->UserAdaptor->select_by_dbID($self->{curator_id}) unless defined $self->{curator};
    return $self->{curator};
}


sub attributes {
    my $self = shift;
    $self->{attributes} = $self->adaptor->area->ExpAttributeAdaptor->select_all_by_expID($self->dbID) unless defined $self->{attributes};
    return $self->{attributes};
}


sub conditions {
    my $self = shift;
    $self->{conditions} = $self->adaptor->area->ExpConditionAdaptor->select_all_by_expID($self->dbID) unless defined $self->{conditions};
    return $self->{conditions};
}


sub factors {
    my $self = shift;
    $self->{factors} = $self->adaptor->area->db->Library->AttributeAdaptor->select_all_factors_by_expID($self->dbID) unless defined $self->{factors};
    return $self->{factors};
}


sub samples {
    my $self = shift;
    $self->{samples} = $self->adaptor->area->SampleAdaptor->select_all_by_expID($self->dbID) unless defined $self->{samples};
    return $self->{samples};
}


sub files {
    my $self = shift;
    $self->{files} = $self->adaptor->area->SampleFileAdaptor->select_all_by_expID($self->dbID) unless defined $self->{files};
    return $self->{files};
}


sub read_groups {
    my $self = shift;
    $self->{read_groups} = $self->adaptor->area->db->User->GroupAdaptor->select_all_read_by_expID($self->dbID) unless defined $self->{read_groups};
    return $self->{read_groups};
}

sub write_groups {
    my $self = shift;
    $self->{write_groups} = $self->adaptor->area->db->User->GroupAdaptor->select_all_write_by_expID($self->dbID) unless defined $self->{write_groups};
    return $self->{write_groups};
}


1;

