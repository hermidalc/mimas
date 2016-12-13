# ExpConditionAdaptor.pm
# MIMAS Upload Experiment Condition Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Upload::Adaptors::ExpConditionAdaptor;

use strict;
use warnings;
use MIMAS::DB::Upload::ExpCondition;
use base qw(MIMAS::DB::BaseAdaptor);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $area = shift;
    
    my $self = $class->SUPER::new(-area => $area,
                                  -name => 'ExpCondition');
    
    return $self;
}


# only used internally
sub _create_object {
    my $self = shift;
    
    # Arguments
    my $row = shift;
    
    return MIMAS::DB::Upload::ExpCondition->new(adaptor          => $self,
	                                        dbID             => $row->{condition_id},
					        name             => $self->decode_varchar($row->{name}),
						display_order    => $row->{display_order},
						experiment_id    => $row->{experiment_id},
						color            => $row->{color});
}


# only used internally
sub _create_object_collection {
    my $self = shift;
    
    # Arguments
    my $rows = shift;
    
    my $conditions;
    for my $row (@{$rows}) { $conditions->{$row->{condition_id}} = $self->_create_object($row) }
    
    return $conditions;
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


sub select_all_with_color {
    my $self = shift;
    
    my $rows = $self->db_select();
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_by_sampleID {
    my $self = shift;
    
    # Arguments
    my $sample_id = shift;
    
    my $row = $self->db_select($sample_id);
    
    return $row ? $self->_create_object($row) : undef;
}


sub select_by_dbID {
    my $self = shift;
    
    # Arguments
    my $dbID = shift;
    
    my $row = $self->db_select($dbID);
    
    return $row ? $self->_create_object($row) : undef;
}


sub remove_by_dbID {
    my $self = shift;
    
    # Arguments
    my $condition_id = shift;
    
    $self->db_delete(-values => [$condition_id]);
}


sub remove_all_by_expID {
    my $self = shift;
    
    # Arguments
    my $experiment_id = shift;
    
    $self->db_delete(-values => [$experiment_id]);
}


sub store {
    my $self = shift;
    
    my $order = [qw( NAME
		     DISPLAY_ORDER
		     EXPERIMENT_ID
		     COLOR )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    my $condition_id = $self->area->IncrementerAdaptor->get_new_condID();
    unshift @values, $condition_id;
    
    my $success = $self->db_insert(-values => \@values);
    
    return $success ? $condition_id : undef;
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

