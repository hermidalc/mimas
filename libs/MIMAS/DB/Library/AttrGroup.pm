# AttrGroup.pm
# MIMAS Library Attribute Group Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Library::AttrGroup;

use strict;
use warnings;
use base qw(MIMAS::DB::BaseDataEntity);

our $VERSION = 1.00;


sub name {
    my $self = shift;
    $self->{name} = shift if @_;
    return $self->{name};
}


sub upload_display_order {
    my $self = shift;
    $self->{upload_display_order} = shift if @_;
    return $self->{upload_display_order};
}


sub view_display_order {
    my $self = shift;
    $self->{view_display_order} = shift if @_;
    return $self->{view_display_order};
}


sub description {
    my $self = shift;
    $self->{description} = shift if @_;
    return $self->{description};
}


sub attributes {
    my $self = shift;
    $self->{attributes} = $self->adaptor->area->AttributeAdaptor->select_all_by_attr_groupID($self->dbID) unless defined $self->{attributes};
    return $self->{attributes};
}


1;

