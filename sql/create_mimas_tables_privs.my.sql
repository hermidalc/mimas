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
-- Sequences don't exist in MySQL and are emulated with MyISAM tables.
-- See http://dev.mysql.com/doc/refman/5.0/en/information-functions.html for a discussion of this.


-- Library				/* because of seed db entries */
CREATE TABLE seq_attr_group (id INT NOT NULL) COLLATE=utf8_bin ENGINE=MyISAM; INSERT INTO seq_attr_group VALUES (13);
CREATE TABLE seq_attribute (id INT NOT NULL) COLLATE=utf8_bin ENGINE=MyISAM; INSERT INTO seq_attribute VALUES (220);
CREATE TABLE seq_detail_group (id INT NOT NULL) COLLATE=utf8_bin ENGINE=MyISAM; INSERT INTO seq_detail_group VALUES (9);
CREATE TABLE seq_attr_detail (id INT NOT NULL) COLLATE=utf8_bin ENGINE=MyISAM; INSERT INTO seq_attr_detail VALUES (1);
CREATE TABLE seq_technology (id INT NOT NULL) COLLATE=utf8_bin ENGINE=MyISAM; INSERT INTO seq_technology VALUES (6);
CREATE TABLE seq_array (id INT NOT NULL) COLLATE=utf8_bin ENGINE=MyISAM; INSERT INTO seq_array VALUES (69);
/* CREATE SEQUENCE seq_array_feature; */

CREATE TABLE mged_term (
  mged_name						VARCHAR(200)									NOT NULL,
  mged_type						VARCHAR(20)									NOT NULL,
  mage_name_mged					VARCHAR(200)								NOT NULL,
  mage_name						VARCHAR(200)									NOT NULL,
  deprecated						VARCHAR(200),
  description						VARCHAR(4000)
) COLLATE=utf8_bin ENGINE=InnoDB;

CREATE TABLE attr_group (
  attr_group_id						NUMERIC(10)								NOT NULL,
  name							VARCHAR(200)									NOT NULL,
  type							VARCHAR(20)									NOT NULL,
  upload_display_order					NUMERIC(3),
  view_display_order					NUMERIC(3),
  description						VARCHAR(4000)
) COLLATE=utf8_bin ENGINE=InnoDB;

CREATE TABLE attribute (
  attribute_id						NUMERIC(10)								NOT NULL,
  name							VARCHAR(200)									NOT NULL,
  is_attribute						NUMERIC(1)								NOT NULL,
  is_factor						NUMERIC(1)									NOT NULL,
  is_numeric						NUMERIC(1)								NOT NULL,
  deprecated						NUMERIC(1)		DEFAULT 0					NOT NULL,
  required						VARCHAR(20)									NOT NULL,
  other							NUMERIC(1),
  none_na						NUMERIC(1),
  search_form_type					VARCHAR(20),
  upload_form_type					VARCHAR(20),
  upload_web_page					VARCHAR(50),
  display_order						NUMERIC(3),
  description						VARCHAR(4000),
  attr_group_id						NUMERIC(10)								NOT NULL,
  factor_group_id					NUMERIC(10),
  mage_category						VARCHAR(200),
  mged_name						VARCHAR(200)
) COLLATE=utf8_bin ENGINE=InnoDB;

CREATE TABLE attr_detail_group (
  attr_detail_group_id					NUMERIC(10)							NOT NULL,
  name							VARCHAR(200)									NOT NULL,
  display_order						NUMERIC(3),
  description						VARCHAR(4000),
  attribute_id						NUMERIC(10)								NOT NULL
) COLLATE=utf8_bin ENGINE=InnoDB;

CREATE TABLE attr_detail (
  attr_detail_id					NUMERIC(10)								NOT NULL,
  name							VARCHAR(250)									NOT NULL, #must reduce size because of un_type_attr_id_name
  type							VARCHAR(20)									NOT NULL,
  deprecated						NUMERIC(1)		DEFAULT 0					NOT NULL,
  default_selection					NUMERIC(1)		DEFAULT 0					NOT NULL,
  display_order						NUMERIC(3),
  base_conv_scalar					FLOAT			DEFAULT 0,
  base_conv_factor					FLOAT			DEFAULT 1,
  description						VARCHAR(4000),
  link_id						NUMERIC(10),
  attr_detail_group_id					NUMERIC(10),
  attribute_id						NUMERIC(10)								NOT NULL,
  mage_name						VARCHAR(1000)
) COLLATE=utf8_bin ENGINE=InnoDB;

