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

DEFINE MIMAS_PASS      = &2;

CONNECT mimas/&MIMAS_PASS@&DB_SID;


-- Library				/* because of seed db entries */
CREATE SEQUENCE seq_attr_group		START WITH 13;
CREATE SEQUENCE seq_attribute		START WITH 220;
CREATE SEQUENCE seq_detail_group	START WITH 9;
CREATE SEQUENCE seq_attr_detail;
CREATE SEQUENCE seq_technology	START WITH 6;
CREATE SEQUENCE seq_array		START WITH 69;
/* CREATE SEQUENCE seq_array_feature; */

CREATE TABLE mged_term (
  mged_name						VARCHAR2(200)						CONSTRAINT nn_mged_name			NOT NULL,
  mged_type						VARCHAR2(20)						CONSTRAINT nn_mged_type			NOT NULL,
  mage_name_mged					VARCHAR2(200)						CONSTRAINT nn_mage_name_mged		NOT NULL,
  mage_name						VARCHAR2(200)						CONSTRAINT nn_mage_name			NOT NULL,
  deprecated						VARCHAR2(200),
  description						VARCHAR2(4000)
);

CREATE TABLE attr_group (
  attr_group_id						NUMBER(10)						CONSTRAINT nn_attr_group_id		NOT NULL,
  name							VARCHAR2(200)						CONSTRAINT nn_name			NOT NULL,
  type							VARCHAR2(20)						CONSTRAINT nn_type			NOT NULL,
  upload_display_order					NUMBER(3),
  view_display_order					NUMBER(3),
  description						VARCHAR2(4000)
);

CREATE TABLE attribute (
  attribute_id						NUMBER(10)						CONSTRAINT nn_attribute_id		NOT NULL,
  name							VARCHAR2(200)						CONSTRAINT nn_name_2			NOT NULL,
  is_attribute						NUMBER(1)						CONSTRAINT nn_is_attribute		NOT NULL,
  is_factor						NUMBER(1)						CONSTRAINT nn_is_factor			NOT NULL,
  is_numeric						NUMBER(1)						CONSTRAINT nn_is_numeric		NOT NULL,
  deprecated						NUMBER(1)		DEFAULT 0			CONSTRAINT nn_deprecated		NOT NULL,
  required						VARCHAR2(20)						CONSTRAINT nn_required			NOT NULL,
  other							NUMBER(1),
  none_na						NUMBER(1),
  search_form_type					VARCHAR2(20),
  upload_form_type					VARCHAR2(20),
  upload_web_page					VARCHAR2(50),
  display_order						NUMBER(3),
  description						VARCHAR2(4000),
  attr_group_id						NUMBER(10)						CONSTRAINT nn_attr_group_id_2		NOT NULL,
  factor_group_id					NUMBER(10),
  mage_category						VARCHAR2(200),
  mged_name						VARCHAR2(200)
);

CREATE TABLE attr_detail_group (
  attr_detail_group_id					NUMBER(10)						CONSTRAINT nn_attr_detail_group_id	NOT NULL,
  name							VARCHAR2(200)						CONSTRAINT nn_name_3			NOT NULL,
  display_order						NUMBER(3),
  description						VARCHAR2(4000),
  attribute_id						NUMBER(10)						CONSTRAINT nn_attribute_id_2		NOT NULL
);

CREATE TABLE attr_detail (
  attr_detail_id					NUMBER(10)						CONSTRAINT nn_attr_detail_id		NOT NULL,
  name							VARCHAR2(1000)						CONSTRAINT nn_name_4			NOT NULL,
  type							VARCHAR2(20)						CONSTRAINT nn_type_2			NOT NULL,
  deprecated						NUMBER(1)		DEFAULT 0			CONSTRAINT nn_deprecated_2		NOT NULL,
  default_selection					NUMBER(1)		DEFAULT 0			CONSTRAINT nn_default_selection		NOT NULL,
  display_order						NUMBER(3),
  base_conv_scalar					FLOAT			DEFAULT 0,
  base_conv_factor					FLOAT			DEFAULT 1,
  description						VARCHAR2(4000),
  link_id						NUMBER(10),
  attr_detail_group_id					NUMBER(10),
  attribute_id						NUMBER(10)						CONSTRAINT nn_attribute_id_3		NOT NULL,
  mage_name						VARCHAR2(1000)
);

