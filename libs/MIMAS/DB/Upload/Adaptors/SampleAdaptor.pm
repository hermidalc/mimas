# SampleAdaptor.pm
# MIMAS Upload Sample Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Upload::Adaptors::SampleAdaptor;

use strict;
use warnings;
use MIMAS::DB::Upload::Sample;
use base qw(MIMAS::DB::BaseAdaptor);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $area = shift;
    
    my $self = $class->SUPER::new(-area => $area,
                                  -name => 'Sample');
    
    return $self;
}


# only used internally
sub _create_object {
    my $self = shift;
    
    # Arguments
    my $row = shift;
    
    return MIMAS::DB::Upload::Sample->new(adaptor        => $self,
	                                  dbID           => $row->{sample_id},
					  name           => $row->{name},
					  attrs_complete => $row->{attrs_complete},
					  attrs_exist    => $row->{attrs_exist},
					  array_id       => $row->{array_id},
					  condition_id   => $row->{condition_id},
					  experiment_id  => $row->{experiment_id});
}


# only used internally
sub _create_object_collection {
    my $self = shift;
    
    # Arguments
    my $rows = shift;
    
    my $samples;
    for my $row (@{$rows}) { $samples->{$row->{sample_id}} = $self->_create_object($row) }
    
    return $samples;
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


sub select_all_by_condID {
    my $self = shift;
    
    # Arguments
    my $condition_id = shift;
    
    my $rows = $self->db_select($condition_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


#used in GermOnline
sub select_all_by_ensembl_array_name {
    my $self = shift;
    
    # Arguments
    my $experiment_id = shift;
    
    my $rows = $self->db_select($experiment_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_by_sample_file_id {
    my $self = shift;
    
    # Arguments
    my $sample_file_id = shift;
    
    my $rows = $self->db_select($sample_file_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_by_dbID {
    my $self = shift;
    
    # Arguments
    my $dbID = shift;
    
    my $row = $self->db_select($dbID);
    
    return $row ? $self->_create_object($row) : undef;
}


sub select_by_expID_name {
    my $self = shift;
    
    # Arguments
    my $expID = shift;
    my $name = shift;
    
    my $row = $self->db_select($expID, $name);
    
    return $row ? $self->_create_object($row) : undef;
}


sub remove_by_dbID {
    my $self = shift;
    
    # Arguments
    my $sample_id = shift;
    
    ## won't tie sample removal to any experimental condition removal anymore
    #
    ## we need the experiment ID of the sample before we delete it for
    ## experimental condition relationship processing below
    # my $experiment_id = $self->select_by_dbID($sample_id)->experiment->dbID;
    
    $self->area->SampleAttributeAdaptor->remove_all_by_sampleID($sample_id);
    $self->area->SampleFileAdaptor->remove_all_by_sampleID($sample_id);
    
    $self->db_delete(-values => [$sample_id]);
    
    
    ## won't tie sample removal to any experimental condition removal anymore
    #
    ## special relationship between samples and experimental conditions:
    ## after removing the sample, if all the samples for an experimental_condition
    ## are gone then we need to remove the experimental condition
    # my $samples    = $self->select_all_by_expID($experiment_id);
    # my $conditions = $self->area->ExpConditionAdaptor->select_all_by_expID($experiment_id);
    #
    ## create a lookup hash of condition IDs still mapped to samples in the sample table for this experiment;
    ## exp condition in sample table could be NULL which causes a warning so we check
    # my %sample_mapped_condition_ids;
    # for my $sample (values %{$samples}) {
    #     $sample_mapped_condition_ids{$sample->condition->dbID}++ if defined $sample->condition;
    # }
    #
    ## now delete condition IDs that are not mapped
    # for my $condition_id (keys %{$conditions}) {
    #     $self->area->ExpConditionAdaptor->remove_by_dbID($condition_id) unless $sample_mapped_condition_ids{$condition_id};
    # }
}


sub remove_all_by_expID {
    my $self = shift;
    
    # Arguments
    my $experiment_id = shift;
    
    my $samples = $self->select_all_by_expID($experiment_id);
    if (defined $samples) {
        for my $sample_id (keys %{$samples}) {
            $self->area->SampleAttributeAdaptor->remove_all_by_sampleID($sample_id);
	    $self->area->SampleFileAdaptor->remove_all_by_sampleID($sample_id);
	}
	
	$self->db_delete(-values => [$experiment_id]);
    }
    
    # here we don't worry about special relationship between samples and experimental conditions
    # because if we are removing all the samples for an experiment then we better be
    # removing all the experimental conditions for an experiment too! (Check experiment adaptor)
}


sub store {
    my $self = shift;
    
    my $order = [qw( NAME
		     ARRAY_ID
		     CONDITION_ID
		     EXPERIMENT_ID )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    my $sample_id = $self->area->IncrementerAdaptor->get_new_sampleID();
    unshift @values, $sample_id;
    
    my $success = $self->db_insert(-values => \@values);
    
    return $success ? $sample_id : undef;
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

