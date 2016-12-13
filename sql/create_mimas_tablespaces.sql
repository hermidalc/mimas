--# create_mimas_tablespaces.sql
--# Create MIMAS Production Tablespaces
--# 
--#######################################################
--# Copyright 2003-2005 Leandro C. Hermida
--# This code is part of MIMAS and is distributed under
--# GNU Public License Version 2.
--#######################################################
--# $Id$

CREATE TABLESPACE MIMAS
  LOGGING
  DATAFILE '/opt/oracle/oradata/mimas/mimas01.dbf'			SIZE 10240M	AUTOEXTEND ON NEXT 10240M MAXSIZE UNLIMITED
  EXTENT MANAGEMENT LOCAL
  SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE MIMAS_FILE_DATA
  LOGGING
  DATAFILE '/opt/oracle/oradata/mimas/mimas_file_data01.dbf'		SIZE 65535M
  EXTENT MANAGEMENT LOCAL
  SEGMENT SPACE MANAGEMENT AUTO;

--CREATE TABLESPACE MIMAS_TEMP_FILE_DATA
--  LOGGING
--  DATAFILE '/opt/oracle/oradata/mimas/mimas_temp_file_data01.dbf'	SIZE 65535M
--  EXTENT MANAGEMENT LOCAL
--  SEGMENT SPACE MANAGEMENT AUTO;

-- CREATE TABLESPACE MIMAS_FILE_DATA_IDXS
--   LOGGING
--   DATAFILE '/opt/oracle/oradata/mimas/mimas_file_data_idxs01.dbf'	SIZE 32768M	AUTOEXTEND ON NEXT 10240M MAXSIZE UNLIMITED,
--   DATAFILE '/opt/oracle/oradata/mimas/mimas_file_data_idxs02.dbf'	SIZE 32768M	AUTOEXTEND ON NEXT 10240M MAXSIZE UNLIMITED
--   EXTENT MANAGEMENT LOCAL
--   SEGMENT SPACE MANAGEMENT AUTO;


EXIT;

