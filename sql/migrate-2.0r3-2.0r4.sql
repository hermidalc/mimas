ALTER TABLE array RENAME COLUMN cdf_name TO display_name;
ALTER TABLE array DROP CONSTRAINT nn_cdf_name;

DROP INDEX ndx_un_cdf_name_ci;
ALTER TABLE array DROP CONSTRAINT un_cdf_name;
ALTER TABLE array MODIFY display_name VARCHAR2(100) CONSTRAINT nn_display_name_2            NOT NULL;
UPDATE array a SET display_name = (SELECT s.display_name FROM array_series s WHERE s.array_series_id = a.array_series_id);

ALTER TABLE array ADD manufacturer						VARCHAR2(100);
UPDATE array a SET manufacturer = (SELECT s.manufacturer FROM array_series s WHERE s.array_series_id = a.array_series_id);
ALTER TABLE array MODIFY manufacturer						VARCHAR2(100)						CONSTRAINT nn_manufacturer_2		NOT NULL;

ALTER TABLE array DROP COLUMN cdf_version;
ALTER TABLE array DROP COLUMN alt_name;

UPDATE array SET display_name='Human Genome HU35K subarray A' WHERE design_name='Hu35KsubA' AND display_name='Human Genome HU35K';
UPDATE array SET display_name='Human Genome HU35K subarray B' WHERE design_name='Hu35KsubB' AND display_name='Human Genome HU35K';
UPDATE array SET display_name='Human Genome HU35K subarray C' WHERE design_name='Hu35KsubC' AND display_name='Human Genome HU35K';
UPDATE array SET display_name='Human Genome HU35K subarray D' WHERE design_name='Hu35KsubD' AND display_name='Human Genome HU35K';
UPDATE array SET display_name='Human Genome U133 array A' WHERE design_name='HG-U133A' AND display_name='Human Genome U133';
UPDATE array SET display_name='Human Genome U133 array B' WHERE design_name='HG-U133B' AND display_name='Human Genome U133';
UPDATE array SET display_name='Human Genome U95 array A' WHERE design_name='HG_U95A' AND display_name='Human Genome U95';
UPDATE array SET display_name='Human Genome U95v2 array A' WHERE design_name='HG_U95Av2' AND display_name='Human Genome U95';
UPDATE array SET display_name='Human Genome U95 array B' WHERE design_name='HG_U95B' AND display_name='Human Genome U95';
UPDATE array SET display_name='Human Genome U95 array C' WHERE design_name='HG_U95C' AND display_name='Human Genome U95';
UPDATE array SET display_name='Human Genome U95 array D' WHERE design_name='HG_U95D' AND display_name='Human Genome U95';
UPDATE array SET display_name='Human Genome U95 array E' WHERE design_name='HG_U95E' AND display_name='Human Genome U95';
UPDATE array SET display_name='Mouse Expression 430 array A' WHERE design_name='MOE430A' AND display_name='Mouse Expression 430';
UPDATE array SET display_name='Mouse Expression 430 array B' WHERE design_name='MOE430B' AND display_name='Mouse Expression 430';
UPDATE array SET display_name='Murine Genome 11K subarray A' WHERE design_name='Mu11KsubA' AND display_name='Murine Genome 11K';
UPDATE array SET display_name='Murine Genome 11K subarray B' WHERE design_name='Mu11KsubB' AND display_name='Murine Genome 11K';
UPDATE array SET display_name='Murine Genome 19K subarray A' WHERE design_name='Mu19KsubA' AND display_name='Murine Genome 19K';
UPDATE array SET display_name='Murine Genome 19K subarray B' WHERE design_name='Mu19KsubB' AND display_name='Murine Genome 19K';
UPDATE array SET display_name='Murine Genome 19K subarray C' WHERE design_name='Mu19KsubC' AND display_name='Murine Genome 19K';
UPDATE array SET display_name='Murine Genome 6500 subarray A' WHERE design_name='Mu6500subA' AND display_name='Murine Genome 6500';
UPDATE array SET display_name='Murine Genome 6500 subarray B' WHERE design_name='Mu6500subB' AND display_name='Murine Genome 6500';
UPDATE array SET display_name='Murine Genome 6500 subarray C' WHERE design_name='Mu6500subC' AND display_name='Murine Genome 6500';
UPDATE array SET display_name='Murine Genome 6500 subarray D' WHERE design_name='Mu6500subD' AND display_name='Murine Genome 6500';
UPDATE array SET display_name='Murine Genome U74 array A' WHERE design_name='MG_U74A' AND display_name='Murine Genome U74';
UPDATE array SET display_name='Murine Genome U74 array B' WHERE design_name='MG_U74B' AND display_name='Murine Genome U74';
UPDATE array SET display_name='Murine Genome U74 array C' WHERE design_name='MG_U74C' AND display_name='Murine Genome U74';
UPDATE array SET display_name='Murine Genome U74v2 array A' WHERE design_name='MG_U74Av2' AND display_name='Murine Genome U74v2';
UPDATE array SET display_name='Murine Genome U74v2 array B' WHERE design_name='MG_U74Bv2' AND display_name='Murine Genome U74v2';
UPDATE array SET display_name='Murine Genome U74v2 array C' WHERE design_name='MG_U74Cv2' AND display_name='Murine Genome U74v2';
UPDATE array SET display_name='Rat Expression 230 array A' WHERE design_name='RAE230A' AND display_name='Rat Expression 230';
UPDATE array SET display_name='Rat Expression 230 array B' WHERE design_name='RAE230B' AND display_name='Rat Expression 230';
UPDATE array SET display_name='Rat Genome U34 array A' WHERE design_name='RG_U34A' AND display_name='Rat Genome U34';
UPDATE array SET display_name='Rat Genome U34 array B' WHERE design_name='RG_U34B' AND display_name='Rat Genome U34';
UPDATE array SET display_name='Rat Genome U34 array C' WHERE design_name='RG_U34C' AND display_name='Rat Genome U34';
UPDATE array SET display_name='Yeast 6100 subarray A' WHERE design_name='Ye6100subA' AND display_name='Yeast 6100';
UPDATE array SET display_name='Yeast 6100 subarray B' WHERE design_name='Ye6100subB' AND display_name='Yeast 6100';
UPDATE array SET display_name='Yeast 6100 subarray C' WHERE design_name='Ye6100subC' AND display_name='Yeast 6100';
UPDATE array SET display_name='Yeast 6100 subarray D' WHERE design_name='Ye6100subD' AND display_name='Yeast 6100';

