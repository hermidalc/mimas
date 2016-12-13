# ExpCondition.pm
# MIMAS Upload Experiment Condition Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Upload::ExpCondition;

use strict;
use warnings;
use base qw(MIMAS::DB::BaseDataEntity);

our $VERSION = 1.00;


sub name {
    my $self = shift;
    $self->{name} = shift if @_;
    return $self->{name};
}


sub display_order {
    my $self = shift;
    $self->{display_order} = shift if @_;
    return $self->{display_order};
}


sub experiment {
    my $self = shift;
    $self->{experiment} = $self->adaptor->area->ExperimentAdaptor->select_by_dbID($self->{experiment_id}) unless defined $self->{experiment};
    return $self->{experiment};
}


sub color {
    my $self = shift;
    $self->{color} = shift if @_;
    return $self->{color};
}


sub samples {
    my $self = shift;
    $self->{samples} = $self->adaptor->area->SampleAdaptor->select_all_by_condID($self->dbID) unless defined $self->{samples};
    return $self->{samples};
}


sub files {
    my $self = shift;
    $self->{files} = $self->adaptor->area->SampleFileAdaptor->select_all_by_condID($self->dbID) unless defined $self->{files};
    return $self->{files};
}


1;

