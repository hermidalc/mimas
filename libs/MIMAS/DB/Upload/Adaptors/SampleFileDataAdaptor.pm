# SampleFileDataAdaptor.pm
# MIMAS Upload Sample File Adaptor Class
#
#######################################################
# Copyright 2006 Alexandre Gattiker
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Upload::Adaptors::SampleFileDataAdaptor;

use strict;
use warnings;
use Compress::LZF;
use MIMAS::Consts;
use base qw(MIMAS::DB::BaseAdaptor);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $area = shift;
    
    my $self = $class->SUPER::new(-area => $area,
                                  -name => 'SampleFileData');
    
    return $self;
}


# only used internally
sub _create_object {
    my $self = shift;
    
    # Arguments
    my $rows = shift;
    
    return \Compress::LZF::decompress(join "", map {$_->[0]} @$rows);
}


# By default, the SampleFileDataAdaptor creates SampleFileData objects without the BLOB data "contents" column for obvious memory and speed reasons
# If the programmer then tries to access the contents property of a particular SampleFileData object by saying $sample_file->contents_ptr
# then the "get_contents_by_dbID" method is secretly called which will go and get that file's BLOB data
sub fetch_contents_by_sample_fileID {
    my $self = shift;
    
    # Arguments
    my $sample_file_id = shift;
    
    my $rows = $self->db_select($sample_file_id);
    
    return $rows ? $self->_create_object($rows) : undef;
}


sub fetch_max_chunk_size_by_sample_fileID {
    my $self = shift;
    
    # Arguments
    my $sample_file_id = shift;
    
    my $rows = $self->db_select($sample_file_id);
    
    return $rows ? $rows->[0] : undef;
}


sub remove_by_sample_file_ID {
    my $self = shift;
    
    # Arguments
    my $sample_file_id = shift;
    
    $self->db_delete(-values => [$sample_file_id]);
}


sub store {
    my $self = shift;
    
    my $order = [qw(
        sample_file_id
        chunk_number
        contents
        )];
    
    my %param_pos = map { $order->[$_] => $_ } 0 .. $#{$order};
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    my $success = $self->db_insert(-values => \@values);
    
    return $success ? 1 : undef;
}

1;

