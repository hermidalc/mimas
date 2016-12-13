# SessionAdaptor.pm
# MIMAS Web Session Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Web::Adaptors::SessionAdaptor;

use strict;
use warnings;
use MIMAS::Consts;
use base qw(MIMAS::DB::BaseAdaptor);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $area = shift;
    
    my $self = $class->SUPER::new(-area => $area,
                                  -name => 'Session');
    
    return $self;
}


sub get_LongReadLen {
    my $self = shift;
    return $self->db_select();
}


sub create {
    my $self = shift;
    
    my $session;
    eval {
        $session = $self->_session();
	$self->area->db->commit();
    };
    
    unless ($@) {
        return $session;
    } else {
        $self->warn("CREATE SESSION transaction aborted:\n$@");
        eval { $self->area->db->rollback() };
	return;
    }
}



sub _session {
    my $self = shift;
    return $self->area->db->Engine->session(@_);
}

sub fetch {
    my $self = shift;
    
    # Arguments
    my $session_id = shift;
    
    $self->throw('Missing required parameter: session_id') unless defined $session_id;
    
    my $session;
    eval {
        $session = $self->_session($session_id);
    };
    
    unless ($@) {
	if ((time - $session->{timestamp})/60 < MIMAS_SESSION_EXPIRE_TIME) {
	    return $session;
	} else {
	    $self->delete($session);
	    return;
	}
    } else {
        $self->warn("FETCH SESSION failed:\n$@");
	return;
    }
}


sub delete {
    my $self = shift;
    
    # Arguments
    my $session = shift;
    
    $self->throw('Missing required parameter: session') unless defined $session;
    
    eval {
        tied(%{$session})->delete;
	untie %{$session};
	undef $session;
	$self->area->db->commit();
    };
    
    unless ($@) {
        return 1;
    } else {
        $self->warn("DELETE SESSION transaction aborted:\n$@");
        eval { $self->area->db->rollback() };
	return;
    }
}


sub store {
    my $self = shift;
    
    # Arguments
    my $session = shift;
    
    $self->throw('Missing required parameter: session') unless defined $session;
    
    eval {
        untie %{$session};
	undef $session;
	$self->area->db->commit();


    };
    
    unless ($@) {
        return 1;
    } else {
        $self->warn("STORE SESSION transaction aborted:\n$@");
        eval { $self->area->db->rollback() };
	return;
    }
}


1;

