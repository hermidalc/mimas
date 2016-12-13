
GRANT SELECT, ALTER                                             ON mimas.seq_up_sample_to_file          TO mimas_web;

ALTER TABLE up_sample_to_file ADD
  hybridization_name					VARCHAR(255);

UPDATE up_sample_to_file j SET hybridization_name	 = (SELECT name FROM up_sample s WHERE s.sample_id = j.sample_id);

ALTER TABLE up_sample_to_file MODIFY
  hybridization_name					VARCHAR(255)							NOT NULL;

ALTER TABLE up_sample_to_file
  ADD CONSTRAINT un_sample_file_id_hyb_name			UNIQUE      (sample_file_id, hybridization_name)
;

