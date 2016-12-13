# AlertAdaptor.pm
# MIMAS Web Alert Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Web::Adaptors::AlertAdaptor;

use strict;
use warnings;
use MIMAS::Consts;
use MIMAS::Utils;
use MIMAS::DB::Web::Alert;
use base qw(MIMAS::DB::BaseAdaptor);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $area = shift;
    
    my $self = $class->SUPER::new(-area => $area,
                                  -name => 'Alert');
    
    return $self;
}


# only used internally
sub _create_object {
    my $self = shift;
    
    # Arguments
    my $row = shift;
    
    return MIMAS::DB::Web::Alert->new(adaptor => $self,
                                      dbID    => $row->{alert_id},
                                      type    => $row->{type},
                                      time    => $row->{time},
                                      data    => defined $row->{data} ? &unserialize($row->{data}) : undef,
                                      user_id => $row->{user_id});
}


# only used internally
# AlertAdaptor returns a reference to an ARRAY of Alert objects because we have it
# already sorted by "time" during the SQL select and we want to maintain this order
sub _create_object_collection {
    my $self = shift;
    
    # Arguments
    my $rows = shift;
    
    my $alerts;
    for my $row (@{$rows}) { push @{$alerts}, $self->_create_object($row) }
    
    return $alerts;
}


sub select_all {
    my $self = shift;
    
    my $rows = $self->db_select();
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_by_userID {
    my $self = shift;
    
    # Arguments
    my $user_id = shift;
    
    my $rows = $self->db_select($user_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
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
    my $alert_id = shift;
    
    my $alert = $self->select_by_dbID($alert_id);
    
    if (defined $alert) {
        $self->db_delete(-values => [$alert_id]);
        
	if ($alert->type eq 'SAMPLE DOWNLOAD') {
	    $self->warn("Could not delete file @{[MIMAS_DOWNLOAD_DIR]}/@{[$alert->data->{filename}]}: $!")                       unless unlink "@{[MIMAS_DOWNLOAD_DIR]}/@{[$alert->data->{filename}]}";
	}
    }
}


sub store {
    my $self = shift;
    
    my $order = [qw( TYPE
                     DATA
		     USER_ID )];
    
    my %param_pos = map { $order->[$_] => $_ } 0 .. $#{$order};
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    # need to serialize data
    $values[$param_pos{DATA}] = &serialize($values[$param_pos{DATA}]) if defined $values[$param_pos{DATA}];
    
    my $alert_id = $self->area->IncrementerAdaptor->get_new_dbID();
    unshift @values, $alert_id;
    
    my $success = $self->db_insert(-values => \@values);
    
    return $success ? $alert_id : undef;
}


1;

