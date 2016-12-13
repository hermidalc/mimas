
ALTER TABLE up_sample_file ADD COLUMN format VARCHAR(10);
UPDATE up_sample_file SET format = extension;
ALTER TABLE up_sample_file DROP INDEX un_sample_id_ext;
ALTER TABLE up_sample_file DROP COLUMN extension;
ALTER TABLE up_sample_file MODIFY format VARCHAR(10) NOT NULL;
ALTER TABLE up_sample_file ADD CONSTRAINT ck_format    CHECK       (format IN ('DAT', 'CEL', 'Illumina', 'CHP', 'EXP', 'RPT', 'TXT', 'RMA', 'GMA'));

ALTER TABLE up_sample_file ADD
  file_name						VARCHAR(255);
UPDATE up_sample_file f SET file_name = (SELECT concat(s.name, '.', f.format) FROM up_sample s WHERE s.sample_id = f.sample_id);
ALTER TABLE up_sample_file MODIFY
  file_name						VARCHAR(255)						NOT NULL;

CREATE TABLE seq_up_sample_to_file (id INT NOT NULL) ENGINE=MyISAM; INSERT INTO seq_up_sample_to_file VALUES (1);
GRANT SELECT, UPDATE						ON mimas.seq_up_sample_to_file		TO mimas_web;
CREATE TABLE up_sample_to_file (
  sample_to_file_id					NUMERIC(10)								NOT NULL,
  sample_id                                            NUMERIC(10)                                                             NOT NULL,
  sample_file_id                                       NUMERIC(10)                                                        NOT NULL,
  format						VARCHAR(10)									NOT NULL,
  is_germonline                                                NUMERIC(1)               DEFAULT 0
);
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.up_sample_to_file		TO mimas_web;

ALTER TABLE up_sample_file
  ADD CONSTRAINT un_sample_file_id_format                          UNIQUE      (sample_file_id, format)
;

ALTER TABLE up_sample_to_file                                   
  ADD CONSTRAINT pk_sample_to_file_id				PRIMARY KEY (sample_to_file_id),
  ADD CONSTRAINT fk_sample_id_2                                 FOREIGN KEY (sample_id) REFERENCES up_sample (sample_id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_sample_file_id_2                            FOREIGN KEY (sample_file_id) REFERENCES up_sample_file (sample_file_id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_sample_file_id_3                            FOREIGN KEY (sample_file_id, format) REFERENCES up_sample_file (sample_file_id, format) ON DELETE CASCADE,
  ADD CONSTRAINT un_sample_id_format                             UNIQUE      (sample_id, format)
;

CREATE INDEX ndx_sample_id_2					ON up_sample_to_file    (sample_id);
CREATE INDEX ndx_sample_file_id_2				ON up_sample_to_file    (sample_file_id);


INSERT INTO up_sample_to_file SELECT sample_file_id, sample_id, sample_file_id, format, is_germonline FROM up_sample_file;
UPDATE seq_up_sample_to_file SET id = (SELECT max(sample_to_file_id)+1 FROM up_sample_to_file);
 

ALTER TABLE up_sample_file DROP COLUMN is_germonline;
ALTER TABLE up_sample_file DROP FOREIGN KEY fk_sample_id_4;
ALTER TABLE up_sample_file CHANGE sample_id experiment_id						NUMERIC(10)								NOT NULL;

-- f.experiment_id has just been renamed from sample_id and still contains sample_ids
UPDATE up_sample_file f SET experiment_id = (SELECT max(experiment_id) FROM up_sample s WHERE f.experiment_id = s.sample_id);

ALTER TABLE up_sample_file
  ADD CONSTRAINT fk_experiment_id_6				FOREIGN KEY (experiment_id) REFERENCES up_experiment (experiment_id) ON DELETE CASCADE;
CREATE UNIQUE INDEX ndx_un_exp_id_file_name			ON up_sample_file        (experiment_id, file_name);


UPDATE seq_attr_detail SET id = (SELECT max(attr_detail_id)+1 FROM attr_detail);
INSERT INTO mimas.attr_detail (attribute_id,attr_detail_group_id,name,type,deprecated,default_selection,base_conv_scalar,base_conv_factor,link_id,description,mage_name,
attr_detail_id) SELECT 6,	2,	'cell component comparison design',	'value',	0,	0,	NULL,	NULL,	NULL,	NULL,	'cell_component_comparison_design', id FROM seq_attr_detail;
UPDATE seq_attr_detail SET id = (SELECT max(attr_detail_id)+1 FROM attr_detail);
INSERT INTO mimas.attr_detail (attribute_id,attr_detail_group_id,name,type,deprecated,default_selection,base_conv_scalar,base_conv_factor,link_id,description,mage_name,
attr_detail_id) SELECT  6,	5,	'stimulated design',	'value',	0,	0,	NULL,	NULL,	NULL,	NULL,	'stimulated_design_type', id FROM seq_attr_detail;
UPDATE seq_attr_detail SET id = (SELECT max(attr_detail_id)+1 FROM attr_detail);
INSERT INTO mimas.attr_detail (attribute_id,attr_detail_group_id,name,type,deprecated,default_selection,base_conv_scalar,base_conv_factor,link_id,description,mage_name,
attr_detail_id) SELECT  216,	NULL,	'Rem',	'unit',	0,	0,	NULL,	NULL,	NULL,	NULL,	'Rem', id FROM seq_attr_detail;
UPDATE seq_attr_detail SET id = (SELECT max(attr_detail_id)+1 FROM attr_detail);
INSERT INTO mimas.attr_detail (attribute_id,attr_detail_group_id,name,type,deprecated,default_selection,base_conv_scalar,base_conv_factor,link_id,description,mage_name,
attr_detail_id) SELECT  216,	NULL,	'Ci',	'unit',	0,	0,	NULL,	NULL,	NULL,	NULL,	'Ci', id FROM seq_attr_detail;
UPDATE seq_attr_detail SET id = (SELECT max(attr_detail_id)+1 FROM attr_detail);
INSERT INTO mimas.attr_detail (attribute_id,attr_detail_group_id,name,type,deprecated,default_selection,base_conv_scalar,base_conv_factor,link_id,description,mage_name,
attr_detail_id) SELECT  216,	NULL,	'Roentgen',	'unit',	0,	0,	NULL,	NULL,	NULL,	NULL,	'R', id FROM seq_attr_detail;
UPDATE seq_attr_detail SET id = (SELECT max(attr_detail_id)+1 FROM attr_detail);
INSERT INTO mimas.attr_detail (attribute_id,attr_detail_group_id,name,type,deprecated,default_selection,base_conv_scalar,base_conv_factor,link_id,description,mage_name,
attr_detail_id) SELECT  216,	NULL,	'dpm',	'unit',	0,	0,	NULL,	NULL,	NULL,	NULL,	'dpm', id FROM seq_attr_detail;
UPDATE seq_attr_detail SET id = (SELECT max(attr_detail_id)+1 FROM attr_detail);
INSERT INTO mimas.attr_detail (attribute_id,attr_detail_group_id,name,type,deprecated,default_selection,base_conv_scalar,base_conv_factor,link_id,description,mage_name,
attr_detail_id) SELECT  216,	NULL,	'cpm',	'unit',	0,	0,	NULL,	NULL,	NULL,	NULL,	'cpm', id FROM seq_attr_detail;
UPDATE seq_attr_detail SET id = (SELECT max(attr_detail_id)+1 FROM attr_detail);