CREATE TABLE technology (
  technology_id						NUMBER(10)						CONSTRAINT nn_technology_id		NOT NULL,
  name							VARCHAR2(200)						CONSTRAINT nn_name_12			NOT NULL,
  display_name						VARCHAR2(100)						CONSTRAINT nn_display_name_3		NOT NULL,
  default_manufacturer					VARCHAR2(100)
);

CREATE TABLE array (
  array_id						NUMBER(10)						CONSTRAINT nn_array_id			NOT NULL,
  design_name						VARCHAR2(100)						CONSTRAINT nn_design_name		NOT NULL,
  display_name						VARCHAR2(100)						CONSTRAINT nn_display_name_2		NOT NULL,
  num_probesets						NUMBER(10),
  num_cel_features					NUMBER(10),
  technology_id						NUMBER(10)						CONSTRAINT nn_technology_id_2		NOT NULL,
  arrayexpress_accession				VARCHAR2(40),
  manufacturer						VARCHAR2(100)						CONSTRAINT nn_manufacturer_2		NOT NULL
);

-- CREATE TABLE array_feature (
--   array_feature_id					NUMBER(30)						CONSTRAINT nn_array_feature_id		NOT NULL,
--   probeset_name					VARCHAR2(1000)						CONSTRAINT nn_probeset_name		NOT NULL,
--   x							NUMBER(10)						CONSTRAINT nn_x				NOT NULL,
--   y							NUMBER(10)						CONSTRAINT nn_y				NOT NULL,
--   cel_index						NUMBER(10)						CONSTRAINT nn_cel_index			NOT NULL,
--   feature_pos					NUMBER(2)						CONSTRAINT nn_feature_pos		NOT NULL,
--   match_type						CHAR(2)							CONSTRAINT nn_match_type		NOT NULL,
--   array_id						NUMBER(10)						CONSTRAINT nn_array_id_2		NOT NULL
-- );


-- Repository
/* CREATE SEQUENCE seq_cel_feature; */

-- CREATE TABLE cel_feature (
--   cel_feature_id					NUMBER(30)						CONSTRAINT nn_cel_feature_id		NOT NULL,
--   x							NUMBER(10)						CONSTRAINT nn_x				NOT NULL,
--   y							NUMBER(10)						CONSTRAINT nn_y				NOT NULL,
--   index						NUMBER(10)						CONSTRAINT nn_index			NOT NULL,
--   mean_intensity					FLOAT							CONSTRAINT nn_mean_intensity		NOT NULL,
--   std_dev						FLOAT							CONSTRAINT nn_std_dev			NOT NULL,
--   num_pixels						NUMBER(5)						CONSTRAINT nn_num_pixels		NOT NULL,
--   masked						NUMBER(1)						CONSTRAINT nn_masked			NOT NULL,
--   outlier						NUMBER(1)						CONSTRAINT nn_outlier			NOT NULL,
--   mod_origmean					FLOAT,
--   cel_file_id					NUMBER(10)						CONSTRAINT nn_cel_file_id		NOT NULL
-- ) TABLESPACE MIMAS_FILE_DATA;


-- Users
CREATE SEQUENCE seq_lab;
CREATE SEQUENCE seq_org;
CREATE SEQUENCE seq_user;
CREATE SEQUENCE seq_user_group		START WITH 4;

CREATE TABLE title (
  title_id						NUMBER(10)						CONSTRAINT nn_title_id			NOT NULL,
  name							VARCHAR2(50)
);

CREATE TABLE country (
  country_id						NUMBER(10)						CONSTRAINT nn_country_id		NOT NULL,
  name							VARCHAR2(200)						CONSTRAINT nn_name_6			NOT NULL
);

CREATE TABLE organization (
  organization_id					NUMBER(10)						CONSTRAINT nn_organization_id		NOT NULL,
  name							VARCHAR2(200)						CONSTRAINT nn_name_7			NOT NULL,
  url							VARCHAR2(1000),
  valid							NUMBER(1)						CONSTRAINT nn_valid			NOT NULL,
  country_id						NUMBER(10)						CONSTRAINT nn_country_id_2		NOT NULL
);

