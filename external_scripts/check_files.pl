#!/usr/bin/perl

# check_files.pl
# MIMAS script to check the integrity of stored files
# and manage chunk sizes.
#
#######################################################
# Copyright 2006 Alexandre Gattiker
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

use strict;
use warnings FATAL => 'all';
use FindBin;
use lib "$FindBin::Bin/../libs";
use sigtrap qw(handler sig_handler normal-signals error-signals ALRM);
use MIMAS::DB;
use MIMAS::Consts;
use MIMAS::Utils;
use MIMAS::SampleFileParser;

sub sig_handler {
    die "\n$0 exited [", scalar localtime, "]\n\n";
}


# Set up Environment
&set_env();


# Create MIMAS Database object
print "Connecting to MIMAS...";
my $mimas_db = MIMAS::DB->new(-service => 'WEB');
print " done!\n";

{
    my $experiments = $mimas_db->Upload->ExperimentAdaptor->select_all();

    for my $exp_id (sort {$a <=> $b} keys %$experiments) {
        my $experiment = $experiments->{$exp_id};

        warn "[Checking files for experiment] experiment_id=" . $experiment->dbID;

        my $sample_files = $mimas_db->Upload->SampleFileAdaptor->select_all_by_expID($experiment->dbID);
        for my $sample_file (values %{$sample_files}) {

            #The fetch routine automatically checks the file checksum is correct.
            my $contents_ptr = $sample_file->contents_ptr;

            #If the chunk sizes in the database are larger than MIMAS_DB_FILE_CHUNK_SIZE, reduce the chunks.
            my $length = length $$contents_ptr;
            my $max_chunk_size = $mimas_db->Upload->SampleFileDataAdaptor->fetch_max_chunk_size_by_sample_fileID($sample_file->dbID);
            $max_chunk_size ||= 0;
            if ($max_chunk_size > MIMAS_DB_FILE_CHUNK_SIZE) {
                warn "Reducing chunk size from $max_chunk_size to " . MIMAS_DB_FILE_CHUNK_SIZE . "\n";
                $mimas_db->Upload->SampleFileAdaptor->update_contents_by_dbID($sample_file->dbID, $contents_ptr);

                #Reload the sample file contents, to have the file checksum checked again after the update.
                my $sample_file2 =  $mimas_db->Upload->SampleFileAdaptor->select_by_dbID($sample_file->dbID);
                my $contents_ptr2 = $sample_file2->contents_ptr;

                #Commit changes frequently to avoid filling transaction segments.
                print "Committing...";
                $mimas_db->commit;
                print " done!\n";

            }

            my $validator = new MIMAS::SampleFileParser(-format => $sample_file->format);
            #my $fh = new IO::File $contents_ptr or die $!;
            #my @errors = $validator->parse($fh);
            open *FH, '<', $contents_ptr or die $!;
            eval {
                my $cursor = $validator->parse(*FH, undef, undef);
                $cursor->quickcheck;
				my $hybridization_names = $cursor->hybridization_names;
                for my $sample_to_file (values %{$sample_file->sample_to_files}) {
                    my @err = $cursor->validate_on_sample($sample_to_file->sample);
                    die @err if @err;
                }
                unless ($sample_file->format eq 'CEL') {
                    $cursor = $validator->parse(*FH, undef, $hybridization_names->[0]);
                    1 while $cursor->getline;
                }
            };
            warn $@ if $@;
        }
    }
}


exit 0;

