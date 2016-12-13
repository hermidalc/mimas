# Job.pm
# MIMAS Web External Job Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Web::Job;

use strict;
use warnings;
use base qw(MIMAS::DB::BaseDataEntity);

our $VERSION = 1.00;


sub type {
    my $self = shift;
    $self->{type} = shift if @_;
    return $self->{type};
}


sub request_time {
    my $self = shift;
    $self->{request_time} = shift if @_;
    return $self->{request_time};
}


sub data {
    my $self = shift;
    $self->{data} = shift if @_;
    return $self->{data};
}


sub user {
    my $self = shift;
    $self->{user} = $self->adaptor->area->db->User->UserAdaptor->select_by_dbID($self->{user_id}) unless defined $self->{user};
    return $self->{user};
}


1;

