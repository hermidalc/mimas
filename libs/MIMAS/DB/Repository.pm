# Repository.pm
# MIMAS Repository Database Area Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Repository;

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
                                  -name => 'Repository');
    
    return $self;
}


# Adaptors

sub CelFileAdaptor {
    my $self = shift;
    $self->{adaptors}->{CelFile} = $self->_get_adaptor('MIMAS::DB::Repository::Adaptors::CelFileAdaptor') unless defined $self->{adaptors}->{CelFile};
    return $self->{adaptors}->{CelFile};
}

sub IncrementerAdaptor {
    my $self = shift;
    $self->{adaptors}->{Incrementer} = $self->_get_adaptor('MIMAS::DB::Repository::Adaptors::IncrementerAdaptor') unless defined $self->{adaptors}->{Incrementer};
    return $self->{adaptors}->{Incrementer};
}

sub SampleAdaptor {
    my $self = shift;
    $self->{adaptors}->{Sample} = $self->_get_adaptor('MIMAS::DB::Repository::Adaptors::SampleAdaptor') unless defined $self->{adaptors}->{Sample};
    return $self->{adaptors}->{Sample};
}

sub SampleAttributeAdaptor {
    my $self = shift;
    $self->{adaptors}->{SampleAttribute} = $self->_get_adaptor('MIMAS::DB::Repository::Adaptors::SampleAttributeAdaptor') unless defined $self->{adaptors}->{SampleAttribute};
    return $self->{adaptors}->{SampleAttribute};
}

sub TxtFileAdaptor {
    my $self = shift;
    $self->{adaptors}->{TxtFile} = $self->_get_adaptor('MIMAS::DB::Repository::Adaptors::TxtFileAdaptor') unless defined $self->{adaptors}->{TxtFile};
    return $self->{adaptors}->{TxtFile};
}


1;