ALTER TABLE array ADD CONSTRAINT un_display_name_2				UNIQUE      (display_name);
CREATE UNIQUE INDEX ndx_un_display_name_ci_2			ON array              (LOWER(display_name));

-----------------------------------------------
-----------------------------------------------
-----------------------------------------------

CREATE SEQUENCE seq_technology	START WITH 6;
CREATE TABLE technology (
  technology_id						NUMBER(10)						CONSTRAINT nn_technology_id		NOT NULL,
  name							VARCHAR2(200)						CONSTRAINT nn_name_12			NOT NULL,
  display_name						VARCHAR2(100)						CONSTRAINT nn_display_name_3		NOT NULL,
  default_manufacturer					VARCHAR2(100)
);

INSERT INTO technology(technology_id, name, display_name, default_manufacturer) VALUES (1, 'GeneChip', 'Affymetrix GeneChip', 'Affymetrix');
INSERT INTO technology(technology_id, name, display_name, default_manufacturer) VALUES (2, 'ChIP-chip', 'ChIP-chip', 'Affymetrix');
INSERT INTO technology(technology_id, name, display_name, default_manufacturer) VALUES (3, 'Tiling', 'Tiling array', 'Affymetrix');
INSERT INTO technology(technology_id, name, display_name, default_manufacturer) VALUES (4, 'BeadArray', 'Illumina BeadArray', 'Illumina');
INSERT INTO technology(technology_id, name, display_name, default_manufacturer) VALUES (5, 'Sequencing', 'Illumina Genome Analyzer', 'Illumina');



