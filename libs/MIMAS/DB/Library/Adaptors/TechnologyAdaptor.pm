# TechnologyAdaptor.pm
# MIMAS Library Technology Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Library::Adaptors::TechnologyAdaptor;

use strict;
use warnings;
use MIMAS::DB::Library::Technology;
use base qw(MIMAS::DB::BaseAdaptor);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $area = shift;
    
    my $self = $class->SUPER::new(-area => $area,
                                  -name => 'Technology');
    
    return $self;
}


# only used internally
sub _create_object {
    my $self = shift;
    
    # Arguments
    my $row = shift;
    
    return MIMAS::DB::Library::Technology->new(adaptor      => $self,
                                                dbID         => $row->{technology_id},
                                                name         => $row->{name},
                                                display_name => $row->{display_name},
                                                default_manufacturer => $row->{default_manufacturer});
}


# only used internally
sub _create_object_collection {
    my $self = shift;
    
    # Arguments
    my $rows = shift;
    
    my $technologies;
    for my $row (@{$rows}) { $technologies->{$row->{technology_id}} = $self->_create_object($row) }
    
    return $technologies;
}


sub select_all {
    my $self = shift;
    
    my $rows = $self->db_select();
    
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
    
    my $order = [qw( NAME
                     DISPLAY_NAME
		     DEFAULT_MANUFACTURER )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    my $technology_id = $self->area->IncrementerAdaptor->get_new_technologyID();
    unshift @values, $technology_id;
    
    my $success = $self->db_insert(-values => \@values);
    
    return $success ? $technology_id : undef;
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

sub remove_by_dbID {
    my $self = shift;
    
    # Arguments
    my $id = shift;
    
    $self->db_delete(-values => [$id]);
}



1;

