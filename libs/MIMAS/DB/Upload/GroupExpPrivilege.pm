# GroupExpPrivilege.pm
# MIMAS Upload Sample File Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Upload::GroupExpPrivilege;

use strict;
use warnings;
use base qw(MIMAS::DB::BaseDataEntity);

our $VERSION = 1.00;


sub can_write {
    my $self = shift;
    $self->{can_write} = shift if @_;
    return $self->{can_write};
}


sub experiment {
    my $self = shift;
    $self->{experiment} = $self->adaptor->area->ExperimentAdaptor->select_by_dbID($self->{experiment_id}) unless defined $self->{experiment};
    return $self->{experiment};
}

sub group {
    my $self = shift;
    $self->{group} = $self->adaptor->area->GroupAdaptor->select_by_dbID($self->{group_id}) unless defined $self->{group};
    return $self->{group};
}


1;