CREATE TABLE lab (
  lab_id						NUMBER(10)						CONSTRAINT nn_lab_id			NOT NULL,
  name							VARCHAR2(200)						CONSTRAINT nn_name_8			NOT NULL,
  address						VARCHAR2(1000),
  postcode						VARCHAR2(20),
  state							VARCHAR2(50),
  city							VARCHAR2(50),
  url							VARCHAR2(1000),
  pi_name						VARCHAR2(100)						CONSTRAINT nn_pi_name			NOT NULL,
  pi_email						VARCHAR2(100)						CONSTRAINT nn_pi_email			NOT NULL,
  valid							NUMBER(1)						CONSTRAINT nn_valid_2			NOT NULL,
  organization_id					NUMBER(10)						CONSTRAINT nn_organization_id_2		NOT NULL
);

CREATE TABLE mimas_user (
  user_id						NUMBER(10)						CONSTRAINT nn_user_id			NOT NULL,
  username						VARCHAR2(15)						CONSTRAINT nn_username			NOT NULL,
  password						CHAR(32)						CONSTRAINT nn_password			NOT NULL,
  disabled						NUMBER(1)						CONSTRAINT nn_disabled			NOT NULL,
  first_name						VARCHAR2(50),
  middle_name						VARCHAR2(50),
  last_name						VARCHAR2(50),
  position						VARCHAR2(100),
  email							VARCHAR2(100),
  phone							VARCHAR2(30),
  fax							VARCHAR2(30),
  reg_date						DATE			DEFAULT SYSDATE,
  working_data						CLOB,
  title_id						NUMBER(10),
  lab_id						NUMBER(10)						CONSTRAINT nn_lab_id_2			NOT NULL
);

CREATE TABLE mimas_group (
  group_id						NUMBER(10)						CONSTRAINT nn_group_id			NOT NULL,
  name							VARCHAR2(50),
  is_default_reader					NUMBER(1)						CONSTRAINT nn_is_default_writer		NOT NULL,
  is_default_writer					NUMBER(1)						CONSTRAINT nn_is_default_reader		NOT NULL,
  is_system						NUMBER(1)						CONSTRAINT nn_is_system			NOT NULL,
  is_auto						NUMBER(1)						CONSTRAINT nn_is_auto			NOT NULL,
  restrict_level					VARCHAR2(50),
  description						VARCHAR2(400)
);

CREATE TABLE user_to_group (
  user_id						NUMBER(10)						CONSTRAINT nn_user_id_2			NOT NULL,
  group_id						NUMBER(10)						CONSTRAINT nn_group_id_2		NOT NULL
);

CREATE TABLE user_to_facility (
  user_id						NUMBER(10)						CONSTRAINT nn_user_id_4			NOT NULL,
  attr_detail_id					NUMBER(10)						CONSTRAINT nn_attr_detail_id_2		NOT NULL,
  attribute_id						NUMBER(10)		DEFAULT 4			CONSTRAINT nn_attribute_id_7		NOT NULL
);


-- Upload
CREATE SEQUENCE seq_up_experiment;
CREATE SEQUENCE seq_up_exp_condition;
CREATE SEQUENCE seq_up_sample;
CREATE SEQUENCE seq_up_sample_file;
CREATE SEQUENCE seq_up_sample_to_file;
CREATE SEQUENCE seq_up_exp_attr;
CREATE SEQUENCE seq_up_sample_attr;

CREATE TABLE up_experiment (
  experiment_id						NUMBER(10)						CONSTRAINT nn_experiment_id		NOT NULL,
  name							VARCHAR2(4000)						CONSTRAINT nn_name_9			NOT NULL,
  num_hybrids						NUMBER(5),
  progress						NUMBER(2)						CONSTRAINT nn_progress			NOT NULL,
  state							NUMBER(1)						CONSTRAINT nn_state			NOT NULL,
  owner_id						NUMBER(10)						CONSTRAINT nn_owner_id_2		NOT NULL,
  curator_id						NUMBER(10)
);

CREATE TABLE up_exp_condition (
  condition_id						NUMBER(10)						CONSTRAINT nn_condition_id		NOT NULL,
  name							VARCHAR2(200)						CONSTRAINT nn_name_10			NOT NULL,
  display_order						NUMBER(5),
  experiment_id						NUMBER(10)						CONSTRAINT nn_experiment_id_2		NOT NULL,
  color							VARCHAR2(6)
);

