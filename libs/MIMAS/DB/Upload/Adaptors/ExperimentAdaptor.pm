# ExperimentAdaptor.pm
# MIMAS Upload Experiment Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Upload::Adaptors::ExperimentAdaptor;

use strict;
use warnings;
use MIMAS::DB::Upload::Experiment;
use base qw(MIMAS::DB::BaseAdaptor);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $area = shift;
    
    my $self = $class->SUPER::new(-area => $area,
                                  -name => 'Experiment');
    
    return $self;
}


# only used internally
sub _create_object {
    my $self = shift;
    
    # Arguments
    my $row = shift;
    
    return MIMAS::DB::Upload::Experiment->new(adaptor         => $self,
                                              dbID            => $row->{experiment_id},
                                              name            => $row->{name},
                                              num_hybrids     => $row->{num_hybrids},
                                              progress        => $row->{progress},
                                              state           => $row->{state},
                                              owner_id        => $row->{owner_id},
                                              curator_id      => $row->{curator_id});
}


# only used internally
sub _create_object_collection {
    my $self = shift;
    
    # Arguments
    my $rows = shift;
    
    my $experiments;
    for my $row (@{$rows}) { $experiments->{$row->{experiment_id}} = $self->_create_object($row) }
    
    return $experiments;
}


sub select_all {
    my $self = shift;
    
    my $rows = $self->db_select();
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_by_state {
    my $self = shift;
    
    # Arguments
    my $state = shift;
    
    my $rows = $self->db_select($state);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_by_ownerID {
    my $self = shift;
    
    # Arguments
    my $owner_id = shift;
    
    my $rows = $self->db_select($owner_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_by_curatorID {
    my $self = shift;
    
    # Arguments
    my $curator_id = shift;
    
    my $rows = $self->db_select($curator_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
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
    my $experiment_id = shift;
    
    $self->area->ExpAttributeAdaptor->remove_all_by_expID($experiment_id);
    $self->area->SampleAdaptor->remove_all_by_expID($experiment_id);
    $self->area->ExpConditionAdaptor->remove_all_by_expID($experiment_id);
    $self->area->ExpFactorAdaptor->remove_all_by_expID($experiment_id);
    
    $self->db_delete(-values => [$experiment_id]);
}


sub store {
    my $self = shift;
    
    my $order = [qw( NAME
		     NUM_HYBRIDS
		     PROGRESS
		     STATE
		     OWNER_ID )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    my $experiment_id = $self->area->IncrementerAdaptor->get_new_expID();
    unshift @values, $experiment_id;
    
    my $success = $self->db_insert(-values => \@values);
    
    return $success ? $experiment_id : undef;
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

