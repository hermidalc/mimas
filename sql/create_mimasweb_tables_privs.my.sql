--# create_mimasweb_tables_privs.sql
--# SQL Script to Create MIMAS Tables and Privileges
--# 
--#######################################################
--# Copyright 2003-2005 Leandro C. Hermida
--# This code is part of MIMAS and is distributed under
--# GNU Public License Version 2.
--#######################################################
--# $Id$

-- Note: Tablespaces must have already been created using "create_mimas_tablespaces.sql"





-- Web
CREATE TABLE seq_web (id INT NOT NULL) COLLATE=utf8_bin ENGINE=MyISAM; INSERT INTO seq_web VALUES (1);

CREATE TABLE sessions (
  id							VARCHAR(32)									NOT NULL,
  a_session						MEDIUMTEXT,
  start_time						TIMESTAMP			DEFAULT CURRENT_TIMESTAMP
) COLLATE=utf8_bin ENGINE=InnoDB;

CREATE TABLE job (
  job_id						NUMERIC(10)									NOT NULL,
  type							VARCHAR(50)									NOT NULL,
  request_time						TIMESTAMP			DEFAULT CURRENT_TIMESTAMP,
  data							MEDIUMTEXT,
  user_id						NUMERIC(10)									NOT NULL
) COLLATE=utf8_bin ENGINE=InnoDB;

CREATE TABLE alert (
  alert_id						NUMERIC(10)									NOT NULL,
  type							VARCHAR(50)									NOT NULL,
  time							TIMESTAMP			DEFAULT CURRENT_TIMESTAMP,
  data							MEDIUMTEXT,
  user_id						NUMERIC(10)									NOT NULL
) COLLATE=utf8_bin ENGINE=InnoDB;















-- Grant Privileges
GRANT SELECT, INSERT, UPDATE, DELETE				ON `mimas\_web`.*			TO mimas_web;
