# Sample.pm
# MIMAS Upload Sample Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Upload::Sample;

use strict;
use warnings;
use base qw(MIMAS::DB::BaseDataEntity);

our $VERSION = 1.00;


sub name {
    my $self = shift;
    $self->{name} = shift if @_;
    return $self->{name};
}


sub attrs_complete {
    my $self = shift;
    $self->{attrs_complete} = shift if @_;
    return $self->{attrs_complete};
}


sub attrs_exist {
    my $self = shift;
    $self->{attrs_exist} = shift if @_;
    return $self->{attrs_exist};
}


sub array {
    my $self = shift;
    $self->{array} = $self->adaptor->area->db->Library->ArrayAdaptor->select_by_dbID($self->{array_id}) unless defined $self->{array};
    return $self->{array};
}


sub condition {
    my $self = shift;
    $self->{condition} = $self->adaptor->area->ExpConditionAdaptor->select_by_dbID($self->{condition_id}) unless defined $self->{condition};
    return $self->{condition};
}


sub experiment {
    my $self = shift;
    $self->{experiment} = $self->adaptor->area->ExperimentAdaptor->select_by_dbID($self->{experiment_id}) unless defined $self->{experiment};
    return $self->{experiment};
}


#used by GermOnline, for speed
sub _condition_id {
    my $self = shift;
    $self->{condition_id} = shift if @_;
    return $self->{condition_id};
}


sub attributes {
    my $self = shift;
    $self->{attributes} = $self->adaptor->area->SampleAttributeAdaptor->select_all_by_sampleID($self->dbID) unless defined $self->{attributes};
    return $self->{attributes};
}


sub extended_attributes {
    my $self = shift;
    $self->{extended_attributes} = $self->adaptor->area->SampleAttributeAdaptor->select_all_extended_by_sampleID($self->dbID) unless defined $self->{extended_attributes};
    return $self->{extended_attributes};
}


sub sample_to_files {
    my $self = shift;
    $self->{sample_to_files} = $self->adaptor->area->SampleToFileAdaptor->select_all_by_sampleID($self->dbID) unless defined $self->{sample_to_files};
    return $self->{sample_to_files};
}


sub files {
    my $self = shift;
    $self->{files} = $self->adaptor->area->SampleFileAdaptor->select_all_by_sampleID($self->dbID) unless defined $self->{files};
    return $self->{files};
}


1;

