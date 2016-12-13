--# drop
--# SQL Script to Drop MIMAS Tables
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

DEFINE MIMAS_PASS      = &2;
DEFINE MIMAS_WEB_PASS  = &3;

CONNECT mimas/&MIMAS_PASS@&DB_SID;


DROP TABLE mged_term CASCADE CONSTRAINTS;
DROP TABLE attr_group CASCADE CONSTRAINTS;
DROP TABLE attribute CASCADE CONSTRAINTS;
DROP TABLE attr_detail_group CASCADE CONSTRAINTS;
DROP TABLE attr_detail CASCADE CONSTRAINTS;
DROP TABLE technology CASCADE CONSTRAINTS;
DROP TABLE array CASCADE CONSTRAINTS;
DROP TABLE title CASCADE CONSTRAINTS;
DROP TABLE country CASCADE CONSTRAINTS;
DROP TABLE organization CASCADE CONSTRAINTS;
DROP TABLE lab CASCADE CONSTRAINTS;
DROP TABLE mimas_user CASCADE CONSTRAINTS;
DROP TABLE mimas_group CASCADE CONSTRAINTS;
DROP TABLE user_to_group CASCADE CONSTRAINTS;
DROP TABLE user_to_facility CASCADE CONSTRAINTS;
DROP TABLE up_experiment CASCADE CONSTRAINTS;
DROP TABLE up_exp_condition CASCADE CONSTRAINTS;
DROP TABLE up_sample CASCADE CONSTRAINTS;
DROP TABLE up_sample_file CASCADE CONSTRAINTS;
DROP TABLE up_sample_file_data CASCADE CONSTRAINTS;
DROP TABLE up_sample_attribute CASCADE CONSTRAINTS;
DROP TABLE up_exp_attribute CASCADE CONSTRAINTS;
DROP TABLE up_exp_factor CASCADE CONSTRAINTS;
DROP TABLE group_exp_privilege CASCADE CONSTRAINTS;


DROP SEQUENCE seq_attr_group ;
DROP SEQUENCE seq_attribute ;
DROP SEQUENCE seq_detail_group ;
DROP SEQUENCE seq_attr_detail ;
DROP SEQUENCE seq_technology ;
DROP SEQUENCE seq_array ;
DROP SEQUENCE seq_lab ;
DROP SEQUENCE seq_org ;
DROP SEQUENCE seq_user ;
DROP SEQUENCE seq_user_group ;
DROP SEQUENCE seq_up_experiment ;
DROP SEQUENCE seq_up_exp_condition ;
DROP SEQUENCE seq_up_sample ;
DROP SEQUENCE seq_up_sample_file ;
DROP SEQUENCE seq_up_exp_attr ;
DROP SEQUENCE seq_up_sample_attr ;

CONNECT mimas_web/&MIMAS_WEB_PASS@&DB_SID;

DROP TABLE sessions CASCADE CONSTRAINTS;
DROP TABLE job CASCADE CONSTRAINTS;
DROP TABLE alert CASCADE CONSTRAINTS;

DROP SEQUENCE seq_web;

EXIT;

