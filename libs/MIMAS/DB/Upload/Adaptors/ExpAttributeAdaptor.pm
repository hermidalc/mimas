# ExpAttributeAdaptor.pm
# MIMAS Upload Experiment Attribute Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Upload::Adaptors::ExpAttributeAdaptor;

use strict;
use warnings;
use MIMAS::DB::Upload::ExpAttribute;
use base qw(MIMAS::DB::BaseAdaptor);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $area = shift;
    
    my $self = $class->SUPER::new(-area => $area,
                                  -name => 'ExpAttribute');
    
    return $self;
}


# only used internally
sub _create_object {
    my $self = shift;
    
    # Arguments
    my $row = shift;
    
    return MIMAS::DB::Upload::ExpAttribute->new(adaptor        => $self,
	                                        dbID           => $row->{exp_attribute_id},
						char_value     => $self->decode_clob($row->{char_value}),
						numeric_value  => $row->{numeric_value},
						attr_detail_id => $row->{attr_detail_id},
						attribute_id   => $row->{attribute_id},
						experiment_id  => $row->{experiment_id});
}


# only used internally
sub _create_object_collection {
    my $self = shift;
    
    # Arguments
    my $rows = shift;
    
    my $exp_attrs;
    for my $row (@{$rows}) { $exp_attrs->{$row->{exp_attribute_id}} = $self->_create_object($row) }
    
    return $exp_attrs;
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


sub select_all_by_attr_name_expID {
    my $self = shift;
    
    my $order = [qw( ATTRIBUTE_NAME
		     EXPERIMENT_ID )];
    
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


sub remove_all_by_expID {
    my $self = shift;
    
    # Arguments
    my $experiment_id = shift;
    
    $self->db_delete(-values => [$experiment_id]);
}


sub store {
    my $self = shift;
    
    my $order = [qw( CHAR_VALUE
		     NUMERIC_VALUE
		     ATTR_DETAIL_ID
		     ATTRIBUTE_ID
		     EXPERIMENT_ID )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    my $exp_attr_id = $self->area->IncrementerAdaptor->get_new_exp_attrID();
    unshift @values, $exp_attr_id;
    
    my $success = $self->db_insert(-values => \@values);
    
    return $success ? $exp_attr_id : undef;
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