CREATE TABLE up_sample (
  sample_id						NUMBER(10)						CONSTRAINT nn_sample_id_5		NOT NULL,
  name							VARCHAR2(255)						CONSTRAINT nn_name_11			NOT NULL,
  attrs_complete					NUMBER(1)		DEFAULT 0,
  attrs_exist						NUMBER(1)		DEFAULT 0,
  array_id						NUMBER(10),
  condition_id						NUMBER(10),
  experiment_id						NUMBER(10)						CONSTRAINT nn_experiment_id_3		NOT NULL
);

CREATE TABLE up_sample_file (
  sample_file_id					NUMBER(10)						CONSTRAINT nn_sample_file_id_3		NOT NULL,
  experiment_id						NUMBER(10)						CONSTRAINT nn_experiment_id_7		NOT NULL,
  format						VARCHAR(10)						CONSTRAINT nn_format			NOT NULL,
  upload_date						DATE			DEFAULT SYSDATE			CONSTRAINT nn_upload_date_2		NOT NULL,
  hybridization_date					DATE,
  fingerprint						CHAR(32)						CONSTRAINT nn_fingerprint_3		NOT NULL,
  file_name						VARCHAR2(255)						CONSTRAINT nn_file_name			NOT NULL
);

CREATE TABLE up_sample_to_file (
  sample_to_file_id					NUMBER(10)						CONSTRAINT nn_sample_to_file_id		NOT NULL,
  sample_id						NUMBER(10)						CONSTRAINT nn_sample_id_2		NOT NULL,
  sample_file_id					NUMBER(10)						CONSTRAINT nn_sample_file_id_2		NOT NULL,
  format						VARCHAR(10)						CONSTRAINT nn_format_2			NOT NULL,
  is_germonline						NUMBER(1)		DEFAULT 0,
  hybridization_name					VARCHAR(255)						CONSTRAINT nn_hybridization_name	NOT NULL
);

CREATE TABLE up_sample_file_data (
  sample_file_id					NUMBER(10)						CONSTRAINT nn_sample_file_id		NOT NULL,
  chunk_number						NUMBER(10)						CONSTRAINT nn_chunk_number		NOT NULL,
  contents						BLOB							CONSTRAINT nn_contents_3		NOT NULL
) LOB (contents) STORE AS (
    TABLESPACE MIMAS_FILE_DATA
    DISABLE STORAGE IN ROW
    CHUNK 32768
    CACHE
  );

CREATE TABLE up_sample_attribute (
  sample_attribute_id					NUMBER(10)						CONSTRAINT nn_sample_attribute_id_2	NOT NULL,
  char_value						CLOB,
  numeric_value						FLOAT,
  attr_detail_id					NUMBER(10),
  attribute_id						NUMBER(10)						CONSTRAINT nn_attribute_id_5		NOT NULL,
  sample_id						NUMBER(10)						CONSTRAINT nn_sample_id_7		NOT NULL
);

CREATE TABLE up_exp_attribute (
  exp_attribute_id					NUMBER(10)						CONSTRAINT nn_exp_attribute_id		NOT NULL,
  char_value						CLOB,
  numeric_value						FLOAT,
  attr_detail_id					NUMBER(10),
  attribute_id						NUMBER(10)						CONSTRAINT nn_attribute_id_6		NOT NULL,
  experiment_id						NUMBER(10)						CONSTRAINT nn_experiment_id_4		NOT NULL
);

CREATE TABLE up_exp_factor (
  experiment_id						NUMBER(10)						CONSTRAINT nn_experiment_id_5		NOT NULL,
  factor_id						NUMBER(10)						CONSTRAINT nn_factor_id			NOT NULL
);

CREATE TABLE group_exp_privilege (
  group_id						NUMBER(10)						CONSTRAINT nn_group_id_4		NOT NULL,
  experiment_id						NUMBER(10)						CONSTRAINT nn_experiment_id_6		NOT NULL,
  can_write						NUMBER(1)						CONSTRAINT nn_can_write_3		NOT NULL
);


