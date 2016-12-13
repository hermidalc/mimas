# MgedTermAdaptor.pm
# MIMAS Library Attribute Group Adaptor Class
#
#######################################################
# Copyright 2003-2005 Alexandre Gattiker
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Library::Adaptors::MgedTermAdaptor;

use strict;
use warnings;
use MIMAS::DB::Library::MgedTerm;
use base qw(MIMAS::DB::BaseAdaptor);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $area = shift;
    
    my $self = $class->SUPER::new(-area => $area,
                                  -name => 'MgedTerm');
    
    return $self;
}


# only used internally
sub _create_object {
    my $self = shift;
    
    # Arguments
    my $row = shift;
    
    return MIMAS::DB::Library::MgedTerm->new(
        adaptor => $self,
        mged_name => $row->{mged_name},
        mged_type => $row->{mged_type},
        mage_name_mged => $row->{mage_name_mged},
        mage_name => $row->{mage_name},
        deprecated => $row->{deprecated},
        description => $row->{description},
    );
}


# only used internally
sub _create_object_collection {
    my $self = shift;
    
    # Arguments
    my $rows = shift;
    
    my $groups;
    for my $row (@{$rows}) { $groups->{$row->{mage_name}} = $self->_create_object($row) }
    
    return $groups;
}


sub select_all {
    my $self = shift;
    
    my $rows = $self->db_select();
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_by_mage_name {
    my $self = shift;
    
    # Arguments
    my $mage_name = shift;
    
    my $row = $self->db_select($mage_name);
    
    return $row ? $self->_create_object($row) : undef;
}


sub store {
    my $self = shift;
    
    my $order = [qw(
    MGED_NAME
    MGED_TYPE
    MAGE_NAME_MGED
    MAGE_NAME
    DEPRECATED
    DESCRIPTION
    )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    my $success = $self->db_insert(-values => \@values);
    
    return $success ? 1 : undef;
}


sub remove_all {
    my $self = shift;
    
    $self->db_delete(-values => []);
}


1;

