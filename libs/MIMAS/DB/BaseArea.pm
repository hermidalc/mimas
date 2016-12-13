# BaseArea.pm
# MIMAS Base Class for Database Areas
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::BaseArea;

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
    
    my $order = [qw( DB
                     NAME )];
    
    # Arguments
    my ($db, $name) = $self->rearrange_params($order, @_);
    
    $self->db($db);
    $self->name($name);
    
    return $self;
}


sub db {
    my $self = shift;
    # Weaken reference to database object because it has a circular reference back to this area object
    &weaken($self->{db} = shift) if @_;
    return $self->{db};
}


sub name {
    my $self = shift;
    $self->{name} = shift if @_;
    return $self->{name};
}


# only used internally
sub _get_adaptor {
    my $self = shift;
    
    # Arguments
    my ($module, @args) = @_;
    
    eval "require $module";
    $self->throw("Database Adaptor Module [$module] load error: $@") if $@;
    
    my $adaptor = $module->new($self, @args);
    
    return $adaptor;
}


1;

