# Web.pm
# MIMAS Web Database Area Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Web;

use strict;
use warnings;
use base qw(MIMAS::DB::BaseArea);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $db = shift;
    
    my $self = $class->SUPER::new(-db   => $db,
                                  -name => 'Web');
    
    return $self;
}


# Adaptors

sub JobAdaptor {
    my $self = shift;
    $self->{adaptors}->{Job} = $self->_get_adaptor('MIMAS::DB::Web::Adaptors::JobAdaptor') unless defined $self->{adaptors}->{Job};
    return $self->{adaptors}->{Job};
}

sub IncrementerAdaptor {
    my $self = shift;
    $self->{adaptors}->{Incrementer} = $self->_get_adaptor('MIMAS::DB::Web::Adaptors::IncrementerAdaptor') unless defined $self->{adaptors}->{Incrementer};
    return $self->{adaptors}->{Incrementer};
}

sub SessionAdaptor {
    my $self = shift;
    $self->{adaptors}->{Session} = $self->_get_adaptor('MIMAS::DB::Web::Adaptors::SessionAdaptor') unless defined $self->{adaptors}->{Session};
    return $self->{adaptors}->{Session};
}

sub AlertAdaptor {
    my $self = shift;
    $self->{adaptors}->{Alert} = $self->_get_adaptor('MIMAS::DB::Web::Adaptors::AlertAdaptor') unless defined $self->{adaptors}->{Alert};
    return $self->{adaptors}->{Alert};
}


1;

