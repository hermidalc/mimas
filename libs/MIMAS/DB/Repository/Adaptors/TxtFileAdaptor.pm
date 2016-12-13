# TxtFileAdaptor.pm
# MIMAS Repository Txt File Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Repository::Adaptors::TxtFileAdaptor;

use strict;
use warnings;
use Compress::Zlib;
use MIMAS::DB::Repository::TxtFile;
use base qw(MIMAS::DB::BaseAdaptor);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $area = shift;
    
    my $self = $class->SUPER::new(-area => $area,
                                  -name => 'TxtFile');
    
    return $self;
}


# By default, the TxtFileAdaptor creates TxtFile objects without the TXT BLOB data "contents" column for obvious memory and speed reasons
# If the programmer then tries to access the contents property of a particular TxtFile object by saying $txt_file->contents
# then the "get_contents_by_dbID" method is secretly called which will go and get that TXT file's TXT data


# only used internally
sub _create_object {
    my $self = shift;
    
    # Arguments
    my $row = shift;
    
    return MIMAS::DB::Repository::TxtFile->new(adaptor     => $self,
                                               dbID        => $row->{txt_file_id},
                                               fingerprint => $row->{fingerprint},
                                               version     => $row->{version},
                                               array_id    => $row->{array_id});
}


# only used internally
sub _create_object_collection {
    my $self = shift;
    
    # Arguments
    my $rows = shift;
    
    my $txt_files;
    for my $row (@{$rows}) { $txt_files->{$row->{txt_file_id}} = $self->_create_object($row) }
    
    return $txt_files;
}


# only used by TxtFile.pm object
sub get_contents_by_dbID {
    my $self = shift;
    
    # Arguments
    my $dbID = shift;
    
    my $row = $self->db_select($dbID);
    
                  # need to uncompress file contents
    return $row ? (Compress::Zlib::uncompress($row->[0]) or $self->throw('Could not uncompress TXT file data'))
                : undef;
}


sub select_all {
    my $self = shift;
    
    my $rows = $self->db_select();
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_by_arrayID {
    my $self = shift;
    
    # Arguments
    my $array_id = shift;
    
    my $rows = $self->db_select($array_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_by_seriesID {
    my $self = shift;
    
    # Arguments
    my $series_id = shift;
    
    my $rows = $self->db_select($series_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_by_version {
    my $self = shift;
    
    # Arguments
    my $version = shift;
    
    my $rows = $self->db_select($version);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_by_fingerprint {
    my $self = shift;
    
    # Arguments
    my $fingerprint = shift;
    
    my $row = $self->db_select($fingerprint);
    
    return $row ? $self->_create_object($row) : undef;
}


sub select_by_dbID {
    my $self = shift;
    
    # Arguments
    my $dbID = shift;
    
    my $row = $self->db_select($dbID);
    
    return $row ? $self->_create_object($row) : undef;
}


sub store {
    my $self = shift;
    
    my $order = [qw( FINGERPRINT
		     VERSION
		     CONTENTS
		     ARRAY_ID )];
    
    my %param_pos = map { $order->[$_] => $_ } 0 .. $#{$order};
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);
    
    # need to compress file contents at best compression level
    $values[$param_pos{CONTENTS}] = Compress::Zlib::compress($values[$param_pos{CONTENTS}], Z_BEST_COMPRESSION) or $self->throw('Could not compress TXT file data');
    
    my $txt_file_id = $self->area->IncrementerAdaptor->get_new_fileID();
    unshift @values, $txt_file_id;
    
    my $success = $self->db_insert(-values => \@values);
    
    return $success ? $txt_file_id : undef;
}


# methods to do everything by fetch, not select in DBI

sub init_fetch_all {
    my $self = shift;
    
    $self->db_init_fetch();
}


sub fetch {
    my $self = shift;
    
    my $row = $self->sth->fetchrow_hashref;
    
    return $row ? $self->_create_object($row) : undef;
}


1;

