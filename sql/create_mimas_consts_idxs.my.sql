--# create_mimas_consts_idxs.sql
--# SQL Script to Create MIMAS Constraints and Indexes
--# 
--#######################################################
--# Copyright 2003-2005 Leandro C. Hermida
--# This code is part of MIMAS and is distributed under
--# GNU Public License Version 2.
--#######################################################
--# $Id$

-- Note: Tables must have already been created using "create_mimas_users_tables_privs.sql"






-- Library
ALTER TABLE mged_term
  ADD CONSTRAINT un_mage_name_mged				UNIQUE      (mage_name_mged),
  ADD CONSTRAINT ck_mged_type					CHECK       (mged_type IN ('Class'))
;

ALTER TABLE attr_group
  ADD CONSTRAINT pk_attr_group_id				PRIMARY KEY (attr_group_id), AUTO_INCREMENT 1,
  ADD CONSTRAINT un_type_name					UNIQUE      (type, name),
  ADD CONSTRAINT ck_type					CHECK       (type IN ('attribute', 'factor'))
;

ALTER TABLE attribute
  ADD CONSTRAINT pk_attribute_id				PRIMARY KEY (attribute_id), AUTO_INCREMENT 1,
  ADD CONSTRAINT fk_attr_group_id				FOREIGN KEY (attr_group_id)   REFERENCES attr_group (attr_group_id),
  ADD CONSTRAINT fk_factor_group_id				FOREIGN KEY (factor_group_id) REFERENCES attr_group (attr_group_id) ON DELETE SET NULL,
  ADD CONSTRAINT un_attr_name					UNIQUE      (is_attribute, name),
  ADD CONSTRAINT un_factor_name					UNIQUE      (is_factor, name),
  ADD CONSTRAINT ck_is_attribute				CHECK       (is_attribute     IN (0, 1)),
  ADD CONSTRAINT ck_is_factor					CHECK       (is_factor        IN (0, 1)),
  ADD CONSTRAINT ck_is_numeric					CHECK       (is_numeric       IN (0, 1)),
  ADD CONSTRAINT ck_deprecated					CHECK       (deprecated       IN (0, 1)),
  ADD CONSTRAINT ck_required					CHECK       (required         IN ('required', 'recommended', 'optional')),
  ADD CONSTRAINT ck_other					CHECK       (other            IN (0, 1)),
  ADD CONSTRAINT ck_none_na					CHECK       (none_na          IN (0, 1)),
  ADD CONSTRAINT ck_search_form_type				CHECK       (search_form_type IN ('date', 'radio', 'select-one', 'select-multiple', 'text', 'textarea')),
  ADD CONSTRAINT ck_upload_form_type				CHECK       (upload_form_type IN ('date', 'radio', 'select-one', 'select-multiple', 'text', 'textarea')),
  ADD CONSTRAINT ck_upload_web_page				CHECK       (upload_web_page  IN ('experiment information', 'sample attributes'))
;

ALTER TABLE attr_detail_group
  ADD CONSTRAINT pk_attr_detail_group_id			PRIMARY KEY (attr_detail_group_id), AUTO_INCREMENT 1,
  ADD CONSTRAINT fk_attribute_id				FOREIGN KEY (attribute_id) REFERENCES attribute (attribute_id) ON DELETE CASCADE,
  ADD CONSTRAINT un_attr_id_name				UNIQUE      (attribute_id, name)
;

ALTER TABLE attr_detail
  ADD CONSTRAINT pk_attr_detail_id				PRIMARY KEY (attr_detail_id), AUTO_INCREMENT 1,
  ADD CONSTRAINT fk_attr_detail_group_id			FOREIGN KEY (attr_detail_group_id) REFERENCES attr_detail_group (attr_detail_group_id),
  ADD CONSTRAINT fk_attribute_id_2				FOREIGN KEY (attribute_id)         REFERENCES attribute         (attribute_id)         ON DELETE CASCADE,
  ADD CONSTRAINT un_type_attr_id_name				UNIQUE      (type, attribute_id, name),
  ADD CONSTRAINT un_attribute_id_attr_detail_id			UNIQUE      (attribute_id, attr_detail_id), #for foreign key from user_to_facility
  ADD CONSTRAINT ck_type_2					CHECK       (type              IN ('value', 'unit')),
  ADD CONSTRAINT ck_deprecated_2				CHECK       (deprecated        IN (0, 1)),
  ADD CONSTRAINT ck_default_selection				CHECK       (default_selection IN (0, 1))
