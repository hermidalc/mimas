# AttrDetailGroup.pm
# MIMAS Library Attribute Detail Group Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Library::AttrDetailGroup;

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


sub description {
    my $self = shift;
    $self->{description} = shift if @_;
    return $self->{description};
}


sub attribute {
    my $self = shift;
    $self->{attribute} = $self->adaptor->area->AttributeAdaptor->select_by_dbID($self->{attribute_id}) unless defined $self->{attribute};
    return $self->{attribute};
}


sub details {
    my $self = shift;
    $self->{details} = $self->adaptor->area->AttrDetailAdaptor->select_all_by_groupID($self->dbID) unless defined $self->{details};
    return $self->{details};
}


1;

