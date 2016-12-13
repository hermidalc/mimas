INSERT INTO attr_detail_group VALUES(9, 'Normal', 1, null, 39);
UPDATE attr_detail SET attr_detail_group_id=9 WHERE attribute_id=39 AND name='normal';

ALTER TABLE up_sample_file DROP CONSTRAINT ck_format;
ALTER TABLE up_sample_file ADD CONSTRAINT ck_format    CHECK       (format IN ('DAT', 'CEL', 'Illumina', 'CHP', 'EXP', 'RPT', 'TXT', 'RMA', 'GMA', 'GFF'));

ALTER TABLE up_exp_condition ADD color VARCHAR(6);

update up_exp_condition c set color='FFA54F' WHERE exists(SELECT * FROM up_sample s JOIN up_sample_to_file j ON s.sample_id=j.sample_id AND j.is_germonline=1 WHERE s.condition_id=c.condition_id);

update up_exp_condition c set color='A00000' WHERE exists(SELECT * FROM up_sample s JOIN up_sample_to_file j ON s.sample_id=j.sample_id AND j.is_germonline=1 JOIN up_sample_attribute sa ON sa.sample_id=s.sample_id JOIN attr_detail d ON sa.attr_detail_id = d.attr_detail_id AND d.name in ('Sertoli cell') join attribute a on a.attribute_id=sa.attribute_id and a.name LIKE 'Cell Type%' WHERE s.condition_id=c.condition_id);
update up_exp_condition c set color='4876FF' WHERE exists(SELECT * FROM up_sample s JOIN up_sample_to_file j ON s.sample_id=j.sample_id AND j.is_germonline=1 JOIN up_sample_attribute sa ON sa.sample_id=s.sample_id JOIN attr_detail d ON sa.attr_detail_id = d.attr_detail_id AND d.name in ('spermatogonium') join attribute a on a.attribute_id=sa.attribute_id and a.name LIKE 'Cell Type%' WHERE s.condition_id=c.condition_id);
update up_exp_condition c set color='32CD32' WHERE exists(SELECT * FROM up_sample s JOIN up_sample_to_file j ON s.sample_id=j.sample_id AND j.is_germonline=1 JOIN up_sample_attribute sa ON sa.sample_id=s.sample_id JOIN attr_detail d ON sa.attr_detail_id = d.attr_detail_id AND d.name in ('testis', 'ovary', 'seminiferous tubule') join attribute a on a.attribute_id=sa.attribute_id and a.name LIKE 'Organ%' WHERE s.condition_id=c.condition_id);
update up_exp_condition c set color='32CD32' WHERE exists(SELECT * FROM up_sample s JOIN up_sample_to_file j ON s.sample_id=j.sample_id AND j.is_germonline=1 JOIN up_sample_attribute sa ON sa.sample_id=s.sample_id JOIN attr_detail d ON sa.attr_detail_id = d.attr_detail_id AND d.name in ('spermatocyte', 'spermatid') join attribute a on a.attribute_id=sa.attribute_id and a.name LIKE 'Cell Type%' WHERE s.condition_id=c.condition_id);
update up_exp_condition c set color='FF0000' WHERE exists(SELECT * FROM up_sample s JOIN up_sample_to_file j ON s.sample_id=j.sample_id AND j.is_germonline=1 JOIN up_sample_attribute sa ON sa.sample_id=s.sample_id JOIN attr_detail d ON sa.attr_detail_id = d.attr_detail_id AND d.name in ('MATalpha/alpha') join attribute a on a.attribute_id=sa.attribute_id and a.name LIKE 'Sex%' WHERE s.condition_id=c.condition_id);
update up_exp_condition c set color='FF0000' WHERE exists(SELECT * FROM up_sample s JOIN up_sample_to_file j ON s.sample_id=j.sample_id AND j.is_germonline=1 JOIN up_sample_attribute sa ON sa.sample_id=s.sample_id JOIN attr_detail d ON sa.attr_detail_id = d.attr_detail_id AND d.name in ('MATa/a') join attribute a on a.attribute_id=sa.attribute_id and a.name LIKE 'Sex%' WHERE s.condition_id=c.condition_id);
update up_exp_condition c set color='32CD32' WHERE exists(SELECT * FROM up_sample s JOIN up_sample_to_file j ON s.sample_id=j.sample_id AND j.is_germonline=1 JOIN up_sample_attribute sa ON sa.sample_id=s.sample_id AND CAST(sa.char_value AS VARCHAR2(4000)) LIKE 'SPII%' join attribute a on a.attribute_id=sa.attribute_id and a.name LIKE 'media' WHERE s.condition_id=c.condition_id);
update up_exp_condition c set color='FFDB58' WHERE exists(SELECT * FROM up_sample s JOIN up_sample_to_file j ON s.sample_id=j.sample_id AND j.is_germonline=1 JOIN up_sample_attribute sa ON sa.sample_id=s.sample_id AND CAST(sa.char_value AS VARCHAR2(4000)) LIKE 'SPIII%' join attribute a on a.attribute_id=sa.attribute_id and a.name LIKE 'media' WHERE s.condition_id=c.condition_id);
update up_exp_condition c set color='A00000' WHERE exists(SELECT * FROM up_sample s JOIN up_sample_to_file j ON s.sample_id=j.sample_id AND j.is_germonline=1 JOIN up_sample_attribute sa ON sa.sample_id=s.sample_id AND CAST(sa.char_value AS VARCHAR2(4000)) LIKE 'YPD%' join attribute a on a.attribute_id=sa.attribute_id and a.name LIKE 'media' WHERE s.condition_id=c.condition_id);
update up_exp_condition c set color='4876FF' WHERE exists(SELECT * FROM up_sample s JOIN up_sample_to_file j ON s.sample_id=j.sample_id AND j.is_germonline=1 JOIN up_sample_attribute sa ON sa.sample_id=s.sample_id AND CAST(sa.char_value AS VARCHAR2(4000)) LIKE 'YPA%' join attribute a on a.attribute_id=sa.attribute_id and a.name LIKE 'media' WHERE s.condition_id=c.condition_id);


ALTER TABLE up_sample_file
  ADD CONSTRAINT un_experiment_id_fingerprint			UNIQUE      (experiment_id, fingerprint)
;
