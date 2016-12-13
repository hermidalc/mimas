# AuthAdaptor.pm
# MIMAS User Authorization Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::User::Adaptors::AuthAdaptor;

use strict;
use warnings;
use MIMAS::Utils qw(encrypt_password);
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


sub auth_admin {
    my $self = shift;
    
    my $order = [qw( USER_ID )];
    
    # Arguments
    my ($user_id) = $self->rearrange_params($order, @_);
    
    my $good_admin = $self->db_select($user_id);
    
    return $good_admin ? 1 : 0;
}

sub auth_curator {
    my $self = shift;
    
    my $order = [qw( USER_ID )];
    
    # Arguments
    my ($user_id) = $self->rearrange_params($order, @_);
    
    my $good = $self->db_select($user_id);
    
    return $good ? 1 : 0;
}


sub auth_login {
    my $self = shift;
    
    my $order = [qw( USERNAME
                     PASSWORD )];
    
    # Arguments
    my ($username, $password) = $self->rearrange_params($order, @_);
    
    my $user_id = $self->db_select($username, &encrypt_password($password));
    
    return $user_id;
}


1;

