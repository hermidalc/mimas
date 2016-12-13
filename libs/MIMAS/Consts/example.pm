# Consts::example.pm
# MIMAS Constants for example instance
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

use constant MIMAS_UPLOAD_DIR                       =>  '/home/mimas/uploads';
use constant MIMAS_DOWNLOAD_DIR                     =>  '/home/mimas/downloads';
use constant MIMAS_TEMP_DIR                         =>  '/home/mimas/tmp';

use constant MIMAS_SCRIPT_BASE                      =>  'http://mimas.vital-it.ch';
use constant MIMAS_ADMIN_EMAIL_ADDRESS              =>  'robin.liechti@isb-sib.ch';

use constant MIMAS_DB_ERROR_MSG                     =>  'MIMAS Database Error!  Please contact the MIMAS system administrator.';
use constant MIMAS_DB_DRIVER                        =>  'Oracle';                                                   # Must be 'Oracle' or 'mysql'
use constant MIMAS_DB_HOSTNAME                      =>  'oraserv.vital-it.ch';
use constant MIMAS_DB_SID                           =>  'MIMAS';
use constant MIMAS_DB_PORT                          =>  1521;                                                       # typically 1521 for Oracle and 3306 for MySQL
use constant MIMAS_DB_SCHEMA                        =>  'MIMAS';

use constant MIMAS_WEB_DB_USERNAME                  =>  'MIMAS_WEB';
use constant MIMAS_WEB_DB_PASSWORD                  =>  '*********';
use constant MIMAS_ADMIN_DB_USERNAME                =>  'MIMAS';
use constant MIMAS_ADMIN_DB_PASSWORD                =>  '*********';

#paths for running tab2mage expt_check.pl (optional)
use constant MIMAS_PATH_DOT                         =>  '/usr/bin/dot'; #from GraphViz package
use constant MIMAS_PATH_PERL                        =>  '/usr/bin/perl';
use constant MIMAS_PATH_TAB2MAGE                    =>  '/home/mimas/Tab2MAGE';

#path for running `zip' (optional; if not installed, Archive::Zip module will be used instead)
use constant MIMAS_PATH_ZIP                         =>  '/usr/bin/zip';


1;
