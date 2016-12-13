# OrganizationAdaptor.pm
# MIMAS Users Organization Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::User::Adaptors::OrganizationAdaptor;

use strict;
use warnings;
use MIMAS::DB::User::Organization;
use base qw(MIMAS::DB::BaseAdaptor);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $area = shift;
    
    my $self = $class->SUPER::new(-area => $area,
                                  -name => 'Organization');
    
    return $self;
}


# only used internally
sub _create_object {
    my $self = shift;
    
    # Arguments
    my $row = shift;
    
    return MIMAS::DB::User::Organization->new(adaptor    => $self,
	                                      dbID       => $row->{organization_id},
	                                      name       => $row->{name},
	                                      url        => $row->{url},
	                                      valid      => $row->{valid},
	                                      country_id => $row->{country_id});
}


# only used internally
sub _create_object_collection {
    my $self = shift;
    
    # Arguments
    my $rows = shift;
    
    my $orgs;
    for my $row (@{$rows}) { $orgs->{$row->{organization_id}} = $self->_create_object($row) }
    
    return $orgs;
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


sub remove_by_dbID {
    my $self = shift;
    
    # Arguments
    my $organization_id = shift;
    
    $self->db_delete(-values => [$organization_id]);
}


sub store {
    my $self = shift;
    
    my $order = [qw( NAME
		     URL
		     VALID
		     COUNTRY_ID )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    my $org_id = $self->area->IncrementerAdaptor->get_new_orgID();
	unshift @values, $org_id;
    
    my $success = $self->db_insert(-values => \@values);
    
    return $success ? $org_id : undef;
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

