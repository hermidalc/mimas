# GroupExpPrivilegeAdaptor.pm
# MIMAS Upload Sample GroupPrivilege Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Upload::Adaptors::GroupExpPrivilegeAdaptor;

use strict;
use warnings;
use Compress::LZF;
use MIMAS::Consts;
use MIMAS::DB::Upload::GroupExpPrivilege;
use base qw(MIMAS::DB::BaseAdaptor);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $area = shift;
    
    my $self = $class->SUPER::new(-area => $area,
                                  -name => 'GroupExpPrivilege');
    
    return $self;
}


# only used internally
sub _create_object {
    my $self = shift;
    
    # Arguments
    my $row = shift;
    
    return MIMAS::DB::Upload::GroupExpPrivilege->new(
        adaptor   => $self,
        can_write => $row->{can_write},
        experiment_id => $row->{experiment_id},
        group_id  => $row->{group_id},
    );
}


# only used internally
sub _create_object_collection {
    my $self = shift;
    
    # Arguments
    my $rows = shift;
    
    my $objs;
    for my $row (@{$rows}) { push @$objs, $self->_create_object($row) }
    
    return $objs;
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


sub select_by_dbID {
    my $self = shift;
    
    # Arguments
    my $dbID = shift;
    
    my $row = $self->db_select($dbID);
    
    return $row ? $self->_create_object($row) : undef;
}


sub remove_all_by_expID {
    my $self = shift;
    
    # Arguments
    my $exp_id = shift;
    
    $self->db_delete(-values => [$exp_id]);
}


sub store {
    my $self = shift;
    
    my $order = [qw(
        group_id
        experiment_id
        can_write
    )];
    
    my %param_pos = map { $order->[$_] => $_ } 0 .. $#{$order};
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    return $self->db_insert(-values => \@values);
}


1;

