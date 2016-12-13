# SampleFileAdaptor.pm
# MIMAS Upload Sample File Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Upload::Adaptors::SampleToFileAdaptor;

use strict;
use warnings;
use Compress::LZF;
use MIMAS::Consts;
use MIMAS::DB::Upload::SampleToFile;
use base qw(MIMAS::DB::BaseAdaptor);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $area = shift;
    
    my $self = $class->SUPER::new(-area => $area,
                                  -name => 'SampleToFile');
    
    return $self;
}


# only used internally
sub _create_object {
    my $self = shift;
    
    # Arguments
    my $row = shift;
    
    return MIMAS::DB::Upload::SampleToFile->new(adaptor   => $self,
	                                      dbID      => $row->{sample_to_file_id},
					      sample_id => $row->{sample_id},
					      sample_file_id => $row->{sample_file_id},
					      format => $row->{format},
					      is_germonline => $row->{is_germonline},
					      hybridization_name => $row->{hybridization_name});
}


# only used internally
sub _create_object_collection {
    my $self = shift;
    
    # Arguments
    my $rows = shift;
    
    my $sample_to_files;
    for my $row (@{$rows}) { $sample_to_files->{$row->{sample_to_file_id}} = $self->_create_object($row) }
    
    return $sample_to_files;
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


sub select_all_by_sampleID {
    my $self = shift;
    
    # Arguments
    my $sample_id = shift;
    
    my $rows = $self->db_select($sample_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_by_sample_file_id {
    my $self = shift;
    
    # Arguments
    my $sample_file_id = shift;
    
    my $rows = $self->db_select($sample_file_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


#used by GermOnline code
sub select_all_germonline {
    my $self = shift;
    
    my $rows = $self->db_select();
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


#used by GermOnline code
sub select_all_germonline_by_expID {
    my $self = shift;
    
    # Arguments
    my $experiment_id = shift;
    
    my $rows = $self->db_select($experiment_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_by_dbID {
    my $self = shift;
    
    # Arguments
    my $dbID = shift;
    
    my $row = $self->db_select($dbID);
    
    return $row ? $self->_create_object($row) : undef;
}


sub select_by_expID_name_format {
    my $self = shift;
    
    # Arguments
    my $experiment_id = shift;
    my $sample_name = shift;
    my $format = shift;
    
    my $row = $self->db_select($experiment_id, $sample_name, $format);
    
    return $row ? $self->_create_object($row) : undef;
}


sub remove_all_by_sampleID {
    my $self = shift;
    
    # Arguments
    my $sample_id = shift;
    
    $self->db_delete(-values => [$sample_id]);
}


sub store {
    my $self = shift;
    
    my $order = [qw(
        sample_id
        sample_file_id
        format
        is_germonline
        hybridization_name
        )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);

    my $sample_to_file_id = $self->area->IncrementerAdaptor->get_new_sample_to_fileID();
    unshift @values, $sample_to_file_id;

    my $success = $self->db_insert(-values => \@values);

    return $success ? $sample_to_file_id : undef;
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

