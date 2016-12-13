# UserAdaptor.pm
# MIMAS Users User Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::User::Adaptors::UserAdaptor;

use strict;
use warnings;
use MIMAS::Utils;
use MIMAS::DB::User::User;
use base qw(MIMAS::DB::BaseAdaptor);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $area = shift;
    
    my $self = $class->SUPER::new(-area => $area,
                                  -name => 'User');
    
    return $self;
}


# only used internally
sub _create_object {
    my $self = shift;
    
    # Arguments
    my $row = shift;
    
    return MIMAS::DB::User::User->new(adaptor      => $self,
	                              dbID         => $row->{user_id},
	                              username     => $row->{username},
	                              password     => $row->{password},
	                              disabled     => $row->{disabled},
	                              first_name   => $row->{first_name},
	                              middle_name  => $row->{middle_name},
	                              last_name    => $row->{last_name},
	                              position     => $row->{position},
	                              email        => $row->{email},
	                              phone        => $row->{phone},
	                              fax          => $row->{fax},
	                              reg_date     => $row->{reg_date},
	                              working_data => defined $row->{working_data} ? &unserialize($row->{working_data}) : undef,
				      title_id     => $row->{title_id},
	                              lab_id       => $row->{lab_id});
}


# only used internally
sub _create_object_collection {
    my $self = shift;
    
    # Arguments
    my $rows = shift;
    
    my $users;
    for my $row (@{$rows}) { $users->{$row->{user_id}} = $self->_create_object($row) }
    
    return $users;
}


sub select_all {
    my $self = shift;
    
    my $rows = $self->db_select();
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_enabled {
    my $self = shift;
    
    my $rows = $self->db_select();
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_disabled {
    my $self = shift;
    
    my $rows = $self->db_select();
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_with_sample {
    my $self = shift;
    
    my $rows = $self->db_select();
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_by_labID {
    my $self = shift;
    
    # Arguments
    my $lab_id = shift;
    
    my $rows = $self->db_select($lab_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_by_groupID_experiment {
    my $self = shift;
    
    # Arguments
    my $group_id = shift;
    my $experiment = shift;

    #Dynamic groups (e.g. Lab readers) depend on owner of experiment
    my $user_id = $experiment->owner->dbID;
    my $lab_id = $experiment->owner->lab->dbID;
    my $organization_id = $experiment->owner->lab->organization->dbID;

    my $facility = $self->area->db->Upload->ExpAttributeAdaptor->select_all_by_attr_name_expID('Microarray Facility', $experiment->dbID);
    my $facility_id = undef;
    if ($facility) {
        my ($facility0) = values %$facility;
        $facility_id = $facility0->detail->dbID;
    }

    my $rows = $self->db_select($group_id, $user_id, $lab_id, $organization_id, $facility_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_by_email {
    my $self = shift;
    
    # Arguments
    my $email = shift;
    
    my $row = $self->db_select($email);
    
    return $row ? $self->_create_object($row) : undef;
}


sub select_by_email_ci {
    my $self = shift;
    
    # Arguments
    my $email = shift;
    
    my $row = $self->db_select($email);
    
    return $row ? $self->_create_object($row) : undef;
}


sub select_by_username {
    my $self = shift;
    
    # Arguments
    my $username = shift;
    
    my $row = $self->db_select($username);
    
    return $row ? $self->_create_object($row) : undef;
}


sub select_by_username_ci {
    my $self = shift;
    
    # Arguments
    my $username = shift;
    
    my $row = $self->db_select($username);
    
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
    my $user_id = shift;
    
    $self->db_delete(-values => [$user_id]);
}


sub store {
    my $self = shift;
    
    my $order = [qw( USERNAME
		     PASSWORD
		     DISABLED
		     FIRST_NAME
		     MIDDLE_NAME
                     LAST_NAME
		     POSITION
		     EMAIL
		     PHONE
		     FAX
		     TITLE_ID
		     LAB_ID   )];
    
    my %param_pos = map { $order->[$_] => $_ } 0 .. $#{$order};
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    # need to encrypt password
    $values[$param_pos{PASSWORD}] = &encrypt_password($values[$param_pos{PASSWORD}]);
    
    my $user_id = $self->area->IncrementerAdaptor->get_new_userID();
    unshift @values, $user_id;
    
    my $success = $self->db_insert(-values => \@values);
    
    return $success ? $user_id : undef;
};


sub update {
    my $self = shift;
    
    my $order = [qw( SET
                     QUALIFIERS )];
    
    # Arguments
    my ($set_params, $qual_params) = $self->rearrange_params($order, @_);
    
    # need to serialize working_data if it is being updated and is defined (i don't like what I need to do here...)
    for (my $i = 0; $i < $#{$set_params}; $i += 2) {
        if ($set_params->[$i] =~ /^(-|)working_data$/i) {
	    $set_params->[$i + 1] = &serialize($set_params->[$i + 1]) if defined $set_params->[$i + 1];
	    last;
	}
    }
    
    $self->db_update(-set_params  => $set_params,
		     -qual_params => $qual_params);
}


1;

