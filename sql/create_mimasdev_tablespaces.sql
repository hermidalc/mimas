--# create_mimasdev_tablespaces.sql
--# Create MIMAS Development Tablespaces
--# 
--#######################################################
--# Copyright 2003-2005 Leandro C. Hermida
--# This code is part of MIMAS and is distributed under
--# GNU Public License Version 2.
--#######################################################
--# $Id$

CREATE TABLESPACE MIMAS
  LOGGING
  DATAFILE '/opt/oracle/oradata/mimasdev/mimas01.dbf'			SIZE 1024M	AUTOEXTEND ON NEXT 1024M MAXSIZE UNLIMITED
  EXTENT MANAGEMENT LOCAL
  SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE MIMAS_FILE_DATA
  LOGGING
  DATAFILE '/opt/oracle/oradata/mimasdev/mimas_file_data01.dbf'		SIZE 2048M	AUTOEXTEND ON NEXT 1024M MAXSIZE UNLIMITED
  EXTENT MANAGEMENT LOCAL
  SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE MIMAS_TEMP_FILE_DATA
  LOGGING
  DATAFILE '/opt/oracle/oradata/mimasdev/mimas_temp_file_data01.dbf'	SIZE 2048M	AUTOEXTEND ON NEXT 1024M MAXSIZE UNLIMITED
  EXTENT MANAGEMENT LOCAL
  SEGMENT SPACE MANAGEMENT AUTO;

-- CREATE TABLESPACE MIMAS_FILE_DATA_IDXS
--   LOGGING
--   DATAFILE '/opt/oracle/oradata/mimasdev/mimas_file_data_idxs01.dbf'	SIZE 2048M	AUTOEXTEND ON NEXT 1024M MAXSIZE UNLIMITED
--   EXTENT MANAGEMENT LOCAL
--   SEGMENT SPACE MANAGEMENT AUTO;


EXIT;