-- Grant Privileges
GRANT SELECT, ALTER						ON mimas.seq_attr_group			TO mimas_web;
GRANT SELECT, ALTER						ON mimas.seq_attribute			TO mimas_web;
GRANT SELECT, ALTER						ON mimas.seq_detail_group		TO mimas_web;
GRANT SELECT, ALTER						ON mimas.seq_attr_detail		TO mimas_web;
GRANT SELECT, ALTER						ON mimas.seq_technology			TO mimas_web;
GRANT SELECT, ALTER						ON mimas.seq_array			TO mimas_web;
/* GRANT SELECT, ALTER						ON mimas.seq_array_feature		TO mimas_web; */
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.mged_term			TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.attr_group			TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.attribute			TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.attr_detail_group		TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.attr_detail			TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.technology			TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.array				TO mimas_web;
/* GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.array_feature			TO mimas_web; */
/* GRANT SELECT, ALTER						ON mimas.seq_cel_feature		TO mimas_web; */
/* GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.cel_feature			TO mimas_web; */
GRANT SELECT, ALTER						ON mimas.seq_lab			TO mimas_web;
GRANT SELECT, ALTER						ON mimas.seq_org			TO mimas_web;
GRANT SELECT, ALTER						ON mimas.seq_user			TO mimas_web;
GRANT SELECT, ALTER						ON mimas.seq_user_group			TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.title				TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.country			TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.organization			TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.lab				TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES		ON mimas.mimas_user			TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.mimas_group			TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.user_to_group			TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.user_to_facility		TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.group_exp_privilege		TO mimas_web;
GRANT SELECT, ALTER						ON mimas.seq_up_experiment		TO mimas_web;
GRANT SELECT, ALTER						ON mimas.seq_up_exp_condition		TO mimas_web;
GRANT SELECT, ALTER						ON mimas.seq_up_sample			TO mimas_web;
GRANT SELECT, ALTER						ON mimas.seq_up_sample_file		TO mimas_web;
GRANT SELECT, ALTER						ON mimas.seq_up_sample_to_file		TO mimas_web;
GRANT SELECT, ALTER						ON mimas.seq_up_exp_attr		TO mimas_web;
GRANT SELECT, ALTER						ON mimas.seq_up_sample_attr		TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.up_experiment			TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.up_exp_condition		TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.up_sample			TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.up_sample_file			TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.up_sample_to_file		TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.up_sample_file_data		TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.up_sample_attribute		TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.up_exp_attribute		TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.up_exp_factor			TO mimas_web;

GRANT SELECT							ON mimas.mged_term			TO mimas_read;
GRANT SELECT							ON mimas.attr_group			TO mimas_read;
GRANT SELECT							ON mimas.attribute			TO mimas_read;
GRANT SELECT							ON mimas.attr_detail_group		TO mimas_read;
GRANT SELECT							ON mimas.attr_detail			TO mimas_read;
GRANT SELECT							ON mimas.technology			TO mimas_read;
GRANT SELECT							ON mimas.array				TO mimas_read;
GRANT SELECT							ON mimas.title				TO mimas_read;
GRANT SELECT							ON mimas.country			TO mimas_read;
GRANT SELECT							ON mimas.organization			TO mimas_read;
GRANT SELECT							ON mimas.lab				TO mimas_read;
/* GRANT SELECT							ON mimas.mimas_user			TO mimas_read; -- Do not allow access to password table */
GRANT SELECT							ON mimas.mimas_group			TO mimas_read;
GRANT SELECT							ON mimas.user_to_group			TO mimas_read;
GRANT SELECT							ON mimas.user_to_facility		TO mimas_read;
GRANT SELECT							ON mimas.group_exp_privilege		TO mimas_read;
GRANT SELECT							ON mimas.up_experiment			TO mimas_read;
GRANT SELECT							ON mimas.up_exp_condition		TO mimas_read;
GRANT SELECT							ON mimas.up_sample			TO mimas_read;
GRANT SELECT							ON mimas.up_sample_file			TO mimas_read;
GRANT SELECT							ON mimas.up_sample_to_file		TO mimas_read;
GRANT SELECT							ON mimas.up_sample_file_data		TO mimas_read;
GRANT SELECT							ON mimas.up_sample_attribute		TO mimas_read;
GRANT SELECT							ON mimas.up_exp_attribute		TO mimas_read;
GRANT SELECT							ON mimas.up_exp_factor			TO mimas_read;

DISCONNECT;

EXIT;

