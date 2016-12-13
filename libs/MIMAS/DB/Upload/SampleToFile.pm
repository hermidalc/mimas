# SampleToFile.pm
# MIMAS Upload Sample File Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Upload::SampleToFile;

use strict;
use warnings;
use base qw(MIMAS::DB::BaseDataEntity);

our $VERSION = 1.00;


sub format {
    my $self = shift;
    $self->{format} = shift if @_;
    return $self->{format};
}


sub is_germonline {
    my $self = shift;
    $self->{is_germonline} = shift if @_;
    return $self->{is_germonline};
}


sub hybridization_name {
    my $self = shift;
    $self->{hybridization_name} = shift if @_;
    return $self->{hybridization_name};
}


sub sample {
    my $self = shift;
    $self->{sample} = $self->adaptor->area->SampleAdaptor->select_by_dbID($self->{sample_id}) unless defined $self->{sample};
    return $self->{sample};
}


sub sample_file {
    my $self = shift;
    $self->{sample_file} = $self->adaptor->area->SampleFileAdaptor->select_by_dbID($self->{sample_file_id}) unless defined $self->{sample_file};
    return $self->{sample_file};
}


#used by GermOnline, for speed
sub _sample_id {
    my $self = shift;
    $self->{sample_id} = shift if @_;
    return $self->{sample_id};
}

1;

