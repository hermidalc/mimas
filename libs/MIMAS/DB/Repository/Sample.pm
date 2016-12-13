# Sample.pm
# MIMAS Repository Sample Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Repository::Sample;

use strict;
use warnings;
use base qw(MIMAS::DB::BaseDataEntity);

our $VERSION = 1.00;


sub owner {
    my $self = shift;
    $self->{owner} = $self->adaptor->area->db->User->UserAdaptor->select_by_dbID($self->{owner_id}) unless defined $self->{owner};
    return $self->{owner};
}


sub cel_file {
    my $self = shift;
    $self->{cel_file} = $self->adaptor->area->CelFileAdaptor->select_by_dbID($self->{cel_file_id}) unless defined $self->{cel_file};
    return $self->{cel_file};
}


sub txt_file {
    my $self = shift;
    $self->{txt_file} = $self->adaptor->area->TxtFileAdaptor->select_by_dbID($self->{txt_file_id}) unless defined $self->{txt_file};
    return $self->{txt_file};
}


sub attributes {
    my $self = shift;
    $self->{attributes} = $self->adaptor->area->SampleAttributeAdaptor->select_all_by_sampleID($self->dbID) unless defined $self->{attributes};
    return $self->{attributes};
}


1;

