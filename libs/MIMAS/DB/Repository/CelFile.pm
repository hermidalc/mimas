# CelFile.pm
# MIMAS Repository Cel File Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Repository::CelFile;

use strict;
use warnings;
use base qw(MIMAS::DB::BaseDataEntity);

our $VERSION = 1.00;


sub fingerprint {
    my $self = shift;
    $self->{fingerprint} = shift if @_;
    return $self->{fingerprint};
}


sub version {
    my $self = shift;
    $self->{version} = shift if @_;
    return $self->{version};
}


sub contents {
    my $self = shift;
    $self->{contents} = $self->adaptor->get_contents_by_dbID($self->dbID) unless defined $self->{contents};
    return $self->{contents};
}


sub array {
    my $self = shift;
    $self->{array} = $self->adaptor->area->db->Library->ArrayAdaptor->select_by_dbID($self->{array_id}) unless defined $self->{array};
    return $self->{array};
}


sub samples {
    my $self = shift;
    $self->{samples} = $self->adaptor->area->SampleAdaptor->select_all_by_celID($self->dbID) unless defined $self->{samples};
    return $self->{samples};
}


1;