GRANT SELECT, ALTER						ON mimas.seq_technology			TO mimas_web;
GRANT SELECT, INSERT, UPDATE, DELETE				ON mimas.technology			TO mimas_web;

-------------------------------------------------
-------------------------------------------------
-------------------------------------------------
-------------------------------------------------

ALTER TABLE array DROP CONSTRAINT fk_array_series_id;
DROP INDEX ndx_array_series_id;

UPDATE array a
SET array_series_id = 
(SELECT t.technology_id
FROM array_series s
JOIN technology t ON s.type=t.name
WHERE s.array_series_id=a.array_series_id
);

ALTER TABLE array RENAME COLUMN array_series_id TO technology_id;
ALTER TABLE array DROP CONSTRAINT nn_array_series_id_2;
ALTER TABLE array MODIFY technology_id NUMBER(10)						CONSTRAINT nn_technology_id_2		NOT NULL;


UPDATE attribute SET name = 'Technology', description = 'Platform technology.'  WHERE attribute_id=12;

ALTER TABLE technology
  ADD CONSTRAINT pk_technology_id				PRIMARY KEY (technology_id)
  ADD CONSTRAINT un_name_7					UNIQUE      (name)
  ADD CONSTRAINT un_display_name_3				UNIQUE      (display_name);

ALTER TABLE array ADD CONSTRAINT fk_technology_id				FOREIGN KEY (technology_id) REFERENCES technology (technology_id) ON DELETE CASCADE;

CREATE UNIQUE INDEX ndx_un_name_ci_6				ON technology         (LOWER(name));
CREATE UNIQUE INDEX ndx_un_display_name_ci_3			ON technology         (LOWER(display_name));
CREATE INDEX ndx_technology_id					ON array              (technology_id);

-------------------------------------------------
-------------------------------------------------
-------------------------------------------------
-------------------------------------------------

ALTER TABLE up_sample DROP COLUMN num_replicates;

-------------------------------------------------
-------------------------------------------------
-------------------------------------------------
-------------------------------------------------

UPDATE attribute SET display_order=display_order+1 WHERE attr_group_id=6 AND display_order>=12;

INSERT INTO attribute( attribute_id, name, is_attribute, is_factor, is_numeric, required, other, none_na, search_form_type,
    upload_form_type, upload_web_page, display_order, attr_group_id, factor_group_id, mage_category, mged_name, description)
VALUES ( 79, 'Dye', 1, 0, 0, 'required', 1, 1, 'select-multiple', 'select-one', 'sample attributes', 12, 6,
NULL, 'labeling', NULL, 'The name of the dye used in labeling the extract.'); 

INSERT INTO attr_detail ( 
    attribute_id, attr_detail_group_id, name, type, deprecated, default_selection,
    base_conv_scalar, base_conv_factor, link_id, description, mage_name, attr_detail_id)
VALUES (79, NULL, 'biotin', 'value', 0, 1, NULL, NULL, NULL, NULL, NULL, MIMAS.SEQ_ATTR_DETAIL.NEXTVAL);

INSERT INTO up_sample_attribute (SAMPLE_ATTRIBUTE_ID, CHAR_VALUE, NUMERIC_VALUE, ATTR_DETAIL_ID, ATTRIBUTE_ID, SAMPLE_ID)
SELECT seq_up_sample_attr.nextval, null, null, ad.attr_detail_id, ad.attribute_id, s.sample_id
FROM attr_detail ad, up_sample s
WHERE ad.attribute_id = 79 AND ad.name = 'biotin' AND s.attrs_exist=1;