CREATE TABLE technology (
  technology_id						NUMERIC(10)								NOT NULL,
  name							VARCHAR(200)									NOT NULL,
  display_name						VARCHAR(100)								NOT NULL,
  default_manufacturer					VARCHAR(100)
) COLLATE=utf8_bin ENGINE=InnoDB;

CREATE TABLE array (
  array_id						NUMERIC(10)									NOT NULL,
  design_name						VARCHAR(100)								NOT NULL,
  display_name						VARCHAR(100)								NOT NULL,
  num_probesets						NUMERIC(10),
  num_cel_features					NUMERIC(10),
  technology_id						NUMERIC(10)								NOT NULL,
  arrayexpress_accession				VARCHAR(40),
  manufacturer						VARCHAR(100)								NOT NULL
) COLLATE=utf8_bin ENGINE=InnoDB;

-- CREATE TABLE array_feature (
--   array_feature_id					NUMERIC(30)								NOT NULL,
--   probeset_name					VARCHAR(1000)								NOT NULL,
--   x							NUMERIC(10)										NOT NULL,
--   y							NUMERIC(10)										NOT NULL,
--   cel_index						NUMERIC(10)									NOT NULL,
--   feature_pos					NUMERIC(2)								NOT NULL,
--   match_type						CHAR(2)									NOT NULL,
--   array_id						NUMERIC(10)								NOT NULL
-- ) COLLATE=utf8_bin ENGINE=InnoDB;


-- Repository
/* CREATE SEQUENCE seq_cel_feature; */

-- CREATE TABLE cel_feature (
--   cel_feature_id					NUMERIC(30)								NOT NULL,
--   x							NUMERIC(10)										NOT NULL,
--   y							NUMERIC(10)										NOT NULL,
--   index						NUMERIC(10)									NOT NULL,
--   mean_intensity					FLOAT									NOT NULL,
--   std_dev						FLOAT										NOT NULL,
--   num_pixels						NUMERIC(5)								NOT NULL,
--   masked						NUMERIC(1)									NOT NULL,
--   outlier						NUMERIC(1)									NOT NULL,
--   mod_origmean					FLOAT,
--   cel_file_id					NUMERIC(10)								NOT NULL
-- ) TABLESPACE MIMAS_FILE_DATA;


-- Users
CREATE TABLE seq_lab (id INT NOT NULL) COLLATE=utf8_bin ENGINE=MyISAM; INSERT INTO seq_lab VALUES (1);
CREATE TABLE seq_org (id INT NOT NULL) COLLATE=utf8_bin ENGINE=MyISAM; INSERT INTO seq_org VALUES (1);
CREATE TABLE seq_user (id INT NOT NULL) COLLATE=utf8_bin ENGINE=MyISAM; INSERT INTO seq_user VALUES (1);
CREATE TABLE seq_user_group (id INT NOT NULL) COLLATE=utf8_bin ENGINE=MyISAM; INSERT INTO seq_user_group VALUES (4);

CREATE TABLE title (
  title_id						NUMERIC(10)									NOT NULL,
  name							VARCHAR(50)
) COLLATE=utf8_bin ENGINE=InnoDB;

CREATE TABLE country (
  country_id						NUMERIC(10)								NOT NULL,
  name							VARCHAR(200)									NOT NULL
) COLLATE=utf8_bin ENGINE=InnoDB;

CREATE TABLE organization (
  organization_id					NUMERIC(10)								NOT NULL,
  name							VARCHAR(200)									NOT NULL,
  url							VARCHAR(1000),
  valid							NUMERIC(1)									NOT NULL,
  country_id						NUMERIC(10)								NOT NULL
) COLLATE=utf8_bin ENGINE=InnoDB;

CREATE TABLE lab (
  lab_id						NUMERIC(10)									NOT NULL,
  name							VARCHAR(200)									NOT NULL,
  address						VARCHAR(1000),
  postcode						VARCHAR(20),
  state							VARCHAR(50),
  city							VARCHAR(50),
  url							VARCHAR(1000),
  pi_name						VARCHAR(100)									NOT NULL,
  pi_email						VARCHAR(100)									NOT NULL,
  valid							NUMERIC(1)									NOT NULL,
  organization_id					NUMERIC(10)								NOT NULL
) COLLATE=utf8_bin ENGINE=InnoDB;

