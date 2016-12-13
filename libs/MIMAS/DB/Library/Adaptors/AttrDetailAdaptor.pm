# AttrDetailAdaptor.pm
# MIMAS Library Attribute Detail Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Library::Adaptors::AttrDetailAdaptor;

use strict;
use warnings;
use MIMAS::DB::Library::AttrDetail;
use base qw(MIMAS::DB::BaseAdaptor);
use base qw(MIMAS::DB::BaseCachedAdaptor);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $area = shift;
    
    my $self = $class->SUPER::new(-area => $area,
                                  -name => 'AttrDetail');
    
    return $self;
}


# only used internally
sub _create_object {
    my $self = shift;
    
    # Arguments
    my $row = shift;
    
    return MIMAS::DB::Library::AttrDetail->new(adaptor              => $self,
                                               dbID                 => $row->{attr_detail_id},
                                               name                 => $self->decode_varchar($row->{name}),
                                               type                 => $row->{type},
                                               deprecated           => $row->{deprecated},
					       default              => $row->{default_selection},
					       display_order        => $row->{display_order},
                                               base_conv_scalar     => $row->{base_conv_scalar},
                                               base_conv_factor     => $row->{base_conv_factor},
					       description          => $row->{description},
					       link_id              => $row->{link_id},
					       attr_detail_group_id => $row->{attr_detail_group_id},
					       mage_name            => $row->{mage_name},
					       attribute_id         => $row->{attribute_id});
}


# only used internally
sub _create_object_collection {
    my $self = shift;
    
    # Arguments
    my $rows = shift;
    
    my $details;
    for my $row (@{$rows}) { $details->{$row->{attr_detail_id}} = $self->_create_object($row) }
    
    return $details;
}


sub select_all {
    my $self = shift;
    
    my $rows = $self->db_select();
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_by_type {
    my $self = shift;
    
    # Arguments
    my $type = shift;
    
    my $rows = $self->db_select($type);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_by_groupID {
    my $self = shift;
    
    # Arguments
    my $group_id = shift;
    
    my $rows = $self->db_select($group_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_by_attrID {
    my $self = shift;
    
    # Arguments
    my $attribute_id = shift;
    
    my $rows = $self->db_select($attribute_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_facilities_by_userID {
    my $self = shift;
    
    # Arguments
    my $user_id = shift;
    
    my $rows = $self->db_select($user_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_by_attrs {
    my $self = shift;
    
    my $order = [qw( NAME
                     TYPE
                     ATTRIBUTE_ID )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    my $row = $self->db_select(@values);
    
    return $row ? $self->_create_object($row) : undef;
}


sub select_by_attrs_ci {
    my $self = shift;
    
    my $order = [qw( NAME
                     TYPE
                     ATTRIBUTE_ID )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    my $row = $self->db_select(@values);
    
    return $row ? $self->_create_object($row) : undef;
}


sub select_by_attr_link_id {
    my $self = shift;
    
    my $order = [qw( LINK_ID
                     ATTRIBUTE_ID )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    my $row = $self->db_select(@values);
    
    return $row ? $self->_create_object($row) : undef;
}


sub select_by_attr_id_name {
    my $self = shift;
    
    my $order = [qw( ATTRIBUTE_ID NAME )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    my $row = $self->db_select(@values);
    
    return $row ? $self->_create_object($row) : undef;
}


#in MIMAS::DB::BaseCachedAdaptor
#sub select_by_dbID { }


sub store {
    my $self = shift;
    
    my $order = [qw( NAME
		     TYPE
		     DEFAULT
		     BASE_CONV_SCALAR
		     BASE_CONV_FACTOR
		     DESCRIPTION
		     LINK_ID
		     ATTR_DETAIL_GROUP_ID
                     ATTRIBUTE_ID
		     MAGE_NAME
		     )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    my $attr_detail_id = $self->area->IncrementerAdaptor->get_new_detailID();
    unshift @values, $attr_detail_id;
    
    my $success = $self->db_insert(-values => \@values);
    
    return $success ? $attr_detail_id : undef;
}


sub update {
    my $self = shift;
    
    my $order = [qw( SET
                     QUALIFIERS )];
    
    # Arguments
    my ($set_params, $qual_params) = $self->rearrange_params($order, @_);
    
    $self->db_update(-set_params  => $set_params,
		     -qual_params => $qual_params);
}



sub remove_by_dbID {
    my $self = shift;
    
    # Arguments
    my $id = shift;
    
    $self->db_delete(-values => [$id]);
}

sub remove_by_attr_id_name {
    my $self = shift;

	my $s = $self->select_by_attr_id_name(@_);
	return defined($s) ? $self->remove_by_dbID($s->dbID) : undef;
}


1;

