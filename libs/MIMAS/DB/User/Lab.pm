# Lab.pm
# MIMAS User Laboratory Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::User::Lab;

use strict;
use warnings;
use base qw(MIMAS::DB::BaseDataEntity);

our $VERSION = 1.00;


sub name {
    my $self = shift;
    $self->{name} = shift if @_;
    return $self->{name};
}


sub address {
    my $self = shift;
    $self->{address} = shift if @_;
    return $self->{address};
}

sub full_address {
    my $self = shift;
    my $address = $self->{address};
    $address .= ", ";
    $address .= $self->{postcode} . " " if defined $self->{postcode};
    $address .= $self->{city};
    $address .= " " . $self->{state} if defined $self->{state};
    $address .= ", " . $self->organization->country->name;
    return $address;
}


sub postcode {
    my $self = shift;
    $self->{postcode} = shift if @_;
    return $self->{postcode};
}


sub state {
    my $self = shift;
    $self->{state} = shift if @_;
    return $self->{state};
}


sub city {
    my $self = shift;
    $self->{city} = shift if @_;
    return $self->{city};
}


sub url {
    my $self = shift;
    $self->{url} = shift if @_;
    return $self->{url};
}


sub pi_name {
    my $self = shift;
    $self->{pi_name} = shift if @_;
    return $self->{pi_name};
}


sub pi_email {
    my $self = shift;
    $self->{pi_email} = shift if @_;
    return $self->{pi_email};
}


sub valid {
    my $self = shift;
    $self->{valid} = shift if @_;
    return $self->{valid};
}


sub organization {
    my $self = shift;
    $self->{organization} = $self->adaptor->area->OrganizationAdaptor->select_by_dbID($self->{organization_id}) unless defined $self->{organization};
    return $self->{organization};
}


sub users {
    my $self = shift;
    $self->{users} = $self->adaptor->area->UserAdaptor->select_all_by_labID($self->dbID) unless defined $self->{users};
    return $self->{users};
}


1;

