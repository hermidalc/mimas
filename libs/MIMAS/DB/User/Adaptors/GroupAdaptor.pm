# GroupAdaptor.pm
# MIMAS Users Group Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::User::Adaptors::GroupAdaptor;

use strict;
use warnings;
use MIMAS::DB::User::Group;
use base qw(MIMAS::DB::BaseAdaptor);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $area = shift;
    
    my $self = $class->SUPER::new(-area => $area,
                                  -name => 'Group');
    
    return $self;
}


# only used internally
sub _create_object {
    my $self = shift;
    
    # Arguments
    my $row = shift;
    
    return MIMAS::DB::User::Group->new(
        adaptor => $self,
        dbID => $row->{group_id},
        name    => $row->{name},
        is_default_reader    => $row->{is_default_reader},
        is_default_writer    => $row->{is_default_writer},
        is_system    => $row->{is_system},
        is_auto    => $row->{is_auto},
        restrict_level    => $row->{restrict_level},
        description    => $row->{description},
    );
}


# only used internally
sub _create_object_collection {
    my $self = shift;
    
    # Arguments
    my $rows = shift;
    
    my $groups;
    for my $row (@{$rows}) { $groups->{$row->{group_id}} = $self->_create_object($row) }
    
    return $groups;
}


sub select_all {
    my $self = shift;
    
    my $rows = $self->db_select();
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}

sub select_all_non_system {
    my $self = shift;

    my $groups = $self->select_all;

    return {map {($_, $groups->{$_})} grep {$_ != 1 and $_ != 2} keys %$groups};
}


sub select_all_by_userID {
    my $self = shift;
    
    # Arguments
    my $user_id = shift;
    
    my $rows = $self->db_select($user_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}

sub select_all_read_by_expID {
    my $self = shift;
    
    # Arguments
    my $exp_id = shift;
    
    my $rows = $self->db_select($exp_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_write_by_expID {
    my $self = shift;
    
    # Arguments
    my $exp_id = shift;
    
    my $rows = $self->db_select($exp_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_by_name {
    my $self = shift;
    
    # Arguments
    my $name = shift;
    
    my $row = $self->db_select($name);
    
    return $row ? $self->_create_object($row) : undef;
}


sub select_by_name_ci {
    my $self = shift;
    
    # Arguments
    my $name = shift;
    
    my $row = $self->db_select($name);
    
    return $row ? $self->_create_object($row) : undef;
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
    
    my $order = [qw( NAME )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    my $group_id = $self->area->IncrementerAdaptor->get_new_groupID();
    unshift @values, $group_id;
    
    my $success = $self->db_insert(-values => \@values);
    
    return $success ? $group_id : undef;
};


1;