;

ALTER TABLE technology
  ADD CONSTRAINT pk_technology_id				PRIMARY KEY (technology_id), AUTO_INCREMENT 1,
  ADD CONSTRAINT un_name_7					UNIQUE      (name),
  ADD CONSTRAINT un_display_name_3				UNIQUE      (display_name)
;

ALTER TABLE array
  ADD CONSTRAINT pk_array_id					PRIMARY KEY (array_id), AUTO_INCREMENT 1,
  ADD CONSTRAINT fk_technology_id				FOREIGN KEY (technology_id) REFERENCES technology (technology_id) ON DELETE CASCADE,
  ADD CONSTRAINT un_design_name					UNIQUE      (design_name),
  ADD CONSTRAINT un_display_name_2				UNIQUE      (display_name)
;

-- ALTER TABLE array_feature
--   ADD CONSTRAINT pk_array_feature_id				PRIMARY KEY (array_feature_id) DISABLE NOVALIDATE AUTO_INCREMENT 1,
--   ADD CONSTRAINT fk_array_id					FOREIGN KEY (array_id) REFERENCES array (array_id) ON DELETE CASCADE,
--   ADD CONSTRAINT ck_match_type				CHECK (match_type IN ('PM', 'MM', 'QC')),
-- ;

CREATE UNIQUE INDEX ndx_un_type_name_ci				ON attr_group         (type, name);
CREATE UNIQUE INDEX ndx_un_attr_name_ci				ON attribute          (is_attribute, name);
CREATE UNIQUE INDEX ndx_un_factor_name_ci			ON attribute          (is_factor, name);
CREATE UNIQUE INDEX ndx_un_attr_id_name_ci			ON attr_detail_group  (attribute_id, name);
CREATE UNIQUE INDEX ndx_un_type_attr_id_name_ci			ON attr_detail        (type, attribute_id, name);
CREATE UNIQUE INDEX ndx_un_name_ci_6				ON technology         (name);
CREATE UNIQUE INDEX ndx_un_display_name_ci_3			ON technology         (display_name);
CREATE UNIQUE INDEX ndx_un_design_name_ci			ON array              (design_name);
CREATE UNIQUE INDEX ndx_un_display_name_ci_2			ON array              (display_name);

CREATE INDEX ndx_attr_group_id					ON attribute          (attr_group_id);
CREATE INDEX ndx_factor_group_id				ON attribute          (factor_group_id);
CREATE INDEX ndx_deprecated					ON attribute          (deprecated);
CREATE INDEX ndx_upload_web_page				ON attribute          (upload_web_page);
CREATE INDEX ndx_attribute_id					ON attr_detail_group  (attribute_id);
CREATE INDEX ndx_type						ON attr_detail        (type);
CREATE INDEX ndx_deprecated_2					ON attr_detail        (deprecated);
CREATE INDEX ndx_attr_detail_group_id				ON attr_detail        (attr_detail_group_id);
CREATE INDEX ndx_attribute_id_2					ON attr_detail        (attribute_id);
CREATE INDEX ndx_technology_id					ON array              (technology_id);
/* CREATE INDEX ndx_array_id					ON array_feature      (array_id);                                */
/* CREATE INDEX ndx_array_id_x_y				ON array_feature      (array_id, x, y);                          */
/* CREATE INDEX ndx_array_id_cel_index				ON array_feature      (array_id, cel_index);                     */
/* CREATE INDEX ndx_name_pos_type				ON array_feature      (probeset_name, feature_pos, match_type);  */


-- Users
ALTER TABLE mimas_user
  ADD CONSTRAINT pk_user_id					PRIMARY KEY (user_id), AUTO_INCREMENT 1
;