CREATE TABLE mimas_user (
  user_id						NUMERIC(10)									NOT NULL,
  username						VARCHAR(15)									NOT NULL,
  password						CHAR(32)									NOT NULL,
  disabled						NUMERIC(1)									NOT NULL,
  first_name						VARCHAR(50),
  middle_name						VARCHAR(50),
  last_name						VARCHAR(50),
  position						VARCHAR(100),
  email							VARCHAR(100),
  phone							VARCHAR(30),
  fax							VARCHAR(30),
  reg_date						TIMESTAMP			DEFAULT CURRENT_TIMESTAMP,
  working_data						MEDIUMTEXT,
  title_id						NUMERIC(10),
  lab_id						NUMERIC(10)									NOT NULL
) COLLATE=utf8_bin ENGINE=InnoDB;

CREATE TABLE mimas_group (
  group_id						NUMERIC(10)									NOT NULL,
  name							VARCHAR(50),
  is_default_reader					NUMERIC(1)								NOT NULL,
  is_default_writer					NUMERIC(1)								NOT NULL,
  is_system						NUMERIC(1)									NOT NULL,
  is_auto						NUMERIC(1)									NOT NULL,
  restrict_level					VARCHAR(50),
  description						VARCHAR(400)
) COLLATE=utf8_bin ENGINE=InnoDB;

CREATE TABLE user_to_group (
  user_id						NUMERIC(10)									NOT NULL,
  group_id						NUMERIC(10)								NOT NULL
) COLLATE=utf8_bin ENGINE=InnoDB;

CREATE TABLE user_to_facility (
  user_id						NUMERIC(10)									NOT NULL,
  attr_detail_id					NUMERIC(10)								NOT NULL,
  attribute_id						NUMERIC(10)		DEFAULT 4					NOT NULL
) COLLATE=utf8_bin ENGINE=InnoDB;


-- Upload
CREATE TABLE seq_up_experiment (id INT NOT NULL) COLLATE=utf8_bin ENGINE=MyISAM; INSERT INTO seq_up_experiment VALUES (1);
CREATE TABLE seq_up_exp_condition (id INT NOT NULL) COLLATE=utf8_bin ENGINE=MyISAM; INSERT INTO seq_up_exp_condition VALUES (1);
CREATE TABLE seq_up_sample (id INT NOT NULL) COLLATE=utf8_bin ENGINE=MyISAM; INSERT INTO seq_up_sample VALUES (1);
CREATE TABLE seq_up_sample_file (id INT NOT NULL) COLLATE=utf8_bin ENGINE=MyISAM; INSERT INTO seq_up_sample_file VALUES (1);
CREATE TABLE seq_up_sample_to_file (id INT NOT NULL) COLLATE=utf8_bin ENGINE=MyISAM; INSERT INTO seq_up_sample_to_file VALUES (1);
CREATE TABLE seq_up_exp_attr (id INT NOT NULL) COLLATE=utf8_bin ENGINE=MyISAM; INSERT INTO seq_up_exp_attr VALUES (1);
CREATE TABLE seq_up_sample_attr (id INT NOT NULL) COLLATE=utf8_bin ENGINE=MyISAM; INSERT INTO seq_up_sample_attr VALUES (1);

CREATE TABLE up_experiment (
  experiment_id						NUMERIC(10)								NOT NULL,
  name							VARCHAR(4000)									NOT NULL,
  num_hybrids						NUMERIC(5),
  progress						NUMERIC(2)									NOT NULL,
  state							NUMERIC(1)									NOT NULL,
  owner_id						NUMERIC(10)								NOT NULL,
  curator_id						NUMERIC(10)
) COLLATE=utf8_bin ENGINE=InnoDB;

CREATE TABLE up_exp_condition (
  condition_id						NUMERIC(10)								NOT NULL,
  name							VARCHAR(200)									NOT NULL,
  display_order						NUMERIC(5),
  experiment_id						NUMERIC(10)								NOT NULL,
  color							VARCHAR(6)
) COLLATE=utf8_bin ENGINE=InnoDB;

CREATE TABLE up_sample (
  sample_id						NUMERIC(10)								NOT NULL,
  name							VARCHAR(255)									NOT NULL,
  attrs_complete					NUMERIC(1)		DEFAULT 0,
  attrs_exist						NUMERIC(1)		DEFAULT 0,
  array_id						NUMERIC(10),
  condition_id						NUMERIC(10),
  experiment_id						NUMERIC(10)								NOT NULL
) COLLATE=utf8_bin ENGINE=InnoDB;

CREATE TABLE up_sample_file (
  sample_file_id					NUMERIC(10)								NOT NULL,
  experiment_id						NUMERIC(10)								NOT NULL,
  format						VARCHAR(10)									NOT NULL,
  upload_date						TIMESTAMP			DEFAULT CURRENT_TIMESTAMP					NOT NULL,
  hybridization_date					TIMESTAMP,
  fingerprint						CHAR(32)								NOT NULL,
  file_name						VARCHAR(255)									NOT NULL
) COLLATE=utf8_bin ENGINE=InnoDB;

