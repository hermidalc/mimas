# IncrementerAdaptor.pm
# MIMAS Upload Incrementer Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Upload::Adaptors::IncrementerAdaptor;

use strict;
use warnings;
use base qw(MIMAS::DB::BaseAdaptor);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $area = shift;
    
    my $self = $class->SUPER::new(-area => $area,
                                  -name => 'Incrementer');
    
    return $self;
}


sub get_new_expID {
    my $self = shift;
    return $self->db_select();
}


sub get_new_condID {
    my $self = shift;
    return $self->db_select();
}


sub get_new_sampleID {
    my $self = shift;
    return $self->db_select();
}


sub get_new_sample_fileID {
    my $self = shift;
    return $self->db_select();
}


sub get_new_sample_to_fileID {
    my $self = shift;
    return $self->db_select();
}


sub get_new_exp_attrID {
    my $self = shift;
    return $self->db_select();
}


sub get_new_sample_attrID {
    my $self = shift;
    return $self->db_select();
}


1;

