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
DB_SID="localhost"
DBADMIN_USER="root"
DBADMIN_PASS="********"

MIMAS_USER="mimas"
MIMAS_PASS="********"

DUMPDIR=/local/web/mimasdump/

{
  # Create Users
  echo
  echo
  echo "\/==================| CREATING $DB_SID USERS |==================\/"
  echo
  mysql -h $DB_SID -u $MIMAS_USER -p$MIMAS_PASS -e "DROP DATABASE IF EXISTS mimas_web" || exit
  mysql -h $DB_SID -u $MIMAS_USER -p$MIMAS_PASS -e "create database mimas_web default character set 'utf8' default collate 'utf8_bin'" || exit

  mysql -h $DB_SID -u $MIMAS_USER -p$MIMAS_PASS -e "DROP DATABASE IF EXISTS mimas" || exit
  mysql -h $DB_SID -u $MIMAS_USER -p$MIMAS_PASS -e "create database mimas default character set 'utf8' default collate 'utf8_bin'" || exit
  
  
  # Create Tables & Privileges
  echo
  echo
  echo "\/==================| CREATING $DB_SID TABLES & PRIVILEGES |==================\/"
  echo
  mysql -h $DB_SID -u $MIMAS_USER -p$MIMAS_PASS mimas < create_mimas_tables_privs.my.sql || exit
  mysql -h $DB_SID -u $MIMAS_USER -p$MIMAS_PASS mimas_web < create_mimasweb_tables_privs.my.sql || exit
  
  
  # Populate Database
  echo
  echo
  echo
  echo "\/==================| POPULATING $DB_SID |==================\/"
  echo
  ( cd ${DUMPDIR?:} && \
  for dump in *.sql; do
   dumpb=`basename $dump .sql`
   echo $DUMPDIR/$dumpb.sql
   mysql -h $DB_SID -u $MIMAS_USER -p$MIMAS_PASS mimas < $dumpb.sql || exit
  done
  ) || exit
  
  
  # Create Constraints & Indexes
  echo
  echo
  echo
  echo "\/==================| CREATING $DB_SID CONSTRAINTS & INDEXES |==================\/"
  echo
  mysql -h $DB_SID -u $MIMAS_USER -p$MIMAS_PASS mimas < create_mimas_consts_idxs.my.sql || exit
  
  
  # Analyze Database
  echo
  echo
  echo
  echo "\/==================| ANALYZING $DB_SID |==================\/"
  echo
  mysqlcheck -a -h $DB_SID -u $MIMAS_USER -p$MIMAS_PASS mimas || exit
  mysqlcheck -a -h $DB_SID -u $MIMAS_USER -p$MIMAS_PASS mimas_web || exit
  
  echo
  echo
  echo
  echo "$DB_SID Creation Complete"
  echo
  echo
} > $0.log

chmod 600 $0.log
echo "Output went to $0.log"

