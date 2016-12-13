# IncrementerAdaptor.pm
# MIMAS User Incrementer Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::User::Adaptors::IncrementerAdaptor;

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
                                  -name => 'Incrementer');
    
    return $self;
}


sub get_new_labID {
    my $self = shift;
    return $self->db_select();
}


sub get_new_orgID {
    my $self = shift;
    return $self->db_select();
}


sub get_new_userID {
    my $self = shift;
    return $self->db_select();
}


sub get_new_groupID {
    my $self = shift;
    return $self->db_select();
}


1;

