#!/bin/sh

# create_mimas
# Master Shell Script to Create MIMAS Production Oracle Database
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$


# Variables
DB_SID="MIMAS"
DBADMIN_USER="********"
DBADMIN_PASS="********"

MIMAS_USER="mimas"
MIMAS_PASS="********"
MIMAS_WEB_USER="mimas_web"
MIMAS_WEB_PASS="********"

DUMPDIR=/export01/dump/oracle


export NLS_LANG=AMERICAN_AMERICA.AL32UTF8
export NLS_DATE_FORMAT="DD-MON-YYYY HH24:MI:SS"


{
  # Create Users
  echo
  echo
  echo "\/==================| CREATING $DB_SID USERS |==================\/"
  echo
#  $ORACLE_HOME/bin/sqlplus -L /NOLOG @create_mimas_users.sql $DB_SID $DBADMIN_USER $DBADMIN_PASS $MIMAS_PASS $MIMAS_WEB_PASS || exit
  $ORACLE_HOME/bin/sqlplus -L /NOLOG @drop_all_mimas_objects.sql $DB_SID $MIMAS_PASS $MIMAS_WEB_PASS || exit
  
  
  # Create Tables & Privileges
  echo
  echo
  echo "\/==================| CREATING $DB_SID TABLES & PRIVILEGES |==================\/"
  echo
  $ORACLE_HOME/bin/sqlplus -L /NOLOG @create_mimas_tables_privs.sql $DB_SID $MIMAS_PASS || exit
  $ORACLE_HOME/bin/sqlplus -L /NOLOG @create_mimasweb_tables_privs.sql $DB_SID $MIMAS_WEB_PASS || exit
  
  
  # Populate Database
  echo
  echo
  echo
  echo "\/==================| POPULATING $DB_SID |==================\/"
  echo
  ( cd $DUMPDIR && \
  for dump in *.ctl; do
   dumpb=`basename $dump .ctl`
   $ORACLE_HOME/bin/sqlldr userid="$MIMAS_USER/$MIMAS_PASS@$DB_SID" control=$dumpb.ctl discardmax=0 errors=0 || exit
   if [[ -e $dumpb.bad ]]; then
   cat $dumpb.log $dumpb.bad
   fi
  done
  ) || exit
  
  
  # Create Constraints & Indexes
  echo
  echo
  echo
  echo "\/==================| CREATING $DB_SID CONSTRAINTS & INDEXES |==================\/"
  echo
  $ORACLE_HOME/bin/sqlplus -L /NOLOG @create_mimas_consts_idxs.sql $DB_SID $MIMAS_PASS $MIMAS_WEB_PASS || exit
  
  
  # Analyze Database
  echo
  echo
  echo
  echo "\/==================| ANALYZING $DB_SID |==================\/"
  echo
  $ORACLE_HOME/bin/sqlplus -L /NOLOG @analyze_mimas.sql $DB_SID $MIMAS_USER $MIMAS_PASS || exit
  $ORACLE_HOME/bin/sqlplus -L /NOLOG @analyze_mimasweb.sql $DB_SID $MIMAS_WEB_USER $MIMAS_WEB_PASS || exit
  
  
  echo
  echo
  echo
  echo "$DB_SID Creation Complete"
  echo
  echo
} > $0.log

chmod 600 $0.log
echo "Output went to $0.log"
echo "Don't forget to run external_scripts/fix_sequences.pl to fix SEQUENCE values"
