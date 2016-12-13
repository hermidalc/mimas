--# create_mimas_tables_privs.sql
--# SQL Script to Create MIMAS Tables and Privileges
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

DEFINE MIMAS_WEB_PASS  = &2;

CONNECT mimas_web/&MIMAS_WEB_PASS@&DB_SID;


-- Web
CREATE SEQUENCE seq_web;

CREATE TABLE sessions (
  id							VARCHAR2(32)						CONSTRAINT nn_id			NOT NULL,
  a_session						CLOB,
  start_time						DATE			DEFAULT SYSDATE
);

CREATE TABLE job (
  job_id						NUMBER(10)						CONSTRAINT nn_job_id			NOT NULL,
  type							VARCHAR2(50)						CONSTRAINT nn_type			NOT NULL,
  request_time						DATE			DEFAULT SYSDATE,
  data							CLOB,
  user_id						NUMBER(10)						CONSTRAINT nn_user_id			NOT NULL
);

CREATE TABLE alert (
  alert_id						NUMBER(10)						CONSTRAINT nn_alert_id			NOT NULL,
  type							VARCHAR2(50)						CONSTRAINT nn_type_2			NOT NULL,
  time							DATE			DEFAULT SYSDATE,
  data							CLOB,
  user_id						NUMBER(10)						CONSTRAINT nn_user_id_2			NOT NULL
);


-- Create Web Session Cleanup DBMS Job
BEGIN
DBMS_JOB.ISUBMIT(
   JOB       => 99,
   WHAT      => 'DELETE FROM sessions WHERE SYSDATE - start_time > 0.5;',  /* Delete web sessions that are older than 1/2 a day */
   NEXT_DATE => SYSDATE + 1/24,
   INTERVAL  => 'SYSDATE + 1/24'                                           /* Run DBMS job every hour */
);
COMMIT;
END;
/


-- Grant Privileges
GRANT ALL PRIVILEGES						ON mimas_web.seq_web			TO mimas;
GRANT ALL PRIVILEGES						ON mimas_web.sessions			TO mimas;
GRANT ALL PRIVILEGES						ON mimas_web.job			TO mimas;
GRANT ALL PRIVILEGES						ON mimas_web.alert			TO mimas;


DISCONNECT;

EXIT;

