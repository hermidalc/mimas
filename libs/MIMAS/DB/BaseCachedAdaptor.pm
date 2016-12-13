# BaseCachedAdaptor.pm
# MIMAS Base Class for all cached Adaptor Classes
#
#######################################################
# Copyright 2006-2006 Alexandre Gattiker
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::BaseCachedAdaptor;

use strict;
use warnings;
use base qw(MIMAS::DB::BaseAdaptor);
use Carp;

our $VERSION = 1.00;


sub cache {
    my $self = shift;
    
    # Arguments
    my $strategy = shift;

    if ($strategy == 1) {
    }
    elsif ($strategy == 2) {
        $self->{_cache} = $self->select_all;
    }
}


sub select_by_dbID {
    my $self = shift;
    
    # Arguments
    my $dbID = shift;
    unless (defined $dbID) {
        Carp::cluck("Must pass a dbID");
        return undef;
    }

    if (defined $self->{_cache} and exists $self->{_cache}->{$dbID}) {
        return $self->{_cache}->{$dbID};
    }
    
    my $row = $self->db_select($dbID);
    
    my $obj = $row ? $self->_create_object($row) : undef;

    if (defined $self->{_cache} and defined $obj) {
        $self->{_cache}->{$dbID} = $obj;
    }

    return $obj;
}


1;

