# SampleFile.pm
# MIMAS Upload Sample File Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Upload::SampleFile;

use strict;
use warnings;
use MIMAS::Utils qw(generate_fingerprint);
use base qw(MIMAS::DB::BaseDataEntity);

our $VERSION = 1.00;


sub format {
    my $self = shift;
    $self->{format} = shift if @_;
    return $self->{format};
}


sub experiment_id {
    my $self = shift;
    $self->{experiment_id} = shift if @_;
    return $self->{experiment_id};
}


sub upload_date {
    my $self = shift;
    $self->{upload_date} = shift if @_;
    return $self->{upload_date};
}


sub hybridization_date {
    my $self = shift;
    $self->{hybridization_date} = shift if @_;
    return $self->{hybridization_date};
}


sub fingerprint {
    my $self = shift;
    $self->{fingerprint} = shift if @_;
    return $self->{fingerprint};
}


sub file_name {
    my $self = shift;
    $self->{file_name} = shift if @_;
    return $self->{file_name};
}


#Use is discouraged because memory-intensive (use contents_ptr)
sub contents {
    my $self = shift;
    $self->{contents} = $self->contents_ptr;
    return ${$self->{contents}};
}


sub contents_ptr {
    my $self = shift;
    return $self->{contents} if defined $self->{contents};
    my $contents_ptr = $self->adaptor->get_contents_by_dbID($self->dbID);
    my $fingerprint = $self->fingerprint;
    my $fingerprint2 = generate_fingerprint($$contents_ptr);
    die "MISMATCH IN SAMPLE FILE FINGERPRINTS: calculated=$fingerprint2 vs. stored=$fingerprint" if $fingerprint ne $fingerprint2;
    return $contents_ptr;
}


sub experiment {
    my $self = shift;
    $self->{experiment} = $self->adaptor->area->ExperimentAdaptor->select_by_dbID($self->{experiment_id}) unless defined $self->{experiment};
    return $self->{experiment};
}


sub sample_to_files {
    my $self = shift;
    $self->{sample_to_files} = $self->adaptor->area->SampleToFileAdaptor->select_all_by_sample_file_id($self->dbID) unless defined $self->{sample_to_files};
    return $self->{sample_to_files};
}


sub samples {
    my $self = shift;
    $self->{samples} = $self->adaptor->area->SampleAdaptor->select_all_by_sample_file_id($self->dbID) unless defined $self->{samples};
    return $self->{samples};
}

1;

