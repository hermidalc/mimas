# Consts.pm
# MIMAS Constants
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::Consts;

use strict;
use warnings;
require Exporter;
use Carp qw(confess);

our @ISA      = qw(Exporter);
our $VERSION  = 1.00;

#Get instance-specific constants
{
	my $instance = $ENV{MIMAS_INSTANCE} or confess "FATAL: environment variable MIMAS_INSTANCE is not set";
	my $module = "MIMAS/Consts/$instance.pm";
	require $module;
}


#automagically export all declared constants
our @EXPORT = grep {s/^MIMAS::Consts:://} keys %constant::declared;


use constant MIMAS_SCRIPT_URL_PATH                  =>  '/perl/';

use constant MIMAS_GROUP_ADMIN                      =>  1;                                                          # don't ever change group IDs
use constant MIMAS_GROUP_CURATOR                    =>  2;
use constant MIMAS_GROUP_REG_USER                   =>  3;

use constant MIMAS_UPLOAD_MIN_PROGRESS              =>  1;                                                          # don't ever change progress range
use constant MIMAS_UPLOAD_MAX_PROGRESS              =>  5;
use constant MIMAS_UPLOAD_SAMPLE_ATTRS_PROGRESS     =>  4;

use constant MIMAS_UPLOAD_WORKING                   =>  0;                                                          # don't ever change upload states
use constant MIMAS_UPLOAD_IN_CURATION               =>  1;
use constant MIMAS_UPLOAD_QUEUED                    =>  2;
use constant MIMAS_UPLOAD_UPDATE                    =>  3;
use constant MIMAS_UPLOAD_IN_REPOSITORY             =>  4;
use constant MIMAS_UPLOAD_LOADING                   =>  9;

use constant MIMAS_FILE_BUFFER_SIZE                 =>  1_048_576;                                                  # 1 MB     file (read/write) buffer size, in bytes
use constant MIMAS_FILE_MAX_OPEN_TRIES              =>  100;
use constant MIMAS_DB_FILE_CHUNK_SIZE               =>  16_000_000;                                                 #          max size of BLOBs in sample_file_data table. On MySQL this must be less than max_allowed_packet
use constant MIMAS_UPLOAD_MAX_FILE_SIZE             =>  52_428_800;                                                 # 50 MB    max upload file size, in bytes
use constant MIMAS_UPLOAD_MAX_DIR_SIZE              =>  53_687_091_200;                                             # 50 GB    max upload directory size, in bytes
use constant MIMAS_UPLOAD_MAX_NUM_FILES             =>  500;                                                         # max number of files allowed per upload attempt
use constant MIMAS_UPLOAD_POST_MAX                  =>  MIMAS_UPLOAD_MAX_FILE_SIZE * MIMAS_UPLOAD_MAX_NUM_FILES;
use constant MIMAS_UPLOAD_REQ_FILE_EXTS             =>  { map { $_ => 1 } qw( CEL  Illumina      ) };               # change in JavaScript if changed here
use constant MIMAS_UPLOAD_VALID_FILE_EXTS_NON_NOR   =>  [ qw( CEL  Illumina                   ) ];
use constant MIMAS_UPLOAD_VALID_FILE_EXTS_NOR_1     =>  [ qw(               TXT               ) ];
use constant MIMAS_UPLOAD_VALID_FILE_EXTS_NOR_2     =>  [ qw(                    RMA  GMA GFF ) ];
use constant MIMAS_UPLOAD_VALID_FILE_EXTS           =>  [ qw( CEL  Illumina TXT  RMA  GMA GFF ) ];                  # change in JavaScript if changed here

use constant MIMAS_HTTP10_PROXY                     =>  0;                                                          # 0 = no; 1 = yes
use constant MIMAS_SESSION_EXPIRE_TIME              =>  90;                                                         # in minutes
use constant MIMAS_DATE_FORMAT                      =>  'DD-MM-YYYY';                                               # change in JavaScript if changed here
use constant MIMAS_NONE_NA_OPTION                   =>  'none/not applicable';
use constant MIMAS_SAMPLES_PER_PAGE                 =>  40;
use constant MIMAS_SESSION_LONGREADLEN              =>  100000;                                                     # in bytes
use constant MIMAS_MAX_JOB_REQUESTS                 =>  3;

use constant MIMAS_ENV_NLS_DATE_FORMAT              =>  'DD-MON-YYYY';                                              # used to be 'DD-MON-YYYY HH24:MI:SS';
use constant MIMAS_ENV_NLS_LANG                     =>  'AMERICAN_AMERICA.AL32UTF8';
use constant MIMAS_ENV_LANG                         =>  'en_US.UTF-8';

use constant MIMAS_FORM_TYPES                       =>  {
                                                          1  => {
                                                                  upload => 'date',
                                                                  search => 'date'
                                                                },
                                                          
                                                          2  => {
                                                                  upload => 'radio',
                                                                  search => 'radio'
                                                                },
                                                          
                                                          3  => {
                                                                  upload => 'select-one',
                                                                  search => 'select-multiple'
                                                                },
                                                          
                                                          4  => {
                                                                  upload => 'select-multiple',
                                                                  search => 'select-multiple'
                                                                },
                                                          
                                                          5  => {
                                                                  upload => 'text',
                                                                  search => 'text'
                                                                },
                                                          
                                                          6  => {
                                                                  upload => 'textarea',
                                                                  search => 'text'
                                                                }
                                                        };

use constant MIMAS_CHAR_SEARCH_OPERS                =>  {  
                                                          1  =>  {
                                                                   display  => 'contains',
                                                                   pattern  => '%?%'
                                                                 },
                                                          
                                                          2  =>  {
                                                                   display  => 'equals',
                                                                   pattern  => '?'
                                                                 },
                                                                
                                                          3  =>  {
                                                                   display  => 'starts with',
                                                                   pattern  => '?%'
                                                                 },
                                                               
                                                          4  =>  {
                                                                   display  => 'ends with',
                                                                   pattern  => '%?'
                                                                 },
                                                               
                                                          5  =>  {
                                                                   display  => 'does not contain',
                                                                   pattern  => '%?%',
                                                                   not      => 1
                                                                 }
                                                        };

use constant MIMAS_NUM_SEARCH_OPERS                 =>  {
                                                          1   =>  {
                                                                    display  =>  'equals',
                                                                    symbol   =>  '='
                                                                  },
                                                                  
                                                          2   =>  {
                                                                    display  =>  'less than',
                                                                    symbol   =>  '<'
                                                                  },
                                                                
                                                          3   =>  {
                                                                    display  =>  'less than or equal to',
                                                                    symbol   =>  '<='
                                                                  },
                                                                  
                                                          4   =>  {
                                                                    display  =>  'greater than',
                                                                    symbol   =>  '>'
                                                                  },
                                                                
                                                          5   =>  {
                                                                    display  =>  'greater than or equal to',
                                                                    symbol   =>  '>='
                                                                  },
                                                                  
                                                          6   =>  {
                                                                    display  =>  'does not equal',
                                                                    symbol   =>  '<>'
                                                                  }
                                                        };


#These constants are normally imported from the DBD::Oracle module, but we want to avoid that dependency
#to support MySQL installations.
use constant ORA_CLOB                               =>  112;
use constant ORA_BLOB                               =>  113;


1;

