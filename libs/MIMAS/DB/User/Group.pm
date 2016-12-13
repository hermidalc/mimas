# Group.pm
# MIMAS User Group Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::User::Group;

use strict;
use warnings;
use base qw(MIMAS::DB::BaseDataEntity);

our $VERSION = 1.00;


sub name {
    my $self = shift;
    $self->{name} = shift if @_;
    return $self->{name};
}


sub users {
    my $self = shift;
    @_ == 1 or die "Must pass an Experiment object to Group->users, so that automatic groups can be returned as well";
    my $experiment = shift;
    my $experiment_id = $experiment->dbID;
    $self->{users}{$experiment_id} = $self->adaptor->area->UserAdaptor->select_all_by_groupID_experiment($self->dbID, $experiment) unless defined $self->{users}{$experiment_id};
    return $self->{users}{$experiment_id};
}


sub is_default_reader {
    my $self = shift;
    $self->{is_default_reader} = shift if @_;
    return $self->{is_default_reader};
}


sub is_default_writer {
    my $self = shift;
    $self->{is_default_writer} = shift if @_;
    return $self->{is_default_writer};
}


sub is_system {
    my $self = shift;
    $self->{is_system} = shift if @_;
    return $self->{is_system};
}


sub is_auto {
    my $self = shift;
    $self->{is_auto} = shift if @_;
    return $self->{is_auto};
}


sub restrict_level {
    my $self = shift;
    $self->{restrict_level} = shift if @_;
    return $self->{restrict_level};
}


sub description {
    my $self = shift;
    $self->{description} = shift if @_;
    return $self->{description};
}


1;

