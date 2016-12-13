# DB.pm
# MIMAS Database Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB;

use strict;
use warnings;
use MIMAS::Consts;
use base qw(MIMAS::BaseDB);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    my $self  = { };
    bless $self, $class;
    
    my $order = [qw( SERVICE )];
    
    # Arguments
    my ($service) = $self->rearrange_params($order, @_);
    
    my ($DB_USERNAME, $DB_PASSWORD) = uc($service) eq 'ADMIN' ? (MIMAS_ADMIN_DB_USERNAME, MIMAS_ADMIN_DB_PASSWORD) :
                                      uc($service) eq 'WEB'   ? (MIMAS_WEB_DB_USERNAME,   MIMAS_WEB_DB_PASSWORD)   : ();
    
    $self = $class->SUPER::new(-driver   => MIMAS_DB_DRIVER, 
                               -host     => MIMAS_DB_HOSTNAME, 
                               -database => MIMAS_DB_SID, 
                               -port     => MIMAS_DB_PORT, 
                               -user     => $DB_USERNAME, 
                               -password => $DB_PASSWORD);
    
    $self->service($service);
    
    return $self;
}


sub service {
    my $self = shift;
    $self->{service} = shift if @_;
    return $self->{service};
}


# Areas

sub Library {
    my $self = shift;
    $self->{areas}->{Library} = $self->_get_area('MIMAS::DB::Library') unless defined $self->{areas}->{Library};
    return $self->{areas}->{Library};
}

sub Repository {
    my $self = shift;
    $self->{areas}->{Repository} = $self->_get_area('MIMAS::DB::Repository') unless defined $self->{areas}->{Repository};
    return $self->{areas}->{Repository};
}

sub Upload {
    my $self = shift;
    $self->{areas}->{Upload} = $self->_get_area('MIMAS::DB::Upload') unless defined $self->{areas}->{Upload};
    return $self->{areas}->{Upload};
}

sub User {
    my $self = shift;
    $self->{areas}->{User} = $self->_get_area('MIMAS::DB::User') unless defined $self->{areas}->{User};
    return $self->{areas}->{User};
}

sub Web {
    my $self = shift;
    $self->{areas}->{Web} = $self->_get_area('MIMAS::DB::Web') unless defined $self->{areas}->{Web};
    return $self->{areas}->{Web};
}


sub DESTROY {
    my $self = shift;
    
    $self->SUPER::DESTROY if $self->can('SUPER::DESTROY');
    
    # print STDERR "DESTROYED MIMAS DATABASE OBJECT\n";
}


1;

