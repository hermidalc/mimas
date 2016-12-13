# SampleFileAdaptor.pm
# MIMAS Upload Sample File Adaptor Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Upload::Adaptors::SampleFileAdaptor;

use strict;
use warnings;
use Compress::LZF;
use MIMAS::Consts;
use MIMAS::Utils qw(generate_fingerprint);
use MIMAS::DB::Upload::SampleFile;
use base qw(MIMAS::DB::BaseAdaptor);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $area = shift;
    
    my $self = $class->SUPER::new(-area => $area,
                                  -name => 'SampleFile');
    
    return $self;
}


# By default, the SampleFileAdaptor creates SampleFile objects without the BLOB data "contents" column for obvious memory and speed reasons
# If the programmer then tries to access the contents property of a particular SampleFile object by saying $sample_file->contents_ptr
# then the "get_contents_by_dbID" method is secretly called which will go and get that file's BLOB data


# only used internally
sub _create_object {
    my $self = shift;
    
    # Arguments
    my $row = shift;
    
    return MIMAS::DB::Upload::SampleFile->new(adaptor   => $self,
	                                      dbID      => $row->{sample_file_id},
					      format => $row->{format},
					      experiment_id => $row->{experiment_id},
					      upload_date => $row->{upload_date},
					      hybridization_date => $row->{hybridization_date},
					      fingerprint => $row->{fingerprint},
					      file_name => $row->{file_name});
}


# only used internally
sub _create_object_collection {
    my $self = shift;
    
    # Arguments
    my $rows = shift;
    
    my $files;
    for my $row (@{$rows}) { $files->{$row->{sample_file_id}} = $self->_create_object($row) }
    
    return $files;
}


# only used by SampleFile.pm object
sub get_contents_by_dbID {
    my $self = shift;
    
    # Arguments
    my $dbID = shift;
    
    return $self->area->SampleFileDataAdaptor->fetch_contents_by_sample_fileID($dbID);
}


sub select_all {
    my $self = shift;
    
    my $rows = $self->db_select();
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_by_expID {
    my $self = shift;
    
    # Arguments
    my $experiment_id = shift;
    
    my $rows = $self->db_select($experiment_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_by_condID {
    my $self = shift;
    
    # Arguments
    my $condition_id = shift;
    
    my $rows = $self->db_select($condition_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_all_by_sampleID {
    my $self = shift;
    
    # Arguments
    my $sample_id = shift;
    
    my $rows = $self->db_select($sample_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


#used by legacy GermOnline code at www.germonline.org
sub select_all_germonline_by_expID {
    my $self = shift;
    
    # Arguments
    my $experiment_id = shift;
    
    my $rows = $self->db_select($experiment_id);
    
    return $rows ? $self->_create_object_collection($rows) : undef;
}


sub select_by_dbID {
    my $self = shift;
    
    # Arguments
    my $dbID = shift;
    
    my $row = $self->db_select($dbID);
    
    return $row ? $self->_create_object($row) : undef;
}


sub select_by_expID_fingerprint {
    my $self = shift;
    
    # Arguments
    my $expID = shift;
    my $fingerprint = shift;
    
    my $row = $self->db_select($expID, $fingerprint);
    
    return $row ? $self->_create_object($row) : undef;
}


sub remove_by_dbID {
    my $self = shift;
    
    # Arguments
    my $dbID = shift;
    
    $self->db_delete(-values => [$dbID]);
}


sub remove_all_by_sampleID {
    my $self = shift;
    
    # Arguments
    my $sample_id = shift;
    
    $self->db_delete(-values => [$sample_id]);
}


sub store {
    my $self = shift;
    
    my $order = [qw(
        contents
        format
        experiment_id
        hybridization_date
        file_name
        fingerprint
        )];
        #upload_date is DEFAULT SYSDATE
    
    # Arguments
    my @values = $self->rearrange_params($order, @_);

    my $contents = shift @values; #remove contents
    
    my $sample_file_id = $self->area->IncrementerAdaptor->get_new_sample_fileID();
    unshift @values, $sample_file_id;

    my $success = $self->db_insert(-values => \@values);

    $self->_store_data($sample_file_id, \$contents);
    
    return $success ? $sample_file_id : undef;
}

sub _store_data {
    my $self = shift;
    my $sample_file_id = shift;
    my $contents_ptr = shift;

    # need to compress file contents at best speed (LZF algorithm extremely fast and light weight)
    my $contents_compressed = Compress::LZF::compress($$contents_ptr) or $self->throw('Could not compress sample file data');
    undef $contents_ptr;

    my $chunk_number=0;
    for (my $filepos=0; $filepos<length $contents_compressed; $filepos+= MIMAS_DB_FILE_CHUNK_SIZE) {
        $self->area->SampleFileDataAdaptor->store(
            -sample_file_id => $sample_file_id,
            -chunk_number   => $chunk_number++,
            -contents       => substr($contents_compressed, $filepos, MIMAS_DB_FILE_CHUNK_SIZE),
        );
    }
}


sub update {
    my $self = shift;
    
    my $order = [qw( SET
                     QUALIFIERS )];
    
    # Arguments
    my ($set_params, $qual_params) = $self->rearrange_params($order, @_);
    
=for nobody
    # need to compress file contents if it is being updated and is defined (i don't like what I need to do here...)
    for (my $i = 0; $i < $#{$set_params}; $i += 2) {
        if ($set_params->[$i] =~ /^(-|)contents$/i) {
	    $set_params->[$i + 1] = Compress::LZF::compress($set_params->[$i + 1]) if defined $set_params->[$i + 1];
	    last;
	}
    }
=cut
    
    $self->db_update(-set_params  => $set_params,
		     -qual_params => $qual_params);
}


sub update_contents_by_dbID {
    my $self = shift;
    
    # Arguments
    my $dbID = shift;
    my $contents_ptr = shift;
    
    $self->area->SampleFileDataAdaptor->remove_by_sample_file_ID($dbID);
    $self->_store_data($dbID, $contents_ptr);
}

1;

