# SampleAttributeAdaptor.pm
# MIMAS Repository Sample Attribute Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Repository::Adaptors::SampleAttributeAdaptor;

use strict;
use warnings;
use MIMAS::DB::Repository::SampleAttribute;
use base qw(MIMAS::DB::BaseAdaptor);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $area = shift;
    
    my $self = $class->SUPER::new(-area => $area,
                                  -name => 'SampleAttribute');
    
    return $self;
}


# only used internally
sub _create_object {
    my $self = shift;
    
    # Arguments
    my $row = shift;
    
    return MIMAS::DB::Repository::SampleAttribute->new(adaptor        => $self,
	                                               dbID           => $row->{sample_attribute_id},
						       char_value     => $row->{char_value},
						       numeric_value  => $row->{numeric_value},
						       attr_detail_id => $row->{attr_detail_id},
						       attribute_id   => $row->{attribute_id},
						       sample_id      => $row->{sample_id});
}


# only used internally
sub _create_object_collection {
    my $self = shift;
    
    # Arguments
    my $rows = shift;
    
    my $sample_attrs;
    for my $row (@{$rows}) { $sample_attrs->{$row->{sample_attribute_id}} = $self->_create_object($row) }
    
    return $sample_attrs;
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


sub select_all_by_sampleID {
    my $self = shift;
    
    # Arguments
    my $sample_id = shift;
    
    my $rows = $self->db_select($sample_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_by_attr_name_sampleID {
    my $self = shift;
    
    my $order = [qw( ATTRIBUTE_NAME
		     SAMPLE_ID )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    my $rows = $self->db_select(@values);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
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
    
    my $order = [qw( CHAR_VALUE
		     NUMERIC_VALUE
		     ATTR_DETAIL_ID
		     ATTRIBUTE_ID
		     SAMPLE_ID )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    my $sample_attr_id = $self->area->IncrementerAdaptor->get_new_sample_attrID();
    unshift @values, $sample_attr_id;

    my $success = $self->db_insert(-values => \@values);
    
    return $success ? $sample_attr_id : undef;
}


1;

