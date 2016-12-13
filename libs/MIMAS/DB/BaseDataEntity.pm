# BaseDataEntity.pm
# MIMAS Base Class for all Data Entities (i.e. Tables)
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::BaseDataEntity;

use strict;
use warnings;
use base qw(Root);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    my $self  = { @_ };
    bless $self, $class;
    
    return $self;
}


sub adaptor {
    my $self = shift;
    $self->{adaptor} = shift if @_;
    return $self->{adaptor};
}


sub dbID {
    my $self = shift;
    $self->{dbID} = shift if @_;
    return $self->{dbID};
}


1;

