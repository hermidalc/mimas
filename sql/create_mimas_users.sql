--# create_mimas_users_tables_privs.sql
--# SQL Script to Create MIMAS Users, Tables and Privileges
--# 
--#######################################################
--# Copyright 2003-2005 Leandro C. Hermida
--# This code is part of MIMAS and is distributed under
--# GNU Public License Version 2.
--#######################################################
--# $Id$

-- Note: Tablespaces must have already been created using "create_mimas_tablespaces.sql"


-- Define Variables from Command-line Parameters
DEFINE DB_SID          = &1;
DEFINE DBADMIN_USER    = &2;
DEFINE DBADMIN_PASS    = &3;

DEFINE MIMAS_PASS      = &4;
DEFINE MIMAS_WEB_PASS  = &5;
DEFINE MIMAS_READ_PASS = &6;


-- Create Oracle DB Users
CONNECT &DBADMIN_USER/&DBADMIN_PASS@&DB_SID;

CREATE USER mimas PROFILE DEFAULT
  IDENTIFIED BY "&MIMAS_PASS"
  DEFAULT TABLESPACE MIMAS
  ACCOUNT UNLOCK;
GRANT CONNECT, RESOURCE, UNLIMITED TABLESPACE TO mimas;

CREATE USER mimas_web PROFILE DEFAULT
  IDENTIFIED BY "&MIMAS_WEB_PASS"
  DEFAULT TABLESPACE MIMAS
  ACCOUNT UNLOCK;
GRANT CONNECT, RESOURCE, UNLIMITED TABLESPACE TO mimas_web;

CREATE USER mimas_read PROFILE DEFAULT
  IDENTIFIED BY "&MIMAS_READ_PASS"
  DEFAULT TABLESPACE MIMAS
  ACCOUNT UNLOCK;
GRANT CONNECT, RESOURCE TO mimas_read;

DISCONNECT;

EXIT;

