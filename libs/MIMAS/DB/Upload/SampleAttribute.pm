# SampleAttribute.pm
# MIMAS Upload Sample Attribute Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Upload::SampleAttribute;

use strict;
use warnings;
use base qw(MIMAS::DB::BaseDataEntity);

our $VERSION = 1.00;


sub char_value {
    my $self = shift;
    $self->{char_value} = shift if @_;
    return $self->{char_value};
}


sub numeric_value {
    my $self = shift;
    $self->{numeric_value} = shift if @_;
    return $self->{numeric_value};
}


sub detail {
    my $self = shift;
    return undef unless defined $self->{attr_detail_id};
    $self->{detail} = $self->adaptor->area->db->Library->AttrDetailAdaptor->select_by_dbID($self->{attr_detail_id}) unless defined $self->{detail};
    return $self->{detail};
}


sub attribute {
    my $self = shift;
    $self->{attribute} = $self->adaptor->area->db->Library->AttributeAdaptor->select_by_dbID($self->{attribute_id}) unless defined $self->{attribute};
    return $self->{attribute};
}


sub sample {
    my $self = shift;
    $self->{sample} = $self->adaptor->area->SampleAdaptor->select_by_dbID($self->{sample_id}) unless defined $self->{sample};
    return $self->{sample};
}


1;

