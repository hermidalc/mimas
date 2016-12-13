# ArrayAdaptor.pm
# MIMAS Library Array Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Library::Adaptors::ArrayAdaptor;

use strict;
use warnings;
use MIMAS::DB::Library::Array;
use base qw(MIMAS::DB::BaseAdaptor);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $area = shift;
    
    my $self = $class->SUPER::new(-area => $area,
                                  -name => 'Array');
    
    return $self;
}


# only used internally
sub _create_object {
    my $self = shift;
    
    # Arguments
    my $row = shift;
    
    return MIMAS::DB::Library::Array->new(adaptor          => $self,
                                          dbID             => $row->{array_id},
                                          design_name      => $row->{design_name},
                                          display_name     => $row->{display_name},
                                          num_probesets    => $row->{num_probesets},
                                          num_cel_features => $row->{num_cel_features},
                                          description      => $row->{description},
                                          technology_id    => $row->{technology_id},
                                          arrayexpress_accession => $row->{arrayexpress_accession},
                                          manufacturer     => $row->{manufacturer},
                                      );
}


# only used internally
sub _create_object_collection {
    my $self = shift;
    
    # Arguments
    my $rows = shift;
    
    my $arrays;
    for my $row (@{$rows}) { $arrays->{$row->{array_id}} = $self->_create_object($row) }
    
    return $arrays;
}


sub select_all {
    my $self = shift;
    
    my $rows = $self->db_select();
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_by_technologyID {
    my $self = shift;
    
    # Arguments
    my $technology_id = shift;

    my $rows = $self->db_select($technology_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_by_dbID {
    my $self = shift;
    
    # Arguments
    my $dbID = shift;
    
    my $row = $self->db_select($dbID);
    
    return $row ? $self->_create_object($row) : undef;
}


sub select_by_design_name {
    my $self = shift;
    
    # Arguments
    my $design_name = shift;
    
    my $row = $self->db_select($design_name);
    
    return $row ? $self->_create_object($row) : undef;
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


sub store {
    my $self = shift;
    
    my $order = [qw( DESIGN_NAME
		     DISPLAY_NAME
		     NUM_PROBESETS
		     NUM_CEL_FEATURES
		     TECHNOLOGY_ID
		     ARRAYEXPRESS_ACCESSION
		     MANUFACTURER
                     )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    my $array_id = $self->area->IncrementerAdaptor->get_new_arrayID();
    unshift @values, $array_id;
    
    my $success = $self->db_insert(-values => \@values);
    
    return $success ? $array_id : undef;
}

sub remove_by_dbID {
    my $self = shift;
    
    # Arguments
    my $id = shift;
    
    $self->db_delete(-values => [$id]);
}


1;

