# Library.pm
# MIMAS Library Database Area Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Library;

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
                                  -name => 'Library');
    
    return $self;
}


# Adaptors

sub MgedTermAdaptor {
    my $self = shift;
    $self->{adaptors}->{MgedTerm} = $self->_get_adaptor('MIMAS::DB::Library::Adaptors::MgedTermAdaptor') unless defined $self->{adaptors}->{MgedTerm};
    return $self->{adaptors}->{MgedTerm};
}

sub ArrayAdaptor {
    my $self = shift;
    $self->{adaptors}->{Array} = $self->_get_adaptor('MIMAS::DB::Library::Adaptors::ArrayAdaptor') unless defined $self->{adaptors}->{Array};
    return $self->{adaptors}->{Array};
}

sub TechnologyAdaptor {
    my $self = shift;
    $self->{adaptors}->{Technology} = $self->_get_adaptor('MIMAS::DB::Library::Adaptors::TechnologyAdaptor') unless defined $self->{adaptors}->{Technology};
    return $self->{adaptors}->{Technology};
}

sub AttrDetailAdaptor {
    my $self = shift;
    $self->{adaptors}->{AttrDetail} = $self->_get_adaptor('MIMAS::DB::Library::Adaptors::AttrDetailAdaptor') unless defined $self->{adaptors}->{AttrDetail};
    return $self->{adaptors}->{AttrDetail};
}

sub AttrDetailGroupAdaptor {
    my $self = shift;
    $self->{adaptors}->{AttrDetailGroup} = $self->_get_adaptor('MIMAS::DB::Library::Adaptors::AttrDetailGroupAdaptor') unless defined $self->{adaptors}->{AttrDetailGroup};
    return $self->{adaptors}->{AttrDetailGroup};
}

sub AttrGroupAdaptor {
    my $self = shift;
    $self->{adaptors}->{AttrGroup} = $self->_get_adaptor('MIMAS::DB::Library::Adaptors::AttrGroupAdaptor') unless defined $self->{adaptors}->{AttrGroup};
    return $self->{adaptors}->{AttrGroup};
}

sub AttributeAdaptor {
    my $self = shift;
    $self->{adaptors}->{Attribute} = $self->_get_adaptor('MIMAS::DB::Library::Adaptors::AttributeAdaptor') unless defined $self->{adaptors}->{Attribute};
    return $self->{adaptors}->{Attribute};
}

sub FactorGroupAdaptor {
    my $self = shift;
    $self->{adaptors}->{FactorGroup} = $self->_get_adaptor('MIMAS::DB::Library::Adaptors::FactorGroupAdaptor') unless defined $self->{adaptors}->{FactorGroup};
    return $self->{adaptors}->{FactorGroup};
}

sub IncrementerAdaptor {
    my $self = shift;
    $self->{adaptors}->{Incrementer} = $self->_get_adaptor('MIMAS::DB::Library::Adaptors::IncrementerAdaptor') unless defined $self->{adaptors}->{Incrementer};
    return $self->{adaptors}->{Incrementer};
}


1;

