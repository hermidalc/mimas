# LabAdaptor.pm
# MIMAS Users Laboratory Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::User::Adaptors::LabAdaptor;

use strict;
use warnings;
use MIMAS::DB::User::Lab;
use base qw(MIMAS::DB::BaseAdaptor);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $area = shift;
    
    my $self = $class->SUPER::new(-area => $area,
                                  -name => 'Lab');
    
    return $self;
}


# only used internally
sub _create_object {
    my $self = shift;
    
    # Arguments
    my $row = shift;
    
    return MIMAS::DB::User::Lab->new(adaptor         => $self,
	                             dbID            => $row->{lab_id},
				     name            => $row->{name},
				     address         => $row->{address},
				     postcode        => $row->{postcode},
				     state           => $row->{state},
				     city            => $row->{city},
				     url             => $row->{url},
				     pi_name         => $row->{pi_name},
				     pi_email        => $row->{pi_email},
				     valid           => $row->{valid},
				     organization_id => $row->{organization_id});
}


# only used internally
sub _create_object_collection {
    my $self = shift;
    
    # Arguments
    my $rows = shift;
    
    my $labs;
    for my $row (@{$rows}) { $labs->{$row->{lab_id}} = $self->_create_object($row) }
    
    return $labs;
}


sub select_all {
    my $self = shift;
    
    my $rows = $self->db_select();
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_valid {
    my $self = shift;
    
    my $rows = $self->db_select();
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_by_orgID {
    my $self = shift;
    
    # Arguments
    my $org_id = shift;
    
    my $rows = $self->db_select($org_id);
    
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


sub select_by_pi_email {
    my $self = shift;
    
    # Arguments
    my $pi_email = shift;
    
    my $row = $self->db_select($pi_email);
    
    return $row ? $self->_create_object($row) : undef;
}


sub select_by_pi_email_ci {
    my $self = shift;
    
    # Arguments
    my $pi_email = shift;
    
    my $row = $self->db_select($pi_email);
    
    return $row ? $self->_create_object($row) : undef;
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
    my $lab_id = shift;
    
    $self->db_delete(-values => [$lab_id]);
}


sub store {
    my $self = shift;
    
    my $order = [qw( NAME
		     ADDRESS
		     POSTCODE
		     STATE
		     CITY
		     URL
		     PI_NAME
		     PI_EMAIL
		     VALID
		     ORGANIZATION_ID )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    my $lab_id = $self->area->IncrementerAdaptor->get_new_labID();
    unshift @values, $lab_id;
    
    my $success = $self->db_insert(-values => \@values);
    
    return $success ? $lab_id : undef;
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

