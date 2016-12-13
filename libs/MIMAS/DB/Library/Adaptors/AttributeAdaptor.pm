# AttributeAdaptor.pm
# MIMAS Library Attribute Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Library::Adaptors::AttributeAdaptor;

use strict;
use warnings;
use MIMAS::DB::Library::Attribute;
use base qw(MIMAS::DB::BaseAdaptor);
use base qw(MIMAS::DB::BaseCachedAdaptor);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $area = shift;
    
    my $self = $class->SUPER::new(-area => $area,
                                  -name => 'Attribute');
    
    return $self;
}


# only used internally
sub _create_object {
    my $self = shift;
    
    # Arguments
    my $row = shift;
    
    return MIMAS::DB::Library::Attribute->new(adaptor          => $self,
                                              dbID             => $row->{attribute_id},
                                              name             => $row->{name},
                                              is_attribute     => $row->{is_attribute},
					      is_factor        => $row->{is_factor},
					      is_numeric       => $row->{is_numeric},
                                              deprecated       => $row->{deprecated},
                                              required         => $row->{required},
                                              other            => $row->{other},
					      none_na          => $row->{none_na},
                                              search_form_type => $row->{search_form_type},
                                              upload_form_type => $row->{upload_form_type},
					      upload_web_page  => $row->{upload_web_page},
                                              display_order    => $row->{display_order},
                                              description      => $row->{description},
                                              attr_group_id    => $row->{attr_group_id},
                                              mage_category    => $row->{mage_category},
                                              mged_name        => $row->{mged_name},
					      factor_group_id  => $row->{factor_group_id});
}


# only used internally
sub _create_object_collection {
    my $self = shift;
    
    # Arguments
    my $rows = shift;
    
    my $attrs;
    for my $row (@{$rows}) { $attrs->{$row->{attribute_id}} = $self->_create_object($row) }
    
    return $attrs;
}


sub select_all {
    my $self = shift;
    
    my $rows = $self->db_select();
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_attrs {
    my $self = shift;
    
    my $rows = $self->db_select();
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_factors {
    my $self = shift;
    
    my $rows = $self->db_select();
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_by_attr_groupID {
    my $self = shift;
    
    # Arguments
    my $group_id = shift;
    
    my $rows = $self->db_select($group_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_by_factor_groupID {
    my $self = shift;
    
    # Arguments
    my $group_id = shift;
    
    my $rows = $self->db_select($group_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_attrs_by_webpage {
    my $self = shift;
    
    # Arguments
    my $webpage = shift;
    
    my $rows = $self->db_select($webpage);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_factors_by_expID {
    my $self = shift;
    
    # Arguments
    my $experiment_id = shift;
    
    my $rows = $self->db_select($experiment_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_by_attr_name {
    my $self = shift;
    
    # Arguments
    my $name = shift;
    
    my $row = $self->db_select($name);
    
    return $row ? $self->_create_object($row) : undef;
}


sub select_by_attr_name_ci {
    my $self = shift;
    
    # Arguments
    my $name = shift;
    
    my $row = $self->db_select($name);
    
    return $row ? $self->_create_object($row) : undef;
}


sub select_by_factor_name {
    my $self = shift;
    
    # Arguments
    my $name = shift;
    
    my $row = $self->db_select($name);
    
    return $row ? $self->_create_object($row) : undef;
}


sub select_by_factor_name_ci {
    my $self = shift;
    
    # Arguments
    my $name = shift;
    
    my $row = $self->db_select($name);
    
    return $row ? $self->_create_object($row) : undef;
}


#in MIMAS::DB::BaseCachedAdaptor
#sub select_by_dbID { }


sub store {
    my $self = shift;
    
    my $order = [qw( NAME
                     IS_ATTRIBUTE
		     IS_FACTOR
		     IS_NUMERIC
		     REQUIRED
		     OTHER
		     NONE_NA
		     SEARCH_FORM_TYPE
		     UPLOAD_FORM_TYPE
		     DESCRIPTION
		     ATTR_GROUP_ID
                     FACTOR_GROUP_ID
		     MAGE_CATEGORY
		     MGED_NAME
		     )];
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    my $attribute_id = $self->area->IncrementerAdaptor->get_new_attrID();
    unshift @values, $attribute_id;
    
    my $success = $self->db_insert(-values => \@values);
    
    return $success ? $attribute_id : undef;
}


1;

