# Upload.pm
# MIMAS Upload Database Area Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Upload;

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
                                  -name => 'Upload');
    
    return $self;
}


# Adaptors

sub AuthAdaptor {
    my $self = shift;
    $self->{adaptors}->{Auth} = $self->_get_adaptor('MIMAS::DB::Upload::Adaptors::AuthAdaptor') unless defined $self->{adaptors}->{Auth};
    return $self->{adaptors}->{Auth};
}

sub ExpAttributeAdaptor {
    my $self = shift;
    $self->{adaptors}->{ExpAttribute} = $self->_get_adaptor('MIMAS::DB::Upload::Adaptors::ExpAttributeAdaptor') unless defined $self->{adaptors}->{ExpAttribute};
    return $self->{adaptors}->{ExpAttribute};
}

sub ExpConditionAdaptor {
    my $self = shift;
    $self->{adaptors}->{ExpCondition} = $self->_get_adaptor('MIMAS::DB::Upload::Adaptors::ExpConditionAdaptor') unless defined $self->{adaptors}->{ExpCondition};
    return $self->{adaptors}->{ExpCondition};
}

sub ExpFactorAdaptor {
    my $self = shift;
    $self->{adaptors}->{ExpFactor} = $self->_get_adaptor('MIMAS::DB::Upload::Adaptors::ExpFactorAdaptor') unless defined $self->{adaptors}->{ExpFactor};
    return $self->{adaptors}->{ExpFactor};
}

sub ExperimentAdaptor {
    my $self = shift;
    $self->{adaptors}->{Experiment} = $self->_get_adaptor('MIMAS::DB::Upload::Adaptors::ExperimentAdaptor') unless defined $self->{adaptors}->{Experiment};
    return $self->{adaptors}->{Experiment};
}

sub IncrementerAdaptor {
    my $self = shift;
    $self->{adaptors}->{Incrementer} = $self->_get_adaptor('MIMAS::DB::Upload::Adaptors::IncrementerAdaptor') unless defined $self->{adaptors}->{Incrementer};
    return $self->{adaptors}->{Incrementer};
}

sub SampleAdaptor {
    my $self = shift;
    $self->{adaptors}->{Sample} = $self->_get_adaptor('MIMAS::DB::Upload::Adaptors::SampleAdaptor') unless defined $self->{adaptors}->{Sample};
    return $self->{adaptors}->{Sample};
}

sub SampleAttributeAdaptor {
    my $self = shift;
    $self->{adaptors}->{SampleAttribute} = $self->_get_adaptor('MIMAS::DB::Upload::Adaptors::SampleAttributeAdaptor') unless defined $self->{adaptors}->{SampleAttribute};
    return $self->{adaptors}->{SampleAttribute};
}

sub SampleFileAdaptor {
    my $self = shift;
    $self->{adaptors}->{SampleFile} = $self->_get_adaptor('MIMAS::DB::Upload::Adaptors::SampleFileAdaptor') unless defined $self->{adaptors}->{SampleFile};
    return $self->{adaptors}->{SampleFile};
}

sub SampleToFileAdaptor {
    my $self = shift;
    $self->{adaptors}->{SampleToFile} = $self->_get_adaptor('MIMAS::DB::Upload::Adaptors::SampleToFileAdaptor') unless defined $self->{adaptors}->{SampleToFile};
    return $self->{adaptors}->{SampleToFile};
}

sub SampleFileDataAdaptor {
    my $self = shift;
    $self->{adaptors}->{SampleFileData} = $self->_get_adaptor('MIMAS::DB::Upload::Adaptors::SampleFileDataAdaptor') unless defined $self->{adaptors}->{SampleFileData};
    return $self->{adaptors}->{SampleFileData};
}

sub GroupExpPrivilegeAdaptor {
    my $self = shift;
    $self->{adaptors}->{GroupExpPrivilege} = $self->_get_adaptor('MIMAS::DB::Upload::Adaptors::GroupExpPrivilegeAdaptor') unless defined $self->{adaptors}->{GroupExpPrivilege};
    return $self->{adaptors}->{GroupExpPrivilege};
}


1;