CREATE TABLE up_sample_to_file (
  sample_to_file_id					NUMERIC(10)								NOT NULL,
  sample_id						NUMERIC(10)								NOT NULL,
  sample_file_id					NUMERIC(10)								NOT NULL,
  format						VARCHAR(10)									NOT NULL,
  is_germonline						NUMERIC(1)		DEFAULT 0,
  hybridization_name					VARCHAR(255)							NOT NULL
) COLLATE=utf8_bin ENGINE=InnoDB;

CREATE TABLE up_sample_file_data (
  sample_file_id					NUMERIC(10)								NOT NULL,
  chunk_number						NUMERIC(10)								NOT NULL,
  contents						LONGBLOB								NOT NULL
) COLLATE=utf8_bin ENGINE=InnoDB;

CREATE TABLE up_sample_attribute (
  sample_attribute_id					NUMERIC(10)							NOT NULL,
  char_value						MEDIUMTEXT,
  numeric_value						FLOAT,
  attr_detail_id					NUMERIC(10),
  attribute_id						NUMERIC(10)								NOT NULL,
  sample_id						NUMERIC(10)								NOT NULL
) COLLATE=utf8_bin ENGINE=InnoDB;

CREATE TABLE up_exp_attribute (
  exp_attribute_id					NUMERIC(10)								NOT NULL,
  char_value						MEDIUMTEXT,
  numeric_value						FLOAT,
  attr_detail_id					NUMERIC(10),
  attribute_id						NUMERIC(10)								NOT NULL,
  experiment_id						NUMERIC(10)								NOT NULL
) COLLATE=utf8_bin ENGINE=InnoDB;

CREATE TABLE up_exp_factor (
  experiment_id						NUMERIC(10)								NOT NULL,
  factor_id						NUMERIC(10)									NOT NULL
) COLLATE=utf8_bin ENGINE=InnoDB;

CREATE TABLE group_exp_privilege (
  group_id						NUMERIC(10)								NOT NULL,
  experiment_id						NUMERIC(10)								NOT NULL,
  can_write						NUMERIC(1)								NOT NULL
) COLLATE=utf8_bin ENGINE=InnoDB;


-- Grant Privileges
GRANT SELECT, UPDATE						ON mimas.seq_attr_group			TO mimas_web;
GRANT SELECT, UPDATE						ON mimas.seq_attribute			TO mimas_web;
GRANT SELECT, UPDATE						ON mimas.seq_detail_group		TO mimas_web;
GRANT SELECT, UPDATE						ON mimas.seq_attr_detail		TO mimas_web;
GRANT SELECT, UPDATE						ON mimas.seq_technology			TO mimas_web;
GRANT SELECT, UPDATE						ON mimas.seq_array			TO mimas_web;
/* GRANT SELECT, UPDATE						ON mimas.seq_array_feature		TO mimas_web; */
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.mged_term			TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.attr_group			TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.attribute			TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.attr_detail_group		TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.attr_detail			TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.technology			TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.array				TO mimas_web;
/* GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.array_feature			TO mimas_web; */
/* GRANT SELECT, UPDATE						ON mimas.seq_cel_feature		TO mimas_web; */
/* GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.cel_feature			TO mimas_web; */
GRANT SELECT, UPDATE						ON mimas.seq_lab			TO mimas_web;
GRANT SELECT, UPDATE						ON mimas.seq_org			TO mimas_web;
GRANT SELECT, UPDATE						ON mimas.seq_user			TO mimas_web;
GRANT SELECT, UPDATE						ON mimas.seq_user_group			TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.title				TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.country			TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.organization			TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.lab				TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES		ON mimas.mimas_user			TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.mimas_group			TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.user_to_group			TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.user_to_facility		TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.group_exp_privilege		TO mimas_web;
GRANT SELECT, UPDATE						ON mimas.seq_up_experiment		TO mimas_web;
GRANT SELECT, UPDATE						ON mimas.seq_up_exp_condition		TO mimas_web;
GRANT SELECT, UPDATE						ON mimas.seq_up_sample			TO mimas_web;
GRANT SELECT, UPDATE						ON mimas.seq_up_sample_file		TO mimas_web;
GRANT SELECT, UPDATE						ON mimas.seq_up_sample_to_file		TO mimas_web;
GRANT SELECT, UPDATE						ON mimas.seq_up_exp_attr		TO mimas_web;
GRANT SELECT, UPDATE						ON mimas.seq_up_sample_attr		TO mimas_web;
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
