# User.pm
# MIMAS User Database Area Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::User;

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
                                  -name => 'User');
    
    return $self;
}


# Adaptors

sub AuthAdaptor {
    my $self = shift;
    $self->{adaptors}->{Auth} = $self->_get_adaptor('MIMAS::DB::User::Adaptors::AuthAdaptor') unless defined $self->{adaptors}->{Auth};
    return $self->{adaptors}->{Auth};
}

sub CountryAdaptor {
    my $self = shift;
    $self->{adaptors}->{Country} = $self->_get_adaptor('MIMAS::DB::User::Adaptors::CountryAdaptor') unless defined $self->{adaptors}->{Country};
    return $self->{adaptors}->{Country};
}

sub GroupAdaptor {
    my $self = shift;
    $self->{adaptors}->{Group} = $self->_get_adaptor('MIMAS::DB::User::Adaptors::GroupAdaptor') unless defined $self->{adaptors}->{Group};
    return $self->{adaptors}->{Group};
}

sub LabAdaptor {
    my $self = shift;
    $self->{adaptors}->{Lab} = $self->_get_adaptor('MIMAS::DB::User::Adaptors::LabAdaptor') unless defined $self->{adaptors}->{Lab};
    return $self->{adaptors}->{Lab};
}

sub IncrementerAdaptor {
    my $self = shift;
    $self->{adaptors}->{Incrementer} = $self->_get_adaptor('MIMAS::DB::User::Adaptors::IncrementerAdaptor') unless defined $self->{adaptors}->{Incrementer};
    return $self->{adaptors}->{Incrementer};
}

sub OrganizationAdaptor {
    my $self = shift;
    $self->{adaptors}->{Organization} = $self->_get_adaptor('MIMAS::DB::User::Adaptors::OrganizationAdaptor') unless defined $self->{adaptors}->{Organization};
    return $self->{adaptors}->{Organization};
}

sub TitleAdaptor {
    my $self = shift;
    $self->{adaptors}->{Title} = $self->_get_adaptor('MIMAS::DB::User::Adaptors::TitleAdaptor') unless defined $self->{adaptors}->{Title};
    return $self->{adaptors}->{Title};
}

sub UserAdaptor {
    my $self = shift;
    $self->{adaptors}->{User} = $self->_get_adaptor('MIMAS::DB::User::Adaptors::UserAdaptor') unless defined $self->{adaptors}->{User};
    return $self->{adaptors}->{User};
}


sub UserToGroupAdaptor {
    my $self = shift;
    $self->{adaptors}->{UserToGroup} = $self->_get_adaptor('MIMAS::DB::User::Adaptors::UserToGroupAdaptor') unless defined $self->{adaptors}->{UserToGroup};
    return $self->{adaptors}->{UserToGroup};
}


sub UserToFacilityAdaptor {
    my $self = shift;
    $self->{adaptors}->{UserToFacility} = $self->_get_adaptor('MIMAS::DB::User::Adaptors::UserToFacilityAdaptor') unless defined $self->{adaptors}->{UserToFacility};
    return $self->{adaptors}->{UserToFacility};
}


1;

