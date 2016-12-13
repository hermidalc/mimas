# AttrDetailGroupAdaptor.pm
# MIMAS Library Attribute Detail Group Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Library::Adaptors::AttrDetailGroupAdaptor;

use strict;
use warnings;
use MIMAS::DB::Library::AttrDetailGroup;
use base qw(MIMAS::DB::BaseAdaptor);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $area = shift;
    
    my $self = $class->SUPER::new(-area => $area,
                                  -name => 'AttrDetailGroup');
    
    return $self;
}


# only used internally
sub _create_object {
    my $self = shift;
    
    # Arguments
    my $row = shift;
    
    return MIMAS::DB::Library::AttrDetailGroup->new(adaptor       => $self,
                                                    dbID          => $row->{attr_detail_group_id},
                                                    name          => $row->{name},
						    display_order => $row->{display_order},
						    description   => $row->{description},
						    attribute_id  => $row->{attribute_id});
}


# only used internally
sub _create_object_collection {
    my $self = shift;
    
    # Arguments
    my $rows = shift;
    
    my $groups;
    for my $row (@{$rows}) { $groups->{$row->{attr_detail_group_id}} = $self->_create_object($row) }
    
    return $groups;
}


sub select_all {
    my $self = shift;
    
    my $rows = $self->db_select();
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_by_attrID {
    my $self = shift;
    
    # Arguments
    my $attribute_id = shift;
    
    my $rows = $self->db_select($attribute_id);
    
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
		     DESCRIPTION
		     ATTRIBUTE_ID )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    my $detail_group_id = $self->area->IncrementerAdaptor->get_new_detail_groupID();
    unshift @values, $detail_group_id;
    
    my $success = $self->db_insert(-values => \@values);
    
    return $success ? $detail_group_id : undef;
}


1;

