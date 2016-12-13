# Organization.pm
# MIMAS User Organization Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::User::Organization;

use strict;
use warnings;
use base qw(MIMAS::DB::BaseDataEntity);

our $VERSION = 1.00;


sub name {
    my $self = shift;
    $self->{name} = shift if @_;
    return $self->{name};
}


sub url {
    my $self = shift;
    $self->{url} = shift if @_;
    return $self->{url};
}


sub valid {
    my $self = shift;
    $self->{valid} = shift if @_;
    return $self->{valid};
}


sub country {
    my $self = shift;
    $self->{country} = $self->adaptor->area->CountryAdaptor->select_by_dbID($self->{country_id}) unless defined $self->{country};
    return $self->{country};
}


sub labs {
    my $self = shift;
    $self->{labs} = $self->adaptor->area->db->LabAdaptor->select_all_by_orgID($self->dbID) unless $self->{labs};
    return $self->{labs};
}


1;

