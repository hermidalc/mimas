# ExpFactorAdaptor.pm
# MIMAS Users Experimental Factor Adaptor Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Upload::Adaptors::ExpFactorAdaptor;

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
                                  -name => 'ExpFactor');
    
    return $self;
}


sub remove_all_by_expID {
    my $self = shift;
    
    # Arguments
    my $experiment_id = shift;
    
    $self->db_delete(-values => [$experiment_id]);
}


sub store {
    my $self = shift;
    
    my $order = [qw( EXPERIMENT_ID
                     FACTOR_ID    )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    return $self->db_insert(-values => \@values);
};


1;

