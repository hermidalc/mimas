# SampleAttributeAdaptor.pm
# MIMAS Upload Sample Attribute Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Upload::Adaptors::SampleAttributeAdaptor;

use strict;
use warnings;
use MIMAS::DB::Upload::SampleAttribute;
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
    
    return MIMAS::DB::Upload::SampleAttribute->new(adaptor        => $self,
	                                           dbID           => $row->{sample_attribute_id},
						   char_value     => $self->decode_clob($row->{char_value}),
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


sub _create_object_collection_extended {
    my $self = shift;
    
    # Arguments
    my $rows = shift;
    
    my $sample_attrs;
    for my $row (@{$rows}) { $sample_attrs->{$row->{attribute_id}}->{$row->{attr_detail_id}} = $self->_create_object($row) }
    
    return $sample_attrs;
}
sub select_all {
    my $self = shift;
    
    my $rows = $self->db_select();
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_by_expID {
    my $self = shift;
    
    # Arguments
    my $experiment_id = shift;
    
    my $rows = $self->db_select($experiment_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_by_sampleID {
    my $self = shift;
    
    # Arguments
    my $sample_id = shift;
    
    my $rows = $self->db_select($sample_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_extended_by_sampleID {
    my $self = shift;
    
    # Arguments
    my $sample_id = shift;
    
    my $rows = $self->db_select($sample_id);
    
    return $rows ? $self->_create_object_collection_extended($rows) : undef;
}


sub select_by_dbID {
    my $self = shift;
    
    # Arguments
    my $dbID = shift;
    
    my $row = $self->db_select($dbID);
    
    return $row ? $self->_create_object($row) : undef;
}


sub remove_all_by_sampleID {
    my $self = shift;
    
    # Arguments
    my $sample_id = shift;
    
    $self->db_delete(-values => [$sample_id]);
}


sub remove_all_by_sample_and_attrID {
    my $self = shift;
    
    my $order = [qw( SAMPLE_ID
                     ATTRIBUTE_ID )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    $self->db_delete(-values => \@values);
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


sub update {
    my $self = shift;
    
    my $order = [qw( SET
                     QUALIFIERS )];
    
    # Arguments
    my ($set_params, $qual_params) = $self->rearrange_params($order, @_);
    
    $self->db_update(-set_params  => $set_params,
		     -qual_params => $qual_params);
}


1;

