--# analyze_mimas.sql
--# SQL Script to Analyze and Compute Statistics for MIMAS Database
--# 
--#######################################################
--# Copyright 2003-2005 Leandro C. Hermida
--# This code is part of MIMAS and is distributed under
--# GNU Public License Version 2.
--#######################################################
--# $Id$

-- Note: MIMAS database must have already been created using "create_mimas" shell script or "create_mimas_users_tables_privs.sql" + "create_mimas_consts_idxs.sql"


-- Define Variables from Command-line Parameters
DEFINE DB_SID          = &1;
DEFINE DBUSER          = &2;
DEFINE DBPASS          = &3;

CONNECT &DBUSER/&DBPASS@&DB_SID;

-- Schema names must be in all caps otherwise PL/SQL procedure fails

-- MIMAS
EXEC DBMS_UTILITY.ANALYZE_SCHEMA(schema => 'MIMAS', method => 'COMPUTE');
EXEC DBMS_UTILITY.ANALYZE_SCHEMA(schema => 'MIMAS', method => 'COMPUTE', method_opt => 'FOR ALL COLUMNS');
EXEC DBMS_STATS.GATHER_SCHEMA_STATS(ownname => 'MIMAS', cascade => TRUE);

DISCONNECT;

EXIT;