-- ALTER TABLE cel_feature
--   ADD CONSTRAINT pk_cel_feature_id				PRIMARY KEY (cel_feature_id) USING INDEX TABLESPACE MIMAS_FILE_DATA_IDXS DISABLE NOVALIDATE,
--   ADD CONSTRAINT fk_cel_file_id				FOREIGN KEY (cel_file_id)    REFERENCES cel_file (cel_file_id) ON DELETE CASCADE ENABLE NOVALIDATE,
--   ADD CONSTRAINT ck_masked					CHECK       (masked   IN (0, 1)) ENABLE NOVALIDATE,
--   ADD CONSTRAINT ck_outlier					CHECK       (outlier  IN (0, 1)) ENABLE NOVALIDATE,
-- ;

/* CREATE INDEX ndx_cel_file_id					ON cel_feature          (cel_file_id)        TABLESPACE MIMAS_FILE_DATA_IDXS;    */
/* CREATE INDEX ndx_cel_file_id_x_y				ON cel_feature          (cel_file_id, x, y)  TABLESPACE MIMAS_FILE_DATA_IDXS;    */
/* CREATE INDEX ndx_cel_file_id_index				ON cel_feature          (cel_file_id, index) TABLESPACE MIMAS_FILE_DATA_IDXS;    */


-- Users
ALTER TABLE title
  ADD CONSTRAINT pk_title_id					PRIMARY KEY (title_id), AUTO_INCREMENT 1,
  ADD CONSTRAINT un_name_2					UNIQUE      (name)
;

ALTER TABLE country
  ADD CONSTRAINT pk_country_id					PRIMARY KEY (country_id), AUTO_INCREMENT 1,
  ADD CONSTRAINT un_name_3					UNIQUE      (name)
;

ALTER TABLE organization
  ADD CONSTRAINT pk_organization_id				PRIMARY KEY (organization_id), AUTO_INCREMENT 1,
  ADD CONSTRAINT fk_country_id					FOREIGN KEY (country_id) REFERENCES country (country_id),
  ADD CONSTRAINT un_name_4					UNIQUE      (name),
  ADD CONSTRAINT ck_valid					CHECK       (valid IN (0, 1))
;

ALTER TABLE lab
  ADD CONSTRAINT pk_lab_id					PRIMARY KEY (lab_id), AUTO_INCREMENT 1,
  ADD CONSTRAINT fk_organization_id				FOREIGN KEY (organization_id) REFERENCES organization (organization_id),
  ADD CONSTRAINT un_name_5					UNIQUE      (name),
  ADD CONSTRAINT un_pi_email					UNIQUE      (pi_email),
  ADD CONSTRAINT ck_valid_2					CHECK       (valid IN (0, 1))
;

ALTER TABLE mimas_user
  ADD CONSTRAINT fk_lab_id					FOREIGN KEY (lab_id)   REFERENCES lab   (lab_id),
  ADD CONSTRAINT fk_title_id					FOREIGN KEY (title_id) REFERENCES title (title_id),
  ADD CONSTRAINT un_username					UNIQUE      (username),
  ADD CONSTRAINT un_email					UNIQUE      (email),
  ADD CONSTRAINT ck_disabled					CHECK       (disabled IN (0, 1))
;

ALTER TABLE mimas_group
  ADD CONSTRAINT pk_group_id					PRIMARY KEY (group_id), AUTO_INCREMENT 1,
  ADD CONSTRAINT un_name_6					UNIQUE      (name)
;

ALTER TABLE user_to_group
  ADD CONSTRAINT pk_user_id_group_id				PRIMARY KEY (user_id, group_id), AUTO_INCREMENT 1,
  ADD CONSTRAINT fk_user_id					FOREIGN KEY (user_id)  REFERENCES mimas_user  (user_id)   ON DELETE CASCADE,
  ADD CONSTRAINT fk_group_id					FOREIGN KEY (group_id) REFERENCES mimas_group (group_id)
;

