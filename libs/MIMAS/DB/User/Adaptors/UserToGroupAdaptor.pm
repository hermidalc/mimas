# UserToGroupAdaptor.pm
# MIMAS Users User-To-Group Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::User::Adaptors::UserToGroupAdaptor;

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
                                  -name => 'UserToGroup');
    
    return $self;
}


sub remove_all_by_userID {
    my $self = shift;
    
    # Arguments
    my $user_id = shift;
    
    $self->db_delete(-values => [$user_id]);
}


sub remove_all_by_groupID {
    my $self = shift;
    
    # Arguments
    my $group_id = shift;
    
    $self->db_delete(-values => [$group_id]);
}


sub store {
    my $self = shift;
    
    my $order = [qw( USER_ID
                     GROUP_ID )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    return $self->db_insert(-values => \@values);
};


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

