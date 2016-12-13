# FactorGroupAdaptor.pm
# MIMAS Library Factor Group Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Library::Adaptors::FactorGroupAdaptor;

use strict;
use warnings;
use MIMAS::DB::Library::FactorGroup;
use base qw(MIMAS::DB::BaseAdaptor);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $area = shift;
    
    my $self = $class->SUPER::new(-area => $area,
                                  -name => 'FactorGroup');
    
    return $self;
}


# only used internally
sub _create_object {
    my $self = shift;
    
    # Arguments
    my $row = shift;
    
    return MIMAS::DB::Library::FactorGroup->new(adaptor              => $self,
                                                dbID                 => $row->{factor_group_id},
                                                name                 => $row->{name},
						upload_display_order => $row->{upload_display_order},
						view_display_order   => $row->{view_display_order},
					        description          => $row->{description});
}


# only used internally
sub _create_object_collection {
    my $self = shift;
    
    # Arguments
    my $rows = shift;
    
    my $groups;
    for my $row (@{$rows}) { $groups->{$row->{factor_group_id}} = $self->_create_object($row) }
    
    return $groups;
}


sub select_all {
    my $self = shift;
    
    my $rows = $self->db_select();
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_by_name {
    my $self = shift;
    
    # Arguments
    my $name = shift;
    
    my $row = $self->db_select($name);
    
    return $row ? $self->_create_object($row) : undef;
}


sub select_by_name_ci {
    my $self = shift;
    
    # Arguments
    my $name = shift;
    
    my $row = $self->db_select($name);
    
    return $row ? $self->_create_object($row) : undef;
}


sub select_by_dbID {
    my $self = shift;
    
    # Arguments
    my $dbID = shift;
    
    my $row = $self->db_select($dbID);
    
    return $row ? $self->_create_object($row) : undef;
}


sub store {
    my $self = shift;
    
    my $order = [qw( NAME
		     DESCRIPTION )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    my $factor_group_id = $self->area->IncrementerAdaptor->get_new_groupID();
    unshift @values, $factor_group_id;
    
    my $success = $self->db_insert(-values => \@values);
    
    return $success ? $factor_group_id : undef;
}


1;

