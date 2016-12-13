# MgedTerm.pm
# MIMAS Library MGED Ontology Class
#
#######################################################
# Copyright 2003-2005 Alexandre Gattiker
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Library::MgedTerm;

use strict;
use warnings;
use base qw(MIMAS::DB::BaseDataEntity);

our $VERSION = 1.00;


sub mged_name {
    my $self = shift;
    $self->{mged_name} = shift if @_;
    return $self->{mged_name};
}


sub mged_type {
    my $self = shift;
    $self->{mged_type} = shift if @_;
    return $self->{mged_type};
}


sub mage_name_mged {
    my $self = shift;
    $self->{mage_name_mged} = shift if @_;
    return $self->{mage_name_mged};
}


sub mage_name {
    my $self = shift;
    $self->{mage_name} = shift if @_;
    return $self->{mage_name};
}


sub deprecated {
    my $self = shift;
    $self->{deprecated} = shift if @_;
    return $self->{deprecated};
}


sub description {
    my $self = shift;
    $self->{description} = shift if @_;
    return $self->{description};
}


1;

