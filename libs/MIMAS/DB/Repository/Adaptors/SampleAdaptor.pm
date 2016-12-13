# SampleAdaptor.pm
# MIMAS Repository Sample Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Repository::Adaptors::SampleAdaptor;

use strict;
use warnings;
use MIMAS::DB::Repository::Sample;
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
    
    return MIMAS::DB::Repository::Sample->new(adaptor     => $self,
	                                      dbID        => $row->{sample_id},
					      owner_id    => $row->{owner_id},
					      cel_file_id => $row->{cel_file_id},
					      txt_file_id => $row->{txt_file_id});
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


sub select_all_by_ownerID {
    my $self = shift;
    
    # Arguments
    my $owner_id = shift;
    
    my $rows = $self->db_select($owner_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_by_celID {
    my $self = shift;
    
    # Arguments
    my $cel_file_id = shift;
    
    my $rows = $self->db_select($cel_file_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_by_txtID {
    my $self = shift;
    
    # Arguments
    my $txt_file_id = shift;
    
    my $rows = $self->db_select($txt_file_id);
    
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
    
    my $order = [qw( OWNER_ID 
                     CEL_FILE_ID 
		     TXT_FILE_ID )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    my $sample_id = $self->area->IncrementerAdaptor->get_new_sampleID();
    unshift @values, $sample_id;
    
    my $success = $self->db_insert(-values => \@values);
    
    return $success ? $sample_id : undef;
}


# methods to do everything by fetch, not select in DBI

sub init_fetch_all {
    my $self = shift;
    
    $self->db_init_fetch();
}


sub fetch {
    my $self = shift;
    
    my $row = $self->sth->fetchrow_hashref;
    
    return $row ? $self->_create_object($row) : undef;
}


1;

