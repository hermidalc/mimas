
ALTER TABLE up_sample_file DROP CONSTRAINT ck_extension;
ALTER TABLE up_sample_file DROP CONSTRAINT nn_extension_2;
ALTER TABLE up_sample_file RENAME COLUMN extension to format;
ALTER TABLE up_sample_file MODIFY format VARCHAR(10) CONSTRAINT nn_format            NOT NULL;
ALTER TABLE up_sample_file ADD CONSTRAINT ck_format    CHECK       (format IN ('DAT', 'CEL', 'Illumina', 'CHP', 'EXP', 'RPT', 'TXT', 'RMA', 'GMA'));

ALTER TABLE up_sample_file ADD
  file_name						VARCHAR2(255);
UPDATE up_sample_file f SET file_name = (SELECT s.name || '.' || f.format FROM up_sample s WHERE s.sample_id = f.sample_id);
ALTER TABLE up_sample_file MODIFY
  file_name						VARCHAR2(255)						CONSTRAINT nn_file_name			NOT NULL;

CREATE SEQUENCE seq_up_sample_to_file;
GRANT SELECT, ALTER						ON mimas.seq_up_sample_to_file		TO mimas_web;
CREATE TABLE up_sample_to_file (
  sample_to_file_id					NUMBER(10)						CONSTRAINT nn_sample_to_file_id		NOT NULL,
  sample_id                                            NUMBER(10)                                              CONSTRAINT nn_sample_id_2               NOT NULL,
  sample_file_id                                       NUMBER(10)                                              CONSTRAINT nn_sample_file_id_2          NOT NULL,
  format						VARCHAR(10)							CONSTRAINT nn_format_2		NOT NULL,
  is_germonline                                                NUMBER(1)               DEFAULT 0
);
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.up_sample_to_file		TO mimas_web;

ALTER TABLE up_sample_file
  ADD CONSTRAINT un_sample_file_id_format                          UNIQUE      (sample_file_id, format)
;

ALTER TABLE up_sample_to_file                                   
  ADD CONSTRAINT pk_sample_to_file_id				PRIMARY KEY (sample_to_file_id)
  ADD CONSTRAINT fk_sample_id_2                                 FOREIGN KEY (sample_id) REFERENCES up_sample (sample_id) ON DELETE CASCADE
  ADD CONSTRAINT fk_sample_file_id_2                            FOREIGN KEY (sample_file_id) REFERENCES up_sample_file (sample_file_id) ON DELETE CASCADE
  ADD CONSTRAINT fk_sample_file_id_3                            FOREIGN KEY (sample_file_id, format) REFERENCES up_sample_file (sample_file_id, format) ON DELETE CASCADE
  ADD CONSTRAINT un_sample_id_format                             UNIQUE      (sample_id, format)
;

CREATE INDEX ndx_sample_id_2					ON up_sample_to_file    (sample_id);
CREATE INDEX ndx_sample_file_id_2				ON up_sample_to_file    (sample_file_id);


INSERT INTO up_sample_to_file SELECT seq_up_sample_to_file.nextval, sample_id, sample_file_id, format, is_germonline FROM up_sample_file;
 

ALTER TABLE up_sample_file DROP COLUMN is_germonline;
ALTER TABLE up_sample_file DROP CONSTRAINT fk_sample_id_4;
ALTER TABLE up_sample_file DROP CONSTRAINT un_sample_id_ext;
ALTER TABLE up_sample_file RENAME COLUMN sample_id to experiment_id;

-- f.experiment_id has just been renamed from sample_id and still contains sample_ids
UPDATE up_sample_file f SET experiment_id = (SELECT max(experiment_id) FROM up_sample s WHERE f.experiment_id = s.sample_id);

ALTER TABLE up_sample_file
  ADD CONSTRAINT fk_experiment_id_6				FOREIGN KEY (experiment_id) REFERENCES up_experiment (experiment_id) ON DELETE CASCADE;
CREATE UNIQUE INDEX ndx_un_exp_id_file_name			ON up_sample_file        (experiment_id, LOWER(file_name));


INSERT INTO mimas.attr_detail (attribute_id,attr_detail_group_id,name,type,deprecated,default_selection,base_conv_scalar,base_conv_factor,link_id,description,mage_name,attr_detail_id) VALUES (6,	2,	'cell component comparison design',	'value',	0,	0,	NULL,	NULL,	NULL,	NULL,	'cell_component_comparison_design', MIMAS.SEQ_ATTR_DETAIL.NEXTVAL);
INSERT INTO mimas.attr_detail (attribute_id,attr_detail_group_id,name,type,deprecated,default_selection,base_conv_scalar,base_conv_factor,link_id,description,mage_name,attr_detail_id) VALUES ( 6,	5,	'stimulated design',	'value',	0,	0,	NULL,	NULL,	NULL,	NULL,	'stimulated_design_type', MIMAS.SEQ_ATTR_DETAIL.NEXTVAL);
INSERT INTO mimas.attr_detail (attribute_id,attr_detail_group_id,name,type,deprecated,default_selection,base_conv_scalar,base_conv_factor,link_id,description,mage_name,attr_detail_id) VALUES ( 216,	NULL,	'Rem',	'unit',	0,	0,	NULL,	NULL,	NULL,	NULL,	'Rem', MIMAS.SEQ_ATTR_DETAIL.NEXTVAL);
INSERT INTO mimas.attr_detail (attribute_id,attr_detail_group_id,name,type,deprecated,default_selection,base_conv_scalar,base_conv_factor,link_id,description,mage_name,attr_detail_id) VALUES ( 216,	NULL,	'Ci',	'unit',	0,	0,	NULL,	NULL,	NULL,	NULL,	'Ci', MIMAS.SEQ_ATTR_DETAIL.NEXTVAL);
INSERT INTO mimas.attr_detail (attribute_id,attr_detail_group_id,name,type,deprecated,default_selection,base_conv_scalar,base_conv_factor,link_id,description,mage_name,attr_detail_id) VALUES ( 216,	NULL,	'Roentgen',	'unit',	0,	0,	NULL,	NULL,	NULL,	NULL,	'R', MIMAS.SEQ_ATTR_DETAIL.NEXTVAL);
INSERT INTO mimas.attr_detail (attribute_id,attr_detail_group_id,name,type,deprecated,default_selection,base_conv_scalar,base_conv_factor,link_id,description,mage_name,attr_detail_id) VALUES ( 216,	NULL,	'dpm',	'unit',	0,	0,	NULL,	NULL,	NULL,	NULL,	'dpm', MIMAS.SEQ_ATTR_DETAIL.NEXTVAL);
INSERT INTO mimas.attr_detail (attribute_id,attr_detail_group_id,name,type,deprecated,default_selection,base_conv_scalar,base_conv_factor,link_id,description,mage_name,attr_detail_id) VALUES ( 216,	NULL,	'cpm',	'unit',	0,	0,	NULL,	NULL,	NULL,	NULL,	'cpm', MIMAS.SEQ_ATTR_DETAIL.NEXTVAL);
