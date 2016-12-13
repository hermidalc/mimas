# AuthAdaptor.pm
# MIMAS Upload Authorization Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Upload::Adaptors::AuthAdaptor;

use strict;
use warnings;
use base qw(MIMAS::DB::BaseAdaptor);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $area = shift;
    
    my $self = $class->SUPER::new(-area => $area,
                                  -name => 'Auth');
    
    return $self;
}


sub auth_owner {
    my $self = shift;
    
    my $order = [qw( STATE
                     OWNER_ID
                     EXPERIMENT_ID )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    my $good = $self->db_select(@values);
    
    return $good ? 1 : 0;
}


sub auth_reader {
    my $self = shift;
    
    my $order = [qw(
                     USER_ID
                     EXPERIMENT_ID )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    my $good = $self->db_select(@values);
    
    return $good ? 1 : 0;
}


sub auth_writer {
    my $self = shift;
    
    my $order = [qw( USER_ID
                     EXPERIMENT_ID )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    my $good = $self->db_select(@values);
    
    return $good ? 1 : 0;
}


sub auth_writer_state {
    my $self = shift;
    
    my $order = [qw( STATE
                     USER_ID
                     EXPERIMENT_ID )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    my $good = $self->db_select(@values);
    
    return $good ? 1 : 0;
}


sub auth_curator {
    my $self = shift;
    
    my $order = [qw( STATE
                     CURATOR_ID
                     EXPERIMENT_ID )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    my $good_curator = $self->db_select(@values);
    
    return $good_curator ? 1 : 0;
}


1;

