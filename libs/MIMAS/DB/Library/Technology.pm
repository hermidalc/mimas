# Technology.pm
# MIMAS Library Technology Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Library::Technology;

use strict;
use warnings;
use base qw(MIMAS::DB::BaseDataEntity);

our $VERSION = 1.00;


sub name {
    my $self = shift;
    $self->{name} = shift if @_;
    return $self->{name};
}


sub display_name {
    my $self = shift;
    $self->{display_name} = shift if @_;
    return $self->{display_name};
}


sub default_manufacturer {
    my $self = shift;
    $self->{default_manufacturer} = shift if @_;
    return $self->{default_manufacturer};
}


1;

