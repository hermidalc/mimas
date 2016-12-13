# Base.pm
# MIMAS Base Class for Web Sub-classes
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::Web::Base;

use strict;
use warnings;
use Scalar::Util qw(weaken);
use base qw(Root);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    my $self  = { };
    bless $self, $class;
    
    # Arguments
    my $web = shift;
    
    $self->web($web);
    
    return $self;
}


sub web {
    my $self = shift;
    # Weaken reference to WEB master object because it has a circular reference back to this object
    &weaken($self->{web} = shift) if @_;
    return $self->{web};
}


1;

