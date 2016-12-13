# AttrDetail.pm
# MIMAS Library Attribute Detail Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Library::AttrDetail;

use strict;
use warnings;
use base qw(MIMAS::DB::BaseDataEntity);

our $VERSION = 1.00;


sub name {
    my $self = shift;
    $self->{name} = shift if @_;
    return $self->{name};
}


sub type {
    my $self = shift;
    $self->{type} = shift if @_;
    return $self->{type};
}


sub deprecated {
    my $self = shift;
    $self->{deprecated} = shift if @_;
    return $self->{deprecated};
}


sub default {
    my $self = shift;
    $self->{default} = shift if @_;
    return $self->{default};
}


sub display_order {
    my $self = shift;
    $self->{display_order} = shift if @_;
    return $self->{display_order};
}


sub base_conv_scalar {
    my $self = shift;
    $self->{base_conv_scalar} = shift if @_;
    return $self->{base_conv_scalar};
}


sub base_conv_factor {
    my $self = shift;
    $self->{base_conv_factor} = shift if @_;
    return $self->{base_conv_factor};
}


sub description {
    my $self = shift;
    $self->{description} = shift if @_;
    return $self->{description};
}


sub link_id {
    my $self = shift;
    $self->{link_id} = shift if @_;
    return $self->{link_id};
}


sub group {
    my $self = shift;
    $self->{group} = $self->adaptor->area->AttrDetailGroupAdaptor->select_by_dbID($self->{attr_detail_group_id}) unless defined $self->{group};
    return $self->{group};
}


sub attribute {
    my $self = shift;
    $self->{attribute} = $self->adaptor->area->AttributeAdaptor->select_by_dbID($self->{attribute_id}) unless defined $self->{attribute};
    return $self->{attribute};
}

sub mage_name {
    my $self = shift;
    $self->{mage_name} = shift if @_;
    return $self->{mage_name};
}


1;

