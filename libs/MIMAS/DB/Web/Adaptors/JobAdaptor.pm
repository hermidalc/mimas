# JobAdaptor.pm
# MIMAS Web Job Queue Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Web::Adaptors::JobAdaptor;

use strict;
use warnings;
use MIMAS::Utils;
use MIMAS::DB::Web::Job;
use base qw(MIMAS::DB::BaseAdaptor);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $area = shift;
    
    my $self = $class->SUPER::new(-area => $area,
                                  -name => 'Job');
    
    return $self;
}


# only used internally
sub _create_object {
    my $self = shift;
    
    # Arguments
    my $row = shift;
    
    return MIMAS::DB::Web::Job->new(adaptor      => $self,
	                            dbID         => $row->{job_id},
	                            type         => $row->{type},
	                            request_time => $row->{request_time},
	                            data         => defined $row->{data} ? &unserialize($row->{data}) : undef,
	                            user_id      => $row->{user_id});
}


# only used internally
# JobAdaptor returns a reference to an ARRAY of Job objects because we have it
# already sorted by "request_time" during the SQL select and we want to maintain this order
sub _create_object_collection {
    my $self = shift;
    
    # Arguments
    my $rows = shift;
    
    my $jobs;
    for my $row (@{$rows}) { push @{$jobs}, $self->_create_object($row) }
    
    return $jobs;
}


sub select_all {
    my $self = shift;
    
    my $rows = $self->db_select();
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_by_userID {
    my $self = shift;
    
    # Arguments
    my $user_id = shift;
    
    my $rows = $self->db_select($user_id);
    
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
    my $job_id = shift;
    
    $self->db_delete(-values => [$job_id]);
}


sub store {
    my $self = shift;
    
    my $order = [qw( TYPE
                     DATA
		     USER_ID )];
    
    my %param_pos = map { $order->[$_] => $_ } 0 .. $#{$order};
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    # need to serialize data
    $values[$param_pos{DATA}] = &serialize($values[$param_pos{DATA}]) if defined $values[$param_pos{DATA}];
    
    my $job_id = $self->area->IncrementerAdaptor->get_new_dbID();
    unshift @values, $job_id;
    
    my $success = $self->db_insert(-values => \@values);
    
    return $success ? $job_id : undef;
}


1;

