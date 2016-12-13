# FactorGroup.pm
# MIMAS Library Factor Group Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Library::FactorGroup;

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


sub factors {
    my $self = shift;
    $self->{factors} = $self->adaptor->area->FactorAdaptor->select_all_by_factor_groupID($self->dbID) unless defined $self->{factors};
    return $self->{factors};
}


1;