ALTER TABLE user_to_facility
  ADD CONSTRAINT pk_user_id_attr_detail_id			PRIMARY KEY (user_id, attr_detail_id), AUTO_INCREMENT 1,
  ADD CONSTRAINT ck_attribute_id				CHECK (attribute_id = 4),
  ADD CONSTRAINT fk_user_id_3					FOREIGN KEY (user_id)  REFERENCES mimas_user  (user_id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_attribute_id_attr_detail_id			FOREIGN KEY (attribute_id, attr_detail_id)  REFERENCES attr_detail  (attribute_id, attr_detail_id)
;

CREATE UNIQUE INDEX ndx_un_name_ci_2				ON country          (name);
CREATE UNIQUE INDEX ndx_un_name_ci_3				ON organization     (name);
CREATE UNIQUE INDEX ndx_un_name_ci_4				ON lab              (name);
CREATE UNIQUE INDEX ndx_un_pi_email_ci				ON lab              (pi_email);
CREATE UNIQUE INDEX ndx_un_username_ci				ON mimas_user       (username);
CREATE UNIQUE INDEX ndx_un_email_ci				ON mimas_user       (email);
CREATE UNIQUE INDEX ndx_un_name_ci_5				ON mimas_group      (name);

CREATE INDEX ndx_valid						ON organization     (valid);
CREATE INDEX ndx_country_id					ON organization     (country_id);
CREATE INDEX ndx_valid_2					ON lab              (valid);
CREATE INDEX ndx_organization_id				ON lab              (organization_id);
CREATE INDEX ndx_disabled					ON mimas_user       (disabled);
CREATE INDEX ndx_lab_id						ON mimas_user       (lab_id);
CREATE INDEX ndx_title_id					ON mimas_user       (title_id);
CREATE INDEX ndx_user_id					ON user_to_group    (user_id);
CREATE INDEX ndx_group_id					ON user_to_group    (group_id);
CREATE INDEX ndx_user_id_3					ON user_to_facility (user_id);
CREATE INDEX ndx_attr_detail_id_4				ON user_to_facility (attr_detail_id);
CREATE INDEX ndx_group_id_3					ON group_exp_privilege (group_id);
CREATE INDEX ndx_experiment_id_5				ON group_exp_privilege (experiment_id);


-- Upload
ALTER TABLE up_experiment
  ADD CONSTRAINT pk_experiment_id				PRIMARY KEY (experiment_id), AUTO_INCREMENT 1,
  ADD CONSTRAINT fk_owner_id_2					FOREIGN KEY (owner_id)        REFERENCES mimas_user   (user_id),
  ADD CONSTRAINT fk_curator_id					FOREIGN KEY (curator_id)      REFERENCES mimas_user   (user_id),
  ADD CONSTRAINT ck_state					CHECK       (state BETWEEN 0 AND 9)
;

ALTER TABLE up_exp_condition
  ADD CONSTRAINT pk_condition_id				PRIMARY KEY (condition_id), AUTO_INCREMENT 1,
  ADD CONSTRAINT fk_experiment_id				FOREIGN KEY (experiment_id) REFERENCES up_experiment (experiment_id) ON DELETE CASCADE
;

ALTER TABLE up_sample
  ADD CONSTRAINT pk_sample_id_2					PRIMARY KEY (sample_id), AUTO_INCREMENT 1,
  ADD CONSTRAINT fk_array_id_3					FOREIGN KEY (array_id)      REFERENCES array            (array_id),
  ADD CONSTRAINT fk_condition_id				FOREIGN KEY (condition_id)  REFERENCES up_exp_condition (condition_id)  ON DELETE SET NULL,
  ADD CONSTRAINT fk_experiment_id_2				FOREIGN KEY (experiment_id) REFERENCES up_experiment    (experiment_id) ON DELETE CASCADE,
  ADD CONSTRAINT ck_attrs_complete				CHECK       (attrs_complete IN (0, 1)),
  ADD CONSTRAINT ck_attrs_exist					CHECK       (attrs_exist    IN (0, 1))
;

ALTER TABLE up_sample_file
  ADD CONSTRAINT pk_sample_file_id				PRIMARY KEY (sample_file_id), AUTO_INCREMENT 1,
  ADD CONSTRAINT fk_experiment_id_6				FOREIGN KEY (experiment_id) REFERENCES up_experiment (experiment_id) ON DELETE CASCADE,
  ADD CONSTRAINT ck_format					CHECK       (format IN ('DAT', 'CEL', 'Illumina', 'CHP', 'EXP', 'RPT', 'TXT', 'RMA', 'GMA', 'GFF')),
  ADD CONSTRAINT un_sample_file_id_format			UNIQUE      (sample_file_id, format),
  ADD CONSTRAINT un_experiment_id_fingerprint			UNIQUE      (experiment_id, fingerprint)
;

CREATE UNIQUE INDEX ndx_un_exp_id_file_name			ON up_sample_file        (experiment_id, file_name);

ALTER TABLE up_sample_to_file
  ADD CONSTRAINT pk_sample_to_file_id				PRIMARY KEY (sample_to_file_id), AUTO_INCREMENT 1,
  ADD CONSTRAINT fk_sample_id_2					FOREIGN KEY (sample_id) REFERENCES up_sample (sample_id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_sample_file_id_2				FOREIGN KEY (sample_file_id) REFERENCES up_sample_file (sample_file_id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_sample_file_id_3				FOREIGN KEY (sample_file_id, format) REFERENCES up_sample_file (sample_file_id, format) ON DELETE CASCADE,
  ADD CONSTRAINT un_sample_id_format				UNIQUE      (sample_id, format),
  ADD CONSTRAINT un_sample_file_id_hyb_name			UNIQUE      (sample_file_id, hybridization_name)
;

ALTER TABLE up_sample_file_data
  ADD CONSTRAINT fk_sample_file_id				FOREIGN KEY (sample_file_id) REFERENCES up_sample_file (sample_file_id) ON DELETE CASCADE,
  ADD CONSTRAINT un_sample_file_id				UNIQUE      (sample_file_id, chunk_number)
;

ALTER TABLE up_sample_attribute
  ADD CONSTRAINT pk_sample_attribute_id_2			PRIMARY KEY (sample_attribute_id), AUTO_INCREMENT 1,
  ADD CONSTRAINT fk_attr_detail_id_2				FOREIGN KEY (attr_detail_id) REFERENCES attr_detail (attr_detail_id),
  ADD CONSTRAINT fk_attribute_id_4				FOREIGN KEY (attribute_id)   REFERENCES attribute   (attribute_id),
  ADD CONSTRAINT fk_sample_id_5					FOREIGN KEY (sample_id)      REFERENCES up_sample   (sample_id) ON DELETE CASCADE
;

ALTER TABLE up_exp_attribute
  ADD CONSTRAINT pk_exp_attribute_id				PRIMARY KEY (exp_attribute_id), AUTO_INCREMENT 1,
  ADD CONSTRAINT fk_attr_detail_id_3				FOREIGN KEY (attr_detail_id) REFERENCES attr_detail   (attr_detail_id),
  ADD CONSTRAINT fk_attribute_id_5				FOREIGN KEY (attribute_id)   REFERENCES attribute     (attribute_id),
  ADD CONSTRAINT fk_experiment_id_3				FOREIGN KEY (experiment_id)  REFERENCES up_experiment (experiment_id) ON DELETE CASCADE
;

ALTER TABLE up_exp_factor
  ADD CONSTRAINT pk_experiment_id_factor_id			PRIMARY KEY (experiment_id, factor_id), AUTO_INCREMENT 1,
  ADD CONSTRAINT fk_experiment_id_4				FOREIGN KEY (experiment_id) REFERENCES up_experiment (experiment_id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_factor_id					FOREIGN KEY (factor_id)     REFERENCES attribute     (attribute_id)  ON DELETE CASCADE
;

ALTER TABLE group_exp_privilege
  ADD CONSTRAINT pk_group_id_experiment_id			PRIMARY KEY (group_id, experiment_id), AUTO_INCREMENT 1,
  ADD CONSTRAINT fk_group_id_3					FOREIGN KEY (group_id)  REFERENCES mimas_group (group_id)  ON DELETE CASCADE,
  ADD CONSTRAINT fk_experiment_id_5				FOREIGN KEY (experiment_id) REFERENCES up_experiment (experiment_id) ON DELETE CASCADE,
  ADD CONSTRAINT ck_can_write_3					CHECK       (can_write IN (0, 1))
;

CREATE UNIQUE INDEX ndx_un_sam_id_attr_id_det_id_2		ON up_sample_attribute  (sample_id, attribute_id, attr_detail_id);
/* CREATE UNIQUE INDEX ndx_un_sam_id_attr_id_num_2		ON up_sample_attribute  (sample_id, attribute_id, numeric_value);          */
/* CREATE UNIQUE INDEX ndx_un_sam_id_attr_id_chr_2		ON up_sample_attribute  (sample_id, attribute_id, char_value);             */
/* CREATE UNIQUE INDEX ndx_un_sam_id_attr_id_chr_ci_2		ON up_sample_attribute  (sample_id, attribute_id, char_value);      */
CREATE UNIQUE INDEX ndx_un_exp_id_attr_id_det_id		ON up_exp_attribute     (experiment_id, attribute_id, attr_detail_id);
/* CREATE UNIQUE INDEX ndx_un_exp_id_attr_id_num		ON up_exp_attribute     (experiment_id, attribute_id, numeric_value);      */
/* CREATE UNIQUE INDEX ndx_un_exp_id_attr_id_chr		ON up_exp_attribute     (experiment_id, attribute_id, char_value);         */
/* CREATE UNIQUE INDEX ndx_un_exp_id_attr_id_chr_ci		ON up_exp_attribute     (experiment_id, attribute_id, char_value);  */

CREATE INDEX ndx_owner_id_2					ON up_experiment        (owner_id);
CREATE INDEX ndx_curator_id					ON up_experiment        (curator_id);
CREATE INDEX ndx_state						ON up_experiment        (state);
CREATE INDEX ndx_experiment_id					ON up_exp_condition     (experiment_id);
CREATE INDEX ndx_array_id_3					ON up_sample            (array_id);
CREATE INDEX ndx_condition_id					ON up_sample            (condition_id);
CREATE INDEX ndx_experiment_id_2				ON up_sample            (experiment_id);
CREATE INDEX ndx_sample_id_2					ON up_sample_to_file    (sample_id);
CREATE INDEX ndx_sample_file_id_2				ON up_sample_to_file    (sample_file_id);
CREATE INDEX ndx_sample_file_id					ON up_sample_file_data  (sample_file_id);
CREATE INDEX ndx_attr_detail_id_2				ON up_sample_attribute  (attr_detail_id);
CREATE INDEX ndx_attribute_id_4					ON up_sample_attribute  (attribute_id);
CREATE INDEX ndx_sample_id_5					ON up_sample_attribute  (sample_id);
CREATE INDEX ndx_attr_detail_id_3				ON up_exp_attribute     (attr_detail_id);
CREATE INDEX ndx_attribute_id_5					ON up_exp_attribute     (attribute_id);
CREATE INDEX ndx_experiment_id_3				ON up_exp_attribute     (experiment_id);
CREATE INDEX ndx_experiment_id_4				ON up_exp_factor	(experiment_id);
CREATE INDEX ndx_factor_id					ON up_exp_factor	(factor_id);





CONNECT mimas_web;


-- Web
ALTER TABLE sessions
  ADD CONSTRAINT pk_id						PRIMARY KEY (id), AUTO_INCREMENT 1
;

ALTER TABLE job
  ADD CONSTRAINT pk_job_id					PRIMARY KEY (job_id), AUTO_INCREMENT 1,
  ADD CONSTRAINT fk_user_id					FOREIGN KEY (user_id) REFERENCES mimas.mimas_user (user_id) ON DELETE CASCADE
;

ALTER TABLE alert
  ADD CONSTRAINT pk_alert_id					PRIMARY KEY (alert_id), AUTO_INCREMENT 1,
  ADD CONSTRAINT fk_user_id_2					FOREIGN KEY (user_id) REFERENCES mimas.mimas_user (user_id) ON DELETE CASCADE
;

CREATE INDEX ndx_request_time                                   ON job    (request_time);
CREATE INDEX ndx_user_id					ON job    (user_id);
CREATE INDEX ndx_time                                           ON alert  (time);
CREATE INDEX ndx_user_id_2					ON alert  (user_id);




