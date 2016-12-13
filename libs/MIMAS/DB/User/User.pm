# User.pm
# MIMAS User User Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::User::User;

use strict;
use warnings;
use base qw(MIMAS::DB::BaseDataEntity);

our $VERSION = 1.00;


sub username {
    my $self = shift;
    $self->{username} = shift if @_;
    return $self->{username};
}


sub password {
    my $self = shift;
    $self->{password} = shift if @_;
    return $self->{password};
}


sub disabled {
    my $self = shift;
    $self->{disabled} = shift if @_;
    return $self->{disabled};
}


sub first_name {
    my $self = shift;
    $self->{first_name} = shift if @_;
    return $self->{first_name};
}


sub short_name {
    my $self = shift;
    return
        substr($self->first_name, 0, 1)
        . '.'
        . ' ' . $self->last_name
        ;
}

sub full_name {
    my $self = shift;
    return
        $self->first_name
        .  (defined $self->middle_name ? ' ' . $self->middle_name : '')
        . ' ' . $self->last_name
        ;
}

sub full_name_reversed {
    my $self = shift;
    return
        $self->last_name . ', '
        . $self->first_name
        .  (defined $self->middle_name ? ' ' . $self->middle_name : '')
        ;
}


sub middle_name {
    my $self = shift;
    $self->{middle_name} = shift if @_;
    return $self->{middle_name};
}


sub last_name {
    my $self = shift;
    $self->{last_name} = shift if @_;
    return $self->{last_name};
}


sub position {
    my $self = shift;
    $self->{position} = shift if @_;
    return $self->{position};
}


sub email {
    my $self = shift;
    $self->{email} = shift if @_;
    return $self->{email};
}


sub phone {
    my $self = shift;
    $self->{phone} = shift if @_;
    return $self->{phone};
}


sub fax {
    my $self = shift;
    $self->{fax} = shift if @_;
    return $self->{fax};
}


sub reg_date {
    my $self = shift;
    $self->{reg_date} = shift if @_;
    return $self->{reg_date};
}


sub working_data {
    my $self = shift;
    $self->{working_data} = shift if @_;
    return $self->{working_data};
}


sub title {
    my $self = shift;
    $self->{title} = $self->adaptor->area->TitleAdaptor->select_by_dbID($self->{title_id}) unless defined $self->{title};
    return $self->{title};
}


sub lab {
    my $self = shift;
    $self->{lab} = $self->adaptor->area->LabAdaptor->select_by_dbID($self->{lab_id}) unless defined $self->{lab};
    return $self->{lab};
}


sub is_pi {
    my $self = shift;
    $self->{is_pi} = $self->lab->pi_email eq $self->email ? 1 : 0 unless defined $self->{is_pi};
    return $self->{is_pi};
}

sub is_admin {
    my $self = shift;
   $self->{is_admin} = $self->adaptor->area->AuthAdaptor->auth_admin(-user_id => $self->dbID) unless defined $self->{is_admin};
    return $self->{is_admin};
}

sub is_curator {
    my $self = shift;
   $self->{is_curator} = $self->adaptor->area->AuthAdaptor->auth_curator(-user_id => $self->dbID) unless defined $self->{is_curator};
    return $self->{is_curator};
}


sub groups {
    my $self = shift;
   $self->{groups} = $self->adaptor->area->GroupAdaptor->select_all_by_userID($self->dbID) unless defined $self->{groups};
    return $self->{groups};
}


sub facilities {
    my $self = shift;
   $self->{facilities} = $self->adaptor->area->db->Library->AttrDetailAdaptor->select_all_facilities_by_userID($self->dbID) unless defined $self->{facilities};
    return $self->{facilities};
}


sub experiments {
    my $self = shift;
    $self->{experiments} = $self->adaptor->area->db->Upload->ExperimentAdaptor->select_all_by_ownerID($self->dbID) unless defined $self->{experiments};
    return $self->{experiments};
}


sub curator_experiments {
    my $self = shift;
    $self->{curator_experiments} = $self->adaptor->area->db->Upload->ExperimentAdaptor->select_all_by_curatorID($self->dbID) unless defined $self->{curator_experiments};
    return $self->{curator_experiments};
}


sub samples {
    my $self = shift;
    $self->{samples} = $self->adaptor->area->db->Repository->SampleAdaptor->select_all_by_ownerID($self->dbID) unless defined $self->{samples};
    return $self->{samples};
}


sub jobs {
    my $self = shift;
    $self->{jobs} = $self->adaptor->area->db->Web->JobAdaptor->select_all_by_userID($self->dbID) unless defined $self->{jobs};
    return $self->{jobs};
}


sub alerts {
    my $self = shift;
    $self->{alerts} = $self->adaptor->area->db->Web->AlertAdaptor->select_all_by_userID($self->dbID) unless defined $self->{alerts};
    return $self->{alerts};
}


1;

