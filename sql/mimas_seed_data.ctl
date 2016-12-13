--# mimas_seed_data.ctl
--# MIMAS Seed Database SQL*Loader Control File
--# 
--#######################################################
--# Copyright 2003-2005 Leandro C. Hermida
--# This code is part of MIMAS and is distributed under
--# GNU Public License Version 2.
--#######################################################
--# $Id$

LOAD DATA
  INFILE *
  BADFILE       mimas_seed_data.bad
  DISCARDFILE   mimas_seed_data.dis
  REPLACE 
INTO TABLE mimas.attr_group
  WHEN table_id = '1'
  FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY "!"
  (
    table_id				FILLER POSITION(1) INTEGER EXTERNAL,
    attr_group_id			INTEGER EXTERNAL,
    name				CHAR,
    type				CHAR,
    upload_display_order		INTEGER EXTERNAL		NULLIF upload_display_order='NULL',
    view_display_order			INTEGER EXTERNAL		NULLIF view_display_order='NULL',
    description				CHAR(4000)			NULLIF description='NULL'
  )
INTO TABLE mimas.attribute
  WHEN table_id = '2'
  FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY "!"
  (
    table_id				FILLER POSITION(1) INTEGER EXTERNAL,
    attribute_id			INTEGER EXTERNAL,
    name				CHAR,
    is_attribute			INTEGER EXTERNAL,
    is_factor				INTEGER EXTERNAL,
    is_numeric				INTEGER EXTERNAL,
    required				CHAR,
    other				INTEGER EXTERNAL		NULLIF other='NULL',
    none_na				INTEGER EXTERNAL		NULLIF none_na='NULL',
    search_form_type			CHAR				NULLIF search_form_type='NULL',
    upload_form_type			CHAR				NULLIF upload_form_type='NULL',
    upload_web_page			CHAR				NULLIF upload_web_page='NULL',
    display_order			INTEGER EXTERNAL		NULLIF display_order='NULL',
    attr_group_id			INTEGER EXTERNAL		NULLIF attr_group_id='NULL',
    factor_group_id			INTEGER EXTERNAL		NULLIF factor_group_id='NULL',
    mage_category			CHAR				NULLIF mage_category='NULL',
    mged_name				CHAR				NULLIF mged_name='NULL',
    description				CHAR(4000)			NULLIF description='NULL'
  )
INTO TABLE mimas.attr_detail_group
  WHEN table_id = '3'
  FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY "!"
  TRAILING NULLCOLS
  (
    table_id				FILLER POSITION(1) INTEGER EXTERNAL,
    attr_detail_group_id		INTEGER EXTERNAL,
    attribute_id			INTEGER EXTERNAL,
    name				CHAR,
    display_order			INTEGER EXTERNAL		NULLIF display_order='NULL',
    description				CHAR(4000)			NULLIF description='NULL'
  )
INTO TABLE mimas.attr_detail
  WHEN table_id = '4'
  FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY "!"
  TRAILING NULLCOLS
  (
    table_id				FILLER POSITION(1) INTEGER EXTERNAL,
    attribute_id			INTEGER EXTERNAL,
    attr_detail_group_id		INTEGER EXTERNAL		NULLIF attr_detail_group_id='NULL',
    name				CHAR,
    type				CHAR,
    deprecated				INTEGER EXTERNAL,
    default_selection                   INTEGER EXTERNAL                NULLIF default_selection='NULL',
    base_conv_scalar			FLOAT EXTERNAL			NULLIF base_conv_scalar='NULL',
    base_conv_factor			FLOAT EXTERNAL			NULLIF base_conv_factor='NULL',
    link_id				INTEGER EXTERNAL		NULLIF link_id='NULL',
    description				CHAR(4000)			NULLIF description='NULL',
    mage_name				CHAR(4000)			NULLIF mage_name='NULL',
    attr_detail_id			"MIMAS.SEQ_ATTR_DETAIL.NEXTVAL"
  )
INTO TABLE mimas.technology
  WHEN table_id = '5'
  FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY "!"
  (
    table_id				FILLER POSITION(1) INTEGER EXTERNAL,
    technology_id			INTEGER EXTERNAL,
    name				CHAR,
    display_name			CHAR,
    default_manufacturer		CHAR
  )
INTO TABLE mimas.title
  WHEN table_id = '7'
  FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY "!"
  (
    table_id				FILLER POSITION(1) INTEGER EXTERNAL,
    title_id				INTEGER EXTERNAL,
    name				CHAR
  )
INTO TABLE mimas.country
  WHEN table_id = '8'
  FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY "!"
  (
    table_id				FILLER POSITION(1) INTEGER EXTERNAL,
    country_id				INTEGER EXTERNAL,
    name				CHAR
  )
INTO TABLE mimas.mimas_group
  WHEN table_id = '9'
  FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY "!"
  (
    table_id				FILLER POSITION(1) INTEGER EXTERNAL,
    group_id				INTEGER EXTERNAL,
    name				CHAR,
    is_default_reader			INTEGER EXTERNAL,
    is_default_writer			INTEGER EXTERNAL,
    is_system				INTEGER EXTERNAL,
    is_auto				INTEGER EXTERNAL,
    restrict_level			CHAR,
    description				CHAR
  )
BEGINDATA
1,	1,	!Organizational Information and Contacts!,		!attribute!,		1,	2,		!NULL!
1,	2,	!Experiment Infomation!,				!attribute!,		2,	1,		!NULL!
1,	3,	!Microarray Technology and Quality Control!,		!attribute!,		3,	3,		!NULL!
1,	4,	!Sample Information!,					!attribute!,		4,	4,		!NULL!
1,	5,	!Biomaterial Characteristics!,				!attribute!,		5,	5,		!NULL!
1,	6,	!Hybridization Protocol!,				!attribute!,		6,	6,		!NULL!
1,	7,	!Image Analysis and Data Processing!,			!attribute!,		7,	7,		!NULL!
1,	8,	!Experimental Factor Details!,				!attribute!,		8,	8,		!NULL!
1,	12,	!Cross-references!,					!attribute!,		9,	9,		!NULL!
1,	9,	!Biological Property!,					!factor!,		1,	1,		!NULL!
1,	10,	!Environmental Factor!,					!factor!,		2,	2,		!NULL!
1,	11,	!Methodological Factor!,				!factor!,		3,	3,		!NULL!
2,	1,	!Author(s)!,						1,	0,	0,	!required!,	0,	0,	!text!,			!text!,			!experiment information!,	1,		1,		!NULL!,	!NULL!,				!NULL!,					!Person(s) conducting microarray experiment.!
2,	2,	!Laboratory/Group Name!,				1,	0,	0,	!required!,	1,	0,	!select-multiple!,	!select-one!,		!experiment information!,	2,		1,		!NULL!,	!NULL!,				!NULL!,					!Primary laboratory of person(s) conducting microarray experiment.!
2,	3,	!Organization!,						1,	0,	0,	!required!,	1,	0,	!select-multiple!,	!select-one!,		!experiment information!,	3,		1,		!NULL!,	!NULL!,				!NULL!,					!Institute or organization where laboratory resides.!
2,	4,	!Microarray Facility!,					1,	0,	0,	!required!,	1,	0,	!select-multiple!,	!select-one!,		!experiment information!,	4,		1,		!NULL!,	!NULL!,				!NULL!,					!Facility in charge of microarray services.!
2,	5,	!Additional Contact Information!,			1,	0,	0,	!optional!,	0,	0,	!text!,			!textarea!,		!experiment information!,	5,		1,		!NULL!,	!NULL!,				!NULL!,					!Additional contact details of person(s) conducting microarray and/or related experiment(s).!
2,	6,	!Experiment Design Type!,				1,	0,	0,	!required!,	0,	0,	!select-multiple!,	!select-one!,		!experiment information!,	4,		2,		!NULL!,	!NULL!,				!NULL!,					!High-level classification of type of experiment being performed.!
2,	7,	!Experimental Factors!,					1,	0,	0,	!required!,	1,	0,	!select-multiple!,	!select-multiple!,	!experiment information!,	6,		2,		!NULL!,	!NULL!,				!NULL!,					!The factors in the study that are experimental parameters or regarded as influencing the experimental results.!
2,	8,	!Number of Hybridizations!,				1,	0,	1,	!required!,	0,	0,	!text!,			!text!,			!NULL!,				7,		2,		!NULL!,	!NULL!,				!NULL!,					!Number of hybridizations performed in the experiment.!
2,	9,	!Reference Experimental Condition!,			1,	0,	0,	!required!,	0,	1,	!text!,			!select-one!,		!experiment information!,	8,		2,		!NULL!,	!NULL!,				!NULL!,					!If exists, the name of the reference experimental condition to which all other experimental conditions are compared.!
2,	10,	!Experimental Goals/Description!,			1,	0,	0,	!required!,	0,	0,	!text!,			!textarea!,		!experiment information!,	9,		2,		!NULL!,	!NULL!,				!NULL!,					!Detailed description of experiment and relevant goals.!
2,	11,	!Relevant Publication/Reference!,			1,	0,	0,	!optional!,	0,	0,	!text!,			!textarea!,		!experiment information!,	10,		2,		!NULL!,	!NULL!,				!NULL!,					!Relevant publications associated with experiment.!
2,	12,	!Technology!,						1,	0,	0,	!required!,	0,	0,	!select-multiple!,	!select-one!,		!NULL!,				1,		3,		!NULL!,	!NULL!,				!NULL!,					!Platform technology.!
2,	15,	!Replicate Type!,					1,	0,	0,	!required!,	0,	0,	!select-multiple!,	!select-one!,		!experiment information!,	6,		3,		!NULL!,	!NULL!,				!NULL!,					!Experimental stage at which replication was performed.!
2,	16,	!Replicate Comments/Notes!,				1,	0,	0,	!optional!,	0,	0,	!text!,			!textarea!,		!experiment information!,	7,		3,		!NULL!,	!NULL!,				!NULL!,					!Details about the type of replication used in the experiment.!
2,	17,	!Array Design Name!,					1,	0,	0,	!required!,	0,	0,	!select-multiple!,	!select-one!,		!NULL!,				2,		3,		!NULL!,	!NULL!,				!NULL!,					!Manufacturer given unique array name.!
2,	18,	!Number of Replicates!,					1,	0,	1,	!required!,	0,	0,	!text!,			!text!,			!NULL!,				5,		3,		!NULL!,	!NULL!,				!NULL!,					!Number of replicates performed for this sample.!
2,	19,	!Organism!,						1,	1,	0,	!required!,	1,	0,	!select-multiple!,	!select-one!,		!sample attributes!,		1,		5,		9,	!BioMaterialCharacteristics!,	!Organism!,				!The genus and species (and subspecies) of the organism that the biomaterial is derived from.!
2,	20,	!Organism Status!,					1,	1,	0,	!required!,	0,	0,	!select-multiple!,	!select-one!,		!sample attributes!,		2,		5,		9,	!BioMaterialCharacteristics!,	!OrganismStatus!,			!The stage, premortem or postmortem, at which the sample was processed for extraction of biomaterial.!
2,	21,	!Individual Organism or Pool Identifier!,		1,	1,	0,	!optional!,	0,	0,	!text!,			!text!,			!sample attributes!,		3,		5,		9,	!BioMaterialCharacteristics!,	!Individual!,				!Identifier or name of the individual organism or the pool of organisms that the biomaterial is derived from. Use the same name in different samples when they are from the same organism or pool.!
2,	22,	!Sex/Mating Type!,					1,	1,	0,	!required!,	1,	1,	!select-multiple!,	!select-one!,		!sample attributes!,		4,		5,		9,	!BioMaterialCharacteristics!,	!Sex!,					!Term applied to any organism able to undergo sexual reproduction in order to differentiate the individuals or types involved. Sexual reproduction is defined as the ability to exchange genetic material with the potential of recombinant progeny.!
2,	23,	!Age Determination/Type!,				1,	0,	0,	!required!,	0,	1,	!select-multiple!,	!select-one!,		!sample attributes!,		5,		5,		!NULL!,	!NULL!,				!NULL!,					!Whether age can be determined for the organism(s) that the biomaterial is derived from and if so, whether age is a single value or a range or values.!
2,	24,	!Organism Age!,						1,	1,	1,	!recommended!,	0,	0,	!text!,			!text!,			!sample attributes!,		7,		5,		9,	!BioMaterialCharacteristics!,	!Age!,					!The time period elapsed since an identifiable point in the life cycle of an organism. If a developmental stage is specified, the identifiable point would be the beginning of that stage. Otherwise the identifiable point must be specified.!
2,	25,	!Min Organism Age!,					1,	1,	1,	!optional!,	0,	0,	!text!,			!text!,			!sample attributes!,		8,		5,		9,	!BioMaterialCharacteristics!,	!Age!,					!The minimum time period elapsed since an identifiable point in the life cycle of an organism. If a developmental stage is specified, the identifiable point would be the beginning of that stage. Otherwise the identifiable point must be specified.!
2,	26,	!Max Organism Age!,					1,	1,	1,	!optional!,	0,	0,	!text!,			!text!,			!sample attributes!,		9,		5,		9,	!BioMaterialCharacteristics!,	!Age!,					!The maximum time period elapsed since an identifiable point in the life cycle of an organism. If a developmental stage is specified, the identifiable point would be the beginning of that stage. Otherwise the identifiable point must be specified.!
2,	27,	!Age Initial Time Point!,				1,	0,	0,	!recommended!,	1,	0,	!select-multiple!,	!select-one!,		!sample attributes!,		10,		5,		!NULL!,	!BioMaterialCharacteristics!,	!InitialTimePoint!,			!The identifiable point in the life cycle of an organism from which age measurements were taken.!
2,	28,	!Organism Developmental Stage!,				1,	1,	0,	!required!,	1,	1,	!select-multiple!,	!select-one!,		!sample attributes!,		11,		5,		9,	!BioMaterialCharacteristics!,	!DevelopmentalStage!,			!The developmental stage of the organism's life cycle during which the biomaterial was extracted.!
2,	29,	!Organ/Organism Part!,					1,	1,	0,	!required!,	1,	1,	!select-multiple!,	!select-multiple!,	!sample attributes!,		12,		5,		9,	!BioMaterialCharacteristics!,	!OrganismPart!,				!The part of organism's anatomy or substance arising from an organism from which the biomaterial was derived - excludes cells.!
2,	30,	!Sample Source Type!,					1,	1,	0,	!required!,	1,	0,	!select-multiple!,	!select-one!,		!sample attributes!,		13,		5,		11,	!BioMaterialCharacteristics!,	!BioSourceType!,			!The original form in which the biomaterial was obtained/maintained.!
2,	31,	!Sample Source Provider!,				1,	1,	0,	!recommended!,	0,	0,	!text!,			!textarea!,		!sample attributes!,		14,		5,		11,	!BioMaterialCharacteristics!,	!BioSourceProvider!,			!The contact details of the resource (e.g. person, company, hospital, geographical location) used to obtain or purchase the biomaterial.!
2,	32,	!Biometrics!,						1,	0,	0,	!recommended!,	0,	0,	!text!,			!textarea!,		!sample attributes!,		15,		5,		!NULL!,	!BioMaterialCharacteristics!,	!Biometrics!,				!Important physical properties of the biomaterial, e.g. mass or height.!
2,	33,	!Macroscopic Observations!,				1,	0,	0,	!recommended!,	0,	0,	!text!,			!textarea!,		!sample attributes!,		16,		5,		!NULL!,	!BioMaterialCharacteristics!,	!NULL!,					!Details of the macroscopic examination of the biomaterial.!
2,	34,	!Histology!,						1,	1,	0,	!recommended!,	0,	0,	!text!,			!textarea!,		!sample attributes!,		17,		5,		!NULL!,	!BioMaterialCharacteristics!,	!Histology!,				!Details of the microscopic morphology of the tissues that the biomaterial is derived from.!
2,	35,	!Cell/Tissue Separation Technique!,			1,	1,	0,	!required!,	1,	1,	!select-multiple!,	!select-multiple!,	!sample attributes!,		18,		5,		11,	!treatment!,			!NULL!,					!General technique used to separate tissues or cells from a heterogeneous sample.!
2,	36,	!Cell Type/Targeted Cell Type!,				1,	1,	0,	!required!,	1,	1,	!select-multiple!,	!select-multiple!,	!sample attributes!,		19,		5,		9,	!BioMaterialCharacteristics!,	!CellType!,				!The type of cell used in the experiment if non mixed, if mixed then the targeted cell type. The target cell type is the cell of primary interest. The biomaterial may be derived from a mixed population of cells although only one cell type is of interest.!
2,	37,	!Strain/Line/Cultivar!,					1,	1,	0,	!required!,	1,	1,	!select-multiple!,	!select-one!,		!sample attributes!,		20,		5,		9,	!BioMaterialCharacteristics!,	!StrainOrLine!,				!For animals or plants, these are offspring that have a single ancestral breeding pair or parent as a result of brother x sister or parent x offspring matings. For microbes, these are isolates derived from nature or in the laboratory.!
2,	38,	!Cell Line!,						1,	1,	0,	!recommended!,	1,	0,	!select-multiple!,	!select-one!,		!sample attributes!,		21,		5,		9,	!BioMaterialCharacteristics!,	!CellLine!,				!The identifier for the established culture of a metazoan cell if one was used as a biomaterial.!
2,	39,	!Disease State!,					1,	1,	0,	!required!,	1,	0,	!select-multiple!,	!select-one!,		!sample attributes!,		22,		5,		9,	!BioMaterialCharacteristics!,	!DiseaseState!,				!The name of the pathology diagnosed in the organism that the biomaterial is derived from. The disease state is normal if no disease has been diagnosed.!
2,	40,	!Disease Location!,					1,	1,	0,	!recommended!,	1,	0,	!select-multiple!,	!select-multiple!,	!sample attributes!,		23,		5,		9,	!BioMaterialCharacteristics!,	!DiseaseLocation!,			!Anatomical location(s) of disease in the organism that the biomaterial is derived from.!
2,	41,	!Disease Stage!,					1,	1,	0,	!recommended!,	1,	0,	!select-multiple!,	!select-one!,		!sample attributes!,		24,		5,		9,	!BioMaterialCharacteristics!,	!DiseaseStaging!,			!The stage or progression of a disease in the organism that the biomaterial is derived from. Includes pathological staging of cancers and other disease progression.!
2,	42,	!Tumor Grade!,						1,	1,	0,	!recommended!,	1,	0,	!select-multiple!,	!select-one!,		!sample attributes!,		25,		5,		9,	!BioMaterialCharacteristics!,	!TumorGrading!,				!A descriptor used in cancer biology to describe abnormalities of tumor cells.!
2,	43,	!Genetic Modification Type!,				1,	1,	0,	!recommended!,	1,	0,	!select-multiple!,	!select-one!,		!sample attributes!,		26,		5,		!NULL!,	!BioMaterialCharacteristics!,	!GeneticModification!,			!A genetic modification synthetically introduced into the organism that the biomaterial is derived from.!
2,	44,	!Genetic Modification Details!,				1,	0,	0,	!recommended!,	0,	0,	!text!,			!textarea!,		!sample attributes!,		27,		5,		!NULL!,	!BioMaterialCharacteristics!,	!NULL!,					!Genetic modification description and details.!
2,	45,	!Chromosomal Aberration Classification!,		1,	1,	0,	!recommended!,	1,	0,	!select-multiple!,	!select-multiple!,	!sample attributes!,		28,		5,		9,	!BioMaterialCharacteristics!,	!ChromosomalAberrationClassification!,	!An irregularity in the number or structure of chromosomes, usually in the form of a gain (duplication), loss (deletion), exchange (translocation), or alteration in sequence (inversion) of genetic material. Excludes simple changes in sequence such as mutations, and is usually detectable by cytogenetic and microscopic techniques.!
2,	46,	!Individual Genetic Characteristics!,			1,	0,	0,	!recommended!,	0,	0,	!text!,			!textarea!,		!sample attributes!,		29,		5,		!NULL!,	!BioMaterialCharacteristics!,	!IndividualGeneticCharacteristics!,	!The genotype of the individual organism that the biomaterial is derived from. Individual genetic characteristics include polymorphisms, disease alleles, and haplotypes.!
2,	47,	!Phenotype!,						1,	0,	0,	!recommended!,	0,	0,	!text!,			!textarea!,		!sample attributes!,		30,		5,		!NULL!,	!BioMaterialCharacteristics!,	!Phenotype!,				!The observable form taken by some character (or group of characters) in an individual or an organism, excluding pathology and disease. The detectable outward manifestations of a specific genotype.!
2,	48,	!Growth Conditions!,					1,	1,	0,	!recommended!,	0,	0,	!text!,			!textarea!,		!sample attributes!,		31,		5,		!NULL!,	!grow!,				!NULL!,					!A description of the conditions used to grow organisms or parts of the organism. This includes isolated environments such as cultures and open environments such as field studies.!
2,	49,	!Clinical History!,					1,	1,	0,	!recommended!,	0,	0,	!text!,			!textarea!,		!sample attributes!,		32,		5,		10,	!BioMaterialCharacteristics!,	!ClinicalHistory!,			!The patient's medical record as background information relevant to the experiment.!
2,	50,	!Clinical Treatment!,					1,	1,	0,	!recommended!,	0,	0,	!text!,			!textarea!,		!sample attributes!,		33,		5,		10,	!BioMaterialCharacteristics!,	!ClinicalTreatment!,			!The current clinical treatment(s) of the patient that the biomaterial is derived from.!
2,	51,	!Treatment Type!,					1,	0,	0,	!recommended!,	1,	0,	!select-multiple!,	!select-one!,		!sample attributes!,		34,		5,		!NULL!,	!treatment!,			!NULL!,					!The type of manipulation applied to the biomaterial for the purposes of generating one of the variables under study.!
2,	52,	!Drug Compound/Small Molecule!,				1,	1,	0,	!recommended!,	1,	0,	!select-multiple!,	!select-multiple!,	!sample attributes!,		35,		5,		10,	!treatment!,			!Compound!,				!Name of drug, compound, solvent, chemical, etc., used in treatment.!
2,	53,	!Treatment Delivery Method!,				1,	1,	0,	!recommended!,	1,	0,	!select-multiple!,	!select-one!,		!sample attributes!,		36,		5,		11,	!treatment!,			!NULL!,					!Treatment delivery method.!
2,	54,	!In vivo/vitro Treatment Details!,			1,	0,	0,	!recommended!,	0,	0,	!text!,			!textarea!,		!sample attributes!,		37,		5,		!NULL!,	!treatment!,			!NULL!,					!Details and steps of manipulation applied to the biomaterial for the purposes of generating one of the variables under study.!
2,	55,	!Nucleic Acid Extraction Method!,			1,	1,	0,	!required!,	1,	0,	!select-multiple!,	!select-multiple!,	!sample attributes!,		1,		6,		11,	!extraction!,			!NULL!,					!Protocol used to extract nucleic acids from the sample.!
2,	56,	!Nucleic Acid Type!,					1,	1,	0,	!required!,	1,	0,	!select-multiple!,	!select-one!,		!sample attributes!,		2,		6,		!NULL!,	!extraction!,			!MaterialType!,				!The type of nucleic acid extracted.!
2,	57,	!Nucleic Acid Cleanup!,					1,	1,	0,	!required!,	1,	1,	!select-multiple!,	!select-one!,		!sample attributes!,		3,		6,		11,	!extraction!,			!NULL!,					!The method used to clean up nucleic acids.!
2,	58,	!Nucleic Acid Starting Amount!,				1,	1,	1,	!required!,	0,	0,	!text!,			!text!,			!sample attributes!,		4,		6,		11,	!extraction!,			!NULL!,					!Amount of nucleic acid used to start hybridization protocol.!
2,	59,	!Amplification Method!,					1,	1,	0,	!required!,	1,	0,	!select-multiple!,	!select-one!,		!sample attributes!,		5,		6,		11,	!extraction!,			!NULL!,					!The method used to amplify the nucleic acid extracted.!
2,	60,	!cDNA Synthesis!,					1,	1,	0,	!required!,	1,	1,	!select-multiple!,	!select-one!,		!sample attributes!,		6,		6,		11,	!labeling!,			!NULL!,					!The method used to synthesize cDNA.!
2,	61,	!cDNA Cleanup!,						1,	1,	0,	!required!,	1,	1,	!select-multiple!,	!select-one!,		!sample attributes!,		7,		6,		11,	!labeling!,			!NULL!,					!The method used to clean up cDNA.!
2,	62,	!cRNA Synthesis!,					1,	1,	0,	!required!,	1,	0,	!select-multiple!,	!select-one!,		!sample attributes!,		8,		6,		11,	!labeling!,			!NULL!,					!The method used to synthesize cRNA.!
2,	63,	!cRNA Cleanup!,						1,	1,	0,	!required!,	1,	0,	!select-multiple!,	!select-one!,		!sample attributes!,		9,		6,		11,	!labeling!,			!NULL!,					!The method used to clean up cRNA.!
2,	64,	!Spike Target Element!,					1,	0,	0,	!required!,	1,	1,	!select-multiple!,	!select-one!,		!sample attributes!,		10,		6,		!NULL!,	!labeling!,			!NULL!,					!Type of spike control used.!
2,	65,	!Spiking Control!,					1,	0,	0,	!required!,	0,	0,	!select-multiple!,	!select-one!,		!sample attributes!,		11,		6,		!NULL!,	!labeling!,			!NULL!,					!Spike control qualifiers -- concentration, expected ratio.!
2,	79,	!Dye!,							1,	0,	0,	!required!,	1,	1,	!select-multiple!,	!select-one!,		!sample attributes!,		12,		6,		!NULL!,	!labeling!,			!NULL!,					!The name of the dye used in labeling the extract.!
2,	66,	!Washing/Staining Procedure!,				1,	1,	0,	!required!,	1,	1,	!select-multiple!,	!select-one!,		!sample attributes!,		13,		6,		11,	!hybridization!,		!NULL!,					!Washing and staining procedure used in hybridization protocol.!
2,	67,	!Washing/Staining Instrumentation!,			1,	1,	0,	!required!,	1,	0,	!select-multiple!,	!select-one!,		!sample attributes!,		14,		6,		11,	!hybridization!,		!NULL!,					!Washing instrumentation hardware.!
2,	68,	!Labeled Nucleic Acid Amount!,				1,	1,	1,	!required!,	0,	0,	!text!,			!text!,			!sample attributes!,		15,		6,		11,	!hybridization!,		!NULL!,					!Amount of labeled nucleic acid obtained after target synthesis.!
2,	69,	!Hybridization Time!,					1,	1,	1,	!required!,	0,	0,	!text!,			!text!,			!sample attributes!,		16,		6,		11,	!hybridization!,		!NULL!,					!Hybridization time.!
2,	70,	!Hybridization Concentration!,				1,	1,	1,	!required!,	0,	0,	!text!,			!text!,			!sample attributes!,		17,		6,		11,	!hybridization!,		!NULL!,					!Hybridization concentration.!
2,	71,	!Hybridization Volume!,					1,	1,	1,	!required!,	0,	0,	!text!,			!text!,			!sample attributes!,		18,		6,		11,	!hybridization!,		!NULL!,					!Hybridization volume.!
2,	72,	!Hybridization Temperature!,				1,	1,	1,	!required!,	0,	0,	!text!,			!text!,			!sample attributes!,		19,		6,		11,	!hybridization!,		!NULL!,					!Hybridization temperature.!
2,	73,	!Hybridization Comments/Notes!,				1,	0,	0,	!recommended!,	0,	0,	!text!,			!textarea!,		!sample attributes!,		20,		6,		!NULL!,	!hybridization!,		!NULL!,					!Additional notes or comments on the hybridization procedure.!
2,	74,	!Scanner Hardware!,					1,	1,	0,	!required!,	1,	0,	!select-multiple!,	!select-one!,		!sample attributes!,		1,		7,		11,	!scanning!,			!NULL!,					!Scanner hardware model.!
2,	75,	!Scanning Software!,					1,	0,	0,	!required!,	1,	0,	!select-multiple!,	!select-one!,		!sample attributes!,		2,		7,		!NULL!,	!scanning!,			!NULL!,					!Scanning software used.!
2,	76,	!Image Analysis Software!,				1,	0,	0,	!required!,	1,	0,	!select-multiple!,	!select-one!,		!sample attributes!,		3,		7,		!NULL!,	!image_analysis!,		!NULL!,					!Image analysis software used.!
2,	77,	!Image Analysis Algorithm!,				1,	1,	0,	!required!,	1,	0,	!select-multiple!,	!select-one!,		!sample attributes!,		4,		7,		11,	!image_analysis!,		!NULL!,					!Image analysis algorithm used.!
2,	78,	!Data Processing/Normalization!,			1,	0,	0,	!required!,	0,	0,	!text!,			!textarea!,		!sample attributes!,		5,		7,		!NULL!,	!normalization!,		!NULL!,					!Details on any data processing and normalization strategies.!
2,	101,	!Experiment ID!,					1,	0,	1,	!required!,	0,	0,	!text!,			!text!,			!NULL!,				1,		2,		!NULL!,	!NULL!,				!NULL!,					!MIMAS Repository Experiment ID.!
2,	103,	!Experiment Name!,					1,	0,	0,	!required!,	0,	0,	!text!,			!text!,			!NULL!,				3,		2,		!NULL!,	!NULL!,				!NULL!,					!Experiment name/short description.!
2,	104,	!Upload Date!,						1,	0,	0,	!required!,	0,	0,	!date!,			!date!,			!NULL!,				5,		2,		!NULL!,	!NULL!,				!NULL!,					!Date experiment was uploaded into MIMAS.!
2,	105,	!Sample ID!,						1,	0,	1,	!required!,	0,	0,	!text!,			!text!,			!NULL!,				1,		4,		!NULL!,	!NULL!,				!NULL!,					!MIMAS Repository Sample ID.!
2,	106,	!Sample Owner!,						1,	0,	0,	!required!,	0,	0,	!select-multiple!,	!select-one!,		!NULL!,				2,		4,		!NULL!,	!NULL!,				!NULL!,					!MIMAS User who owns sample.!
2,	107,	!Sample Name!,						1,	0,	0,	!required!,	0,	0,	!text!,			!text!,			!NULL!,				3,		4,		!NULL!,	!NULL!,				!NULL!,					!Original user sample name.!
2,	108,	!Experimental Condition Name!,				1,	0,	0,	!required!,	0,	0,	!text!,			!text!,			!NULL!,				4,		4,		!NULL!,	!NULL!,				!NULL!,					!User-supplied name of experimental condition to which sample belongs.!
2,	109,	!Hybridization Date!,					1,	0,	0,	!required!,	0,	0,	!date!,			!date!,			!NULL!,				5,		4,		!NULL!,	!NULL!,				!NULL!,					!Date hybridization was performed.!
2,	201,	!atmosphere!,						0,	1,	0,	!optional!,	0,	0,	!text!,			!text!,			!NULL!,				!NULL!,		8,		10,	!FactorValue!,			!Atmosphere!,				!The atmospheric conditions used to culture or grow an organism.!
2,	202,	!barrier facility!,					0,	1,	0,	!optional!,	1,	0,	!select-multiple!,	!select-one!,		!NULL!,				!NULL!,		8,		10,	!FactorValue!,			!BarrierFacility!,			!The rating of containment system used to protect organisms from infectious agents.!
2,	203,	!bedding!,						0,	1,	0,	!optional!,	1,	0,	!select-multiple!,	!select-multiple!,	!NULL!,				!NULL!,		8,		10,	!FactorValue!,			!Bedding!,				!Bedding material present in the animal's housing.!
2,	204,	!genetic modification/variation!,			0,	1,	0,	!optional!,	0,	0,	!text!,			!text!,			!NULL!,				!NULL!,		8,		9,	!FactorValue!,			!Genotype!,				!A genetic variation present in the organism that the biomaterial is derived from.!
2,	205,	!media!,						0,	1,	0,	!optional!,	0,	0,	!text!,			!text!,			!NULL!,				!NULL!,		8,		10,	!FactorValue!,			!Media!,				!The physical state or matrix used to provide nutrients to the organism (e.g., liquid, agar, soil).!
2,	206,	!nutrients!,						0,	1,	0,	!optional!,	0,	0,	!text!,			!text!,			!NULL!,				!NULL!,		8,		10,	!FactorValue!,			!Nutrients!,				!The food provided to the organism that the biomaterial is derived from.!
2,	207,	!physical characteristic!,				0,	1,	0,	!optional!,	0,	0,	!text!,			!text!,			!NULL!,				!NULL!,		8,		9,	!FactorValue!,			!Observation!,				!A physical characteristic seen in the organism that the biomaterial is derived from.!
2,	208,	!population density!,					0,	1,	1,	!optional!,	0,	0,	!text!,			!text!,			!NULL!,				!NULL!,		8,		10,	!FactorValue!,			!PopulationDensity!,			!The concentration range of the organism.!
2,	209,	!temperature!,						0,	1,	1,	!optional!,	0,	0,	!text!,			!text!,			!NULL!,				!NULL!,		8,		10,	!FactorValue!,			!Temperature!,				!The temperature that the organism was exposed to.!
2,	210,	!cell differentiation stage!,				0,	1,	0,	!optional!,	0,	0,	!text!,			!text!,			!NULL!,				!NULL!,		8,		11,	!FactorValue!,			!NULL!,					!The stage of differentiation of the cell.!
2,	211,	!individual genetic characteristic!,			0,	1,	0,	!optional!,	0,	0,	!text!,			!text!,			!NULL!,				!NULL!,		8,		9,	!FactorValue!,			!IndividualGeneticCharacteristics!,	!A particular genotype of the individual organism that the biomaterial is derived from. Individual genetic characteristics include polymorphisms, disease alleles, and haplotypes.!
2,	212,	!time!,							0,	1,	1,	!optional!,	0,	0,	!text!,			!text!,			!NULL!,				!NULL!,		8,		11,	!FactorValue!,			!Time!,					!Time period elapsed.!
2,	213,	!tissue type!,						0,	1,	0,	!optional!,	1,	0,	!select-multiple!,	!select-one!,		!NULL!,				!NULL!,		8,		9,	!FactorValue!,			!OrganismPart!,				!Tissue type that the biomaterial is derived from.!
2,	214,	!dose!,							0,	1,	1,	!optional!,	0,	0,	!text!,			!text!,			!NULL!,				!NULL!,		8,		10,	!NULL!,				!NULL!,					!The measured quantity of a drug, compound, small molecule, therapeutic agent, or radiation.!
2,	216,	!dose (absorbed radiation)!,				0,	1,	1,	!optional!,	0,	0,	!text!,			!text!,			!NULL!,				!NULL!,		8,		!NULL!,	!FactorValue!,			!NULL!,					!NULL!
2,	217,	!cell differentiation time!,				0,	1,	1,	!optional!,	0,	0,	!text!,			!text!,			!NULL!,				!NULL!,		8,		!NULL!,	!FactorValue!,			!NULL!,					!NULL!
2,	218,	!Relevant Publication/PubMed ID!,			1,	0,	1,	!optional!,	0,	0,	!text!,			!text!,			!experiment information!,	11,		2,		!NULL!,	!NULL!,				!NULL!,					!Relevant publications associated with experiment.!
2,	219,	!Microarray data repository!,				1,	0,	0,	!optional!,	0,	0,	!text!,			!text!,			!sample attributes!,		19,		12,		!NULL!,	!NULL!,				!NULL!,					!Public microarray data repository accession number.!
2,	220,	!Sample Material Type!,					1,	1,	0,	!required!,	0,	0,	!select-one!,		!select-one!,		!sample attributes!,		19,		5,		9,	!FactorValue!,			!MaterialType!,				!Whether the sample contain a purified cell type or a mixture of cell types. In the latter case, the Targeted Cell Type is the cell of primary interest within the mixture.!
3,	1,	6,		!Biomolecular Annotation!,		1,			!NULL!
3,	2,	6,		!Biological Property!,			2,			!NULL!
3,	3,	6,		!Epidemiological Design!,		3,			!NULL!
3,	4,	6,		!Methodological Design!,		4,			!NULL!
3,	5,	6,		!Perturbational Design!,		5,			!NULL!
3,	6,	7,		!Biological Property!,			1,			!NULL!
3,	7,	7,		!Environmental Factor!,			2,			!NULL!
3,	8,	7,		!Methodological Factor!,		3,			!NULL!
3,	9,	39,		!Normal!,						1,			!NULL!
4,	4,	!NULL!,	!Biozentrum Life Science Training Facility (LSTF), University of Basel!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	4,	!NULL!,	!DNA Array Facility (DAFL), CIG University of Lausanne!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	4,	!NULL!,	!Functional Genomics Center (FGCZ), ETH Zurich!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	4,	!NULL!,	!Functional Genomics Facility, Oncology Institute of Southern Switzerland!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	4,	!NULL!,	!Genomics Platform, NCCR Frontiers in Genetics, University of Geneva!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	4,	!NULL!,	!Imported from external source!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	6,	1,	!RNA stability design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!RNA_stability_design!
4,	6,	4,	!all pairs!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!all_pairs!
4,	6,	4,	!array platform variation design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!array_platform_variation_design!
4,	6,	1,	!binding site identification design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!binding_site_identification_design!
4,	6,	2,	!cell cycle design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!cell_cycle_design!
4,	6,	2,	!cell type comparison design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!cell_type_comparison_design!
4,	6,	5,	!cellular modification design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!cellular_modification_design!
4,	6,	2,	!cellular process design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!cellular_process_design!
4,	6,	3,	!clinical history design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!clinical_history_design!
4,	6,	1,	!co-expression design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!co-expression_design!
4,	6,	1,	!comparative genome hybridization design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!comparative_genome_hybridization_design!
4,	6,	5,	!compound treatment design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!compound_treatment_design!
4,	6,	2,	!development or differentiation design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!development_or_differentiation_design!
4,	6,	3,	!disease state design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!disease_state_design!
4,	6,	5,	!dose response design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!dose_response_design!
4,	6,	4,	!dye swap design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!dye_swap_design!
4,	6,	4,	!ex vivo design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!ex_vivo_design!
4,	6,	3,	!family history design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!family_history_design!
4,	6,	5,	!genetic modification design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!genetic_modification_design!
4,	6,	1,	!genotyping design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!genotyping_design!
4,	6,	5,	!growth condition design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!growth_condition_design!
4,	6,	4,	!hardware variation design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!hardware_variation_design!
4,	6,	2,	!imprinting design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!imprinting_design!
4,	6,	4,	!in vitro design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!in_vitro_design!
4,	6,	4,	!in vivo design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!in_vivo_design!
4,	6,	2,	!individual genetic characteristics design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!individual_genetic_characteristics_design!
4,	6,	5,	!injury design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!injury_design!
4,	6,	2,	!innate behavior design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!innate_behavior_design!
4,	6,	2,	!is expressed design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!is_expressed_design!
4,	6,	4,	!loop design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!loop_design!
4,	6,	5,	!non-targeted transgenic variation design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!non-targeted_transgenic_variation_design!
4,	6,	4,	!normalization testing design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!normalization_testing_design!
4,	6,	4,	!operator variation design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!operator_variation_design!
4,	6,	1,	!operon identification design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!operon_identification_design!
4,	6,	4,	!optimization design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!optimization_design!
4,	6,	2,	!organism part comparison design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!organism_part_comparison_design!
4,	6,	2,	!organism status design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!organism_status_design!
4,	6,	5,	!pathogenicity design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!pathogenicity_design!
4,	6,	2,	!physiological process design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!physiological_process_design!
4,	6,	4,	!quality control testing design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!quality_control_testing_design!
4,	6,	4,	!reference design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!reference_design!
4,	6,	4,	!replicate design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!replicate_design!
4,	6,	1,	!secreted protein identification design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!secreted_protein_identification_design!
4,	6,	4,	!self vs self design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!self_vs_self_design!
4,	6,	2,	!sex design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!sex_design!
4,	6,	4,	!software variation design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!software_variation_design!
4,	6,	2,	!species design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!species_design!
4,	6,	5,	!stimulus or stress design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!stimulus_or_stress_design!
4,	6,	2,	!strain or line design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!strain_or_line_design!
4,	6,	1,	!tiling path design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!tiling_path_design!
4,	6,	4,	!time series design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!time_series_design!
4,	6,	1,	!transcript identification design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!transcript_identification_design!
4,	6,	1,	!translational bias design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!translational_bias_design!
4,	6,	2,	!cell component comparison design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!cell_component_comparison_design!
4,	6,	!NULL!,	!unknown experiment design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!unknown_experiment_design_type!
4,	6,	5,	!stimulated design!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!stimulated_design_type!
4,	7,	8,	!amplification method!,	!value!,	0,	0,	!NULL!,	!NULL!,	59,	!NULL!,	!NULL!
4,	7,	7,	!atmosphere!,	!value!,	0,	0,	!NULL!,	!NULL!,	201,	!NULL!,	!NULL!
4,	7,	7,	!barrier facility!,	!value!,	0,	0,	!NULL!,	!NULL!,	202,	!NULL!,	!NULL!
4,	7,	7,	!bedding!,	!value!,	0,	0,	!NULL!,	!NULL!,	203,	!NULL!,	!NULL!
4,	7,	8,	!cDNA cleanup!,	!value!,	0,	0,	!NULL!,	!NULL!,	61,	!NULL!,	!NULL!
4,	7,	8,	!cDNA synthesis!,	!value!,	0,	0,	!NULL!,	!NULL!,	60,	!NULL!,	!NULL!
4,	7,	6,	!cell differentiation stage!,	!value!,	0,	0,	!NULL!,	!NULL!,	210,	!NULL!,	!NULL!
4,	7,	6,	!cell differentiation time!,	!value!,	0,	0,	!NULL!,	!NULL!,	217,	!NULL!,	!NULL!
4,	7,	6,	!cell line!,	!value!,	0,	0,	!NULL!,	!NULL!,	38,	!NULL!,	!NULL!
4,	7,	6,	!cell type/targeted cell type!,	!value!,	0,	0,	!NULL!,	!NULL!,	36,	!NULL!,	!NULL!
4,	7,	8,	!cell/tissue separation technique!,	!value!,	0,	0,	!NULL!,	!NULL!,	35,	!NULL!,	!NULL!
4,	7,	6,	!chromosomal aberration classification!,	!value!,	0,	0,	!NULL!,	!NULL!,	45,	!NULL!,	!NULL!
4,	7,	6,	!clinical history!,	!value!,	0,	0,	!NULL!,	!NULL!,	49,	!NULL!,	!NULL!
4,	7,	6,	!clinical treatment!,	!value!,	0,	0,	!NULL!,	!NULL!,	50,	!NULL!,	!NULL!
4,	7,	8,	!cRNA cleanup!,	!value!,	0,	0,	!NULL!,	!NULL!,	63,	!NULL!,	!NULL!
4,	7,	8,	!cRNA synthesis!,	!value!,	0,	0,	!NULL!,	!NULL!,	62,	!NULL!,	!NULL!
4,	7,	6,	!disease location!,	!value!,	0,	0,	!NULL!,	!NULL!,	40,	!NULL!,	!NULL!
4,	7,	6,	!disease stage!,	!value!,	0,	0,	!NULL!,	!NULL!,	41,	!NULL!,	!NULL!
4,	7,	6,	!disease state!,	!value!,	0,	0,	!NULL!,	!NULL!,	39,	!NULL!,	!NULL!
4,	7,	7,	!dose!,	!value!,	0,	0,	!NULL!,	!NULL!,	214,	!NULL!,	!NULL!
4,	7,	7,	!dose (absorbed radiation)!,	!value!,	0,	0,	!NULL!,	!NULL!,	216,	!NULL!,	!NULL!
4,	7,	6,	!drug compound/small molecule!,	!value!,	0,	0,	!NULL!,	!NULL!,	52,	!NULL!,	!NULL!
4,	7,	6,	!genetic modification/variation!,	!value!,	0,	0,	!NULL!,	!NULL!,	204,	!NULL!,	!NULL!
4,	7,	6,	!genetic modification type!,	!value!,	0,	0,	!NULL!,	!NULL!,	43,	!NULL!,	!NULL!
4,	7,	7,	!growth conditions!,	!value!,	0,	0,	!NULL!,	!NULL!,	48,	!NULL!,	!NULL!
4,	7,	6,	!histology!,	!value!,	0,	0,	!NULL!,	!NULL!,	34,	!NULL!,	!NULL!
4,	7,	8,	!hybridization concentration!,	!value!,	0,	0,	!NULL!,	!NULL!,	70,	!NULL!,	!NULL!
4,	7,	8,	!hybridization temperature!,	!value!,	0,	0,	!NULL!,	!NULL!,	72,	!NULL!,	!NULL!
4,	7,	8,	!hybridization time!,	!value!,	0,	0,	!NULL!,	!NULL!,	69,	!NULL!,	!NULL!
4,	7,	8,	!hybridization volume!,	!value!,	0,	0,	!NULL!,	!NULL!,	71,	!NULL!,	!NULL!
4,	7,	8,	!image analysis algorithm!,	!value!,	0,	0,	!NULL!,	!NULL!,	77,	!NULL!,	!NULL!
4,	7,	6,	!individual genetic characteristic!,	!value!,	0,	0,	!NULL!,	!NULL!,	211,	!NULL!,	!NULL!
4,	7,	6,	!individual organism or pool identifier!,	!value!,	0,	0,	!NULL!,	!NULL!,	21,	!NULL!,	!NULL!
4,	7,	8,	!labeled nucleic acid amount!,	!value!,	0,	0,	!NULL!,	!NULL!,	68,	!NULL!,	!NULL!
4,	7,	6,	!max organism age!,	!value!,	0,	0,	!NULL!,	!NULL!,	26,	!NULL!,	!NULL!
4,	7,	7,	!media!,	!value!,	0,	0,	!NULL!,	!NULL!,	205,	!NULL!,	!NULL!
4,	7,	6,	!min organism age!,	!value!,	0,	0,	!NULL!,	!NULL!,	25,	!NULL!,	!NULL!
4,	7,	8,	!nucleic acid cleanup!,	!value!,	0,	0,	!NULL!,	!NULL!,	57,	!NULL!,	!NULL!
4,	7,	8,	!nucleic acid extraction method!,	!value!,	0,	0,	!NULL!,	!NULL!,	55,	!NULL!,	!NULL!
4,	7,	8,	!nucleic acid starting amount!,	!value!,	0,	0,	!NULL!,	!NULL!,	58,	!NULL!,	!NULL!
4,	7,	8,	!nucleic acid type!,	!value!,	0,	0,	!NULL!,	!NULL!,	56,	!NULL!,	!NULL!
4,	7,	7,	!nutrients!,	!value!,	0,	0,	!NULL!,	!NULL!,	206,	!NULL!,	!NULL!
4,	7,	6,	!organ/organism part!,	!value!,	0,	0,	!NULL!,	!NULL!,	29,	!NULL!,	!NULL!
4,	7,	6,	!organism!,	!value!,	0,	0,	!NULL!,	!NULL!,	19,	!NULL!,	!NULL!
4,	7,	6,	!organism age!,	!value!,	0,	0,	!NULL!,	!NULL!,	24,	!NULL!,	!NULL!
4,	7,	6,	!organism developmental stage!,	!value!,	0,	0,	!NULL!,	!NULL!,	28,	!NULL!,	!NULL!
4,	7,	6,	!organism status!,	!value!,	0,	0,	!NULL!,	!NULL!,	20,	!NULL!,	!NULL!
4,	7,	6,	!physical characteristic!,	!value!,	0,	0,	!NULL!,	!NULL!,	207,	!NULL!,	!NULL!
4,	7,	7,	!population density!,	!value!,	0,	0,	!NULL!,	!NULL!,	208,	!NULL!,	!NULL!
4,	7,	8,	!sample source provider!,	!value!,	0,	0,	!NULL!,	!NULL!,	31,	!NULL!,	!NULL!
4,	7,	8,	!sample source type!,	!value!,	0,	0,	!NULL!,	!NULL!,	30,	!NULL!,	!NULL!
4,	7,	8,	!scanner hardware!,	!value!,	0,	0,	!NULL!,	!NULL!,	74,	!NULL!,	!NULL!
4,	7,	6,	!sex/mating type!,	!value!,	0,	0,	!NULL!,	!NULL!,	22,	!NULL!,	!NULL!
4,	7,	6,	!strain/line/cultivar!,	!value!,	0,	0,	!NULL!,	!NULL!,	37,	!NULL!,	!NULL!
4,	7,	7,	!temperature!,	!value!,	0,	0,	!NULL!,	!NULL!,	209,	!NULL!,	!NULL!
4,	7,	8,	!time!,	!value!,	0,	0,	!NULL!,	!NULL!,	212,	!NULL!,	!NULL!
4,	7,	6,	!tissue type!,	!value!,	0,	0,	!NULL!,	!NULL!,	213,	!NULL!,	!NULL!
4,	7,	8,	!treatment delivery method!,	!value!,	0,	0,	!NULL!,	!NULL!,	53,	!NULL!,	!NULL!
4,	7,	6,	!tumor grade!,	!value!,	0,	0,	!NULL!,	!NULL!,	42,	!NULL!,	!NULL!
4,	7,	8,	!washing/staining instrumentation!,	!value!,	0,	0,	!NULL!,	!NULL!,	67,	!NULL!,	!NULL!
4,	7,	8,	!washing/staining procedure!,	!value!,	0,	0,	!NULL!,	!NULL!,	66,	!NULL!,	!NULL!
4,	7,	6,	!sample material type!,	!value!,	0,	0,	!NULL!,	!NULL!,	220,	!NULL!,	!NULL!
4,	15,	!NULL!,	!biological level!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!biological_replicate!
4,	15,	!NULL!,	!hybridization level!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!technical_replicate!
4,	15,	!NULL!,	!no replicates!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	15,	!NULL!,	!RNA level!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!technical_replicate!
4,	15,	!NULL!,	!target level!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!technical_replicate!
4,	15,	!NULL!,	!dye swap!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!dye_swap_replicate!
4,	19,	!NULL!,	!Anopheles gambiae!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	19,	!NULL!,	!Arabidopsis thaliana!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	19,	!NULL!,	!Bacillus subtilis!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	19,	!NULL!,	!Caenorhabditis elegans!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	19,	!NULL!,	!Canis familiaris!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	19,	!NULL!,	!Danio rerio!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	19,	!NULL!,	!Drosophila melanogaster!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	19,	!NULL!,	!Escherichia coli!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	19,	!NULL!,	!Homo sapiens!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	19,	!NULL!,	!Hordeum distichon!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	19,	!NULL!,	!Mus musculus!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	19,	!NULL!,	!Plasmodium falciparum!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	19,	!NULL!,	!Pseudomonas aeruginosa!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	19,	!NULL!,	!Rattus norvegicus!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	19,	!NULL!,	!Saccharomyces cerevisiae!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	19,	!NULL!,	!Schizosaccharomyces pombe!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	19,	!NULL!,	!Staphylococcus aureus!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	19,	!NULL!,	!Vitis vinifera!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	19,	!NULL!,	!Xenopus laevis!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	20,	!NULL!,	!postmortem!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!postmortem!
4,	20,	!NULL!,	!premortem!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!premortem!
4,	22,	!NULL!,	!diploid a/alpha!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!mating_type_a/mating_type_alpha!
4,	22,	!NULL!,	!diploid alpha/alpha!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!mating_type_alpha/mating_type_alpha!
4,	22,	!NULL!,	!diploid a/a!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!mating_type_a/mating_type_a!
4,	22,	!NULL!,	!F+!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!F!
4,	22,	!NULL!,	!F-!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!F_minus!
4,	22,	!NULL!,	!female!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!female!
4,	22,	!NULL!,	!hermaphrodite!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!hermaphrodite!
4,	22,	!NULL!,	!male!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!male!
4,	22,	!NULL!,	!mating type a!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!mating_type_a!
4,	22,	!NULL!,	!mating type alpha!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!mating_type_alpha!
4,	22,	!NULL!,	!mating type h+!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!mating_type_h_plus!
4,	22,	!NULL!,	!mating type h-!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!mating_type_h_minus!
4,	22,	!NULL!,	!mixed!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!mixed_sex!
4,	22,	!NULL!,	!unknown!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!unknown_sex!
4,	23,	!NULL!,	!specified mean!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	23,	!NULL!,	!specified median!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	23,	!NULL!,	!specified range!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	23,	!NULL!,	!specified single!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	23,	!NULL!,	!unknown!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	24,	!NULL!,	!days!,	!unit!,	0,	0,	0,	86400,	!NULL!,	!NULL!,	!d!
4,	24,	!NULL!,	!hours!,	!unit!,	0,	0,	0,	3600,	!NULL!,	!NULL!,	!h!
4,	24,	!NULL!,	!minutes!,	!unit!,	0,	0,	0,	60,	!NULL!,	!NULL!,	!m!
4,	24,	!NULL!,	!months!,	!unit!,	0,	0,	0,	2629743.83333333333,	!NULL!,	!NULL!,	!months!
4,	24,	!NULL!,	!ms!,	!unit!,	0,	0,	0,	1E-03,	!NULL!,	!NULL!,	!ms!
4,	24,	!NULL!,	!seconds!,	!unit!,	0,	0,	0,	1,	!NULL!,	!NULL!,	!s!
4,	24,	!NULL!,	!us!,	!unit!,	0,	0,	0,	1E-06,	!NULL!,	!NULL!,	!us!
4,	24,	!NULL!,	!weeks!,	!unit!,	0,	0,	0,	604800,	!NULL!,	!NULL!,	!weeks!
4,	24,	!NULL!,	!years!,	!unit!,	0,	0,	0,	31556926,	!NULL!,	!NULL!,	!years!
4,	25,	!NULL!,	!days!,	!unit!,	0,	0,	0,	86400,	!NULL!,	!NULL!,	!d!
4,	25,	!NULL!,	!hours!,	!unit!,	0,	0,	0,	3600,	!NULL!,	!NULL!,	!h!
4,	25,	!NULL!,	!minutes!,	!unit!,	0,	0,	0,	60,	!NULL!,	!NULL!,	!m!
4,	25,	!NULL!,	!months!,	!unit!,	0,	0,	0,	2629743.83333333333,	!NULL!,	!NULL!,	!months!
4,	25,	!NULL!,	!ms!,	!unit!,	0,	0,	0,	1E-03,	!NULL!,	!NULL!,	!ms!
4,	25,	!NULL!,	!seconds!,	!unit!,	0,	0,	0,	1,	!NULL!,	!NULL!,	!s!
4,	25,	!NULL!,	!us!,	!unit!,	0,	0,	0,	1E-06,	!NULL!,	!NULL!,	!us!
4,	25,	!NULL!,	!weeks!,	!unit!,	0,	0,	0,	604800,	!NULL!,	!NULL!,	!weeks!
4,	25,	!NULL!,	!years!,	!unit!,	0,	0,	0,	31556926,	!NULL!,	!NULL!,	!years!
4,	26,	!NULL!,	!days!,	!unit!,	0,	0,	0,	86400,	!NULL!,	!NULL!,	!d!
4,	26,	!NULL!,	!hours!,	!unit!,	0,	0,	0,	3600,	!NULL!,	!NULL!,	!h!
4,	26,	!NULL!,	!minutes!,	!unit!,	0,	0,	0,	60,	!NULL!,	!NULL!,	!m!
4,	26,	!NULL!,	!months!,	!unit!,	0,	0,	0,	2629743.83333333333,	!NULL!,	!NULL!,	!months!
4,	26,	!NULL!,	!ms!,	!unit!,	0,	0,	0,	1E-03,	!NULL!,	!NULL!,	!ms!
4,	26,	!NULL!,	!seconds!,	!unit!,	0,	0,	0,	1,	!NULL!,	!NULL!,	!s!
4,	26,	!NULL!,	!us!,	!unit!,	0,	0,	0,	1E-06,	!NULL!,	!NULL!,	!us!
4,	26,	!NULL!,	!weeks!,	!unit!,	0,	0,	0,	604800,	!NULL!,	!NULL!,	!weeks!
4,	26,	!NULL!,	!years!,	!unit!,	0,	0,	0,	31556926,	!NULL!,	!NULL!,	!years!
4,	27,	!NULL!,	!beginning of stage!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!beginning_of_stage!
4,	27,	!NULL!,	!birth (pp)!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!birth!
4,	27,	!NULL!,	!coitus (pc)!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!coitus!
4,	27,	!NULL!,	!eclosion!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!eclosion!
4,	27,	!NULL!,	!egg laying!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!egg_laying!
4,	27,	!NULL!,	!fertilization!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!fertilization!
4,	27,	!NULL!,	!germination!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!germination!
4,	27,	!NULL!,	!hatching!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!hatching!
4,	27,	!NULL!,	!planting!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!planting!
4,	27,	!NULL!,	!sowing!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!sowing!
4,	28,	!NULL!,	!adult!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	28,	!NULL!,	!embryo!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	28,	!NULL!,	!juvenile!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	28,	!NULL!,	!larva!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	28,	!NULL!,	!meiotic development!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	28,	!NULL!,	!mitotic growth!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	28,	!NULL!,	!mixed!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	28,	!NULL!,	!pup!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	28,	!NULL!,	!pupa!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	28,	!NULL!,	!seed!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	28,	!NULL!,	!seedling!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	28,	!NULL!,	!spore!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	28,	!NULL!,	!unknown!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	29,	!NULL!,	!blood!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	29,	!NULL!,	!bone marrow!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	29,	!NULL!,	!brain!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	29,	!NULL!,	!breast!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	29,	!NULL!,	!calvaria!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	29,	!NULL!,	!cartilage!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	29,	!NULL!,	!cerebral cortex!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	29,	!NULL!,	!colon!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	29,	!NULL!,	!esophagus!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	29,	!NULL!,	!eye!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	29,	!NULL!,	!heart!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	29,	!NULL!,	!kidney!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	29,	!NULL!,	!leaf!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	29,	!NULL!,	!liver!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	29,	!NULL!,	!lung!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	29,	!NULL!,	!lymph node!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	29,	!NULL!,	!muscle!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	29,	!NULL!,	!pancreas!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	29,	!NULL!,	!pistal!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	29,	!NULL!,	!rectum!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	29,	!NULL!,	!root!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	29,	!NULL!,	!seed!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	29,	!NULL!,	!skin!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	29,	!NULL!,	!small intestine!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	29,	!NULL!,	!spleen!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	29,	!NULL!,	!stamen!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	29,	!NULL!,	!stem!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	29,	!NULL!,	!stomach!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	30,	!NULL!,	!agar stab!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!agar_stab!
4,	30,	!NULL!,	!cell culture!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!fresh_sample!
4,	30,	!NULL!,	!cell line!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!fresh_sample!
4,	30,	!NULL!,	!freeze dried sample!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!freeze_dried_sample!
4,	30,	!NULL!,	!fresh sample!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!fresh_sample!
4,	30,	!NULL!,	!frozen sample!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!frozen_sample!
4,	30,	!NULL!,	!paraffin sample!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!paraffin_sample!
4,	30,	!NULL!,	!unknown!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	30,	!NULL!,	!urine!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!urine!
4,	35,	!NULL!,	!embryo sorting!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	35,	!NULL!,	!FACS!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	35,	!NULL!,	!microdissection!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	35,	!NULL!,	!trimming!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	36,	!NULL!,	!epithelial!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	36,	!NULL!,	!hepatic!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	36,	!NULL!,	!Sertoli!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	36,	!NULL!,	!spermatocyte!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	36,	!NULL!,	!neuron!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	37,	!NULL!,	!W303!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	37,	!NULL!,	!SK1!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	37,	!NULL!,	!Sprague-Dawley!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	38,	!NULL!,	!HeLa!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	39,	9,		!normal!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	40,	!NULL!,	!brain!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	40,	!NULL!,	!skin!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	40,	!NULL!,	!blood!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	40,	!NULL!,	!kidney!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	40,	!NULL!,	!colon!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	40,	!NULL!,	!heart!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	40,	!NULL!,	!muscle!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	40,	!NULL!,	!lymph node!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	40,	!NULL!,	!pancreas!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	40,	!NULL!,	!lung!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	40,	!NULL!,	!breast!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	40,	!NULL!,	!eye!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	40,	!NULL!,	!liver!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	40,	!NULL!,	!spleen!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	40,	!NULL!,	!esophagus!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	40,	!NULL!,	!rectum!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	40,	!NULL!,	!stomach!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	40,	!NULL!,	!small intestine!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	40,	!NULL!,	!leaf!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	40,	!NULL!,	!stem!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	40,	!NULL!,	!seed!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	40,	!NULL!,	!root!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	40,	!NULL!,	!pistal!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	40,	!NULL!,	!stamen!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	41,	!NULL!,	!0!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	41,	!NULL!,	!I!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	41,	!NULL!,	!IA!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	41,	!NULL!,	!IB!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	41,	!NULL!,	!II!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	41,	!NULL!,	!IIA!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	41,	!NULL!,	!IIB!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	41,	!NULL!,	!IIC!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	41,	!NULL!,	!III!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	41,	!NULL!,	!IIIA!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	41,	!NULL!,	!IIIB!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	41,	!NULL!,	!IIIC!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	41,	!NULL!,	!IV!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	41,	!NULL!,	!IVA!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	41,	!NULL!,	!IVB!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	41,	!NULL!,	!IVC!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	41,	!NULL!,	!V!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	42,	!NULL!,	!GX!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	42,	!NULL!,	!G1!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	42,	!NULL!,	!G2!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	42,	!NULL!,	!G3!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	42,	!NULL!,	!G4!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	43,	!NULL!,	!chromosomal substitution!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!chromosomal_substitution!
4,	43,	!NULL!,	!transfection!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!transfection!
4,	43,	!NULL!,	!gene knock-in!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!gene_knock_in!
4,	43,	!NULL!,	!gene knock-out!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!gene_knock_out!
4,	43,	!NULL!,	!induced mutation!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!induced_mutation!
4,	45,	!NULL!,	!chromosomal deletion!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!chromosomal_deletion!
4,	45,	!NULL!,	!chromosomal duplication!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!chromosomal_duplication!
4,	45,	!NULL!,	!chromosomal insertion!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!chromosomal_insertion!
4,	45,	!NULL!,	!chromosomal inversion!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!chromosomal_inversion!
4,	45,	!NULL!,	!chromosomal translocation!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!chromosomal_translocation!
4,	45,	!NULL!,	!genomic region amplification!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!genomic_region_amplification!
4,	45,	!NULL!,	!oligosomy!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!oligosomy!
4,	45,	!NULL!,	!polysomy!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!polysomy!
4,	51,	!NULL!,	!drug compound/small molecule!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	51,	!NULL!,	!radiation!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	51,	!NULL!,	!food deprivation!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	51,	!NULL!,	!plasmid overexpression!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	51,	!NULL!,	!osmotic shock!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	51,	!NULL!,	!temperature shock!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	52,	!NULL!,	!acetylsalicylic acid!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	52,	!NULL!,	!codeine!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	52,	!NULL!,	!acetaminophen!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	53,	!NULL!,	!ab libitum!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	53,	!NULL!,	!feeding!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	53,	!NULL!,	!in medium!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	53,	!NULL!,	!intramuscular injection!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	53,	!NULL!,	!intraperitoneal injection!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	53,	!NULL!,	!intravenous!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	53,	!NULL!,	!oral gavage!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	53,	!NULL!,	!subcutaneous!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	55,	!NULL!,	!phenol-based method!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	55,	!NULL!,	!silica columns!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	56,	!NULL!,	!total RNA!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!total_RNA!
4,	56,	!NULL!,	!mRNA!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!polyA_RNA!
4,	56,	!NULL!,	!DNA!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!DNA!
4,	57,	!NULL!,	!Qiagen RNeasy Mini Columns!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	57,	!NULL!,	!Qiagen RNeasy MinElute!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	59,	!NULL!,	!RNA polymerase - single round!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	59,	!NULL!,	!RNA polymerase - double round!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	59,	!NULL!,	!PCR!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	60,	!NULL!,	!Invitrogen SuperScript Double-Stranded cDNA Synthesis Kit!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	60,	!NULL!,	!Affymetrix GeneChip One-Cycle cDNA Synthesis Kit!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	61,	!NULL!,	!phenol extraction and precipitation!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	61,	!NULL!,	!Affymetrix GeneChip Sample Cleanup Module!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	62,	!NULL!,	!ENZO BioArray HighYield RNA Transcript Labeling Kit!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	62,	!NULL!,	!Affymetrix GeneChip Expression 3'-Amplification Kit for IVT Labeling!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	63,	!NULL!,	!Affymetrix GeneChip Sample Cleanup Module!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	63,	!NULL!,	!Qiagen RNeasy Mini Columns!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	63,	!NULL!,	!Qiagen RNeasy MinElute!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	64,	!NULL!,	!mRNA!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	64,	!NULL!,	!Target!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	64,	!NULL!,	!mRNA+Target!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	65,	!NULL!,	!Affymetrix standard!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	65,	!NULL!,	!custom-made!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	79,	!NULL!,	!biotin!,	!value!,	0,	1,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	66,	!NULL!,	!EukGE-WS2v4!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	66,	!NULL!,	!EukGE-WS2v5!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	66,	!NULL!,	!Midi_Euk2v3!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	66,	!NULL!,	!Mini_Euk1v3!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	66,	!NULL!,	!Mini_Euk2v3!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	67,	!NULL!,	!Fluidics Station 400!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	67,	!NULL!,	!Fluidics Station 450!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	74,	!NULL!,	!Affymetrix GeneChip Scanner 3000!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	74,	!NULL!,	!Agilent GeneArray Scanner G2500A!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	74,	!NULL!,	!Hewlett-Packard GeneArray Scanner G2500A!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	75,	!NULL!,	!GCOS!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	75,	!NULL!,	!MAS4!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	75,	!NULL!,	!MAS5!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	76,	!NULL!,	!GCOS!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	76,	!NULL!,	!MAS4!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	76,	!NULL!,	!MAS5!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	77,	!NULL!,	!GCOS!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	77,	!NULL!,	!MAS4!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	77,	!NULL!,	!MAS5!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	203,	!NULL!,	!recycled newspaper!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	213,	!NULL!,	!cartilage!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	58,	!NULL!,	!ug!,	!unit!,	0,	1,	0,	1E-06,	!NULL!,	!NULL!,	!ug!
4,	58,	!NULL!,	!ng!,	!unit!,	0,	0,	0,	1E-09,	!NULL!,	!NULL!,	!ng!
4,	68,	!NULL!,	!ug!,	!unit!,	0,	1,	0,	1E-06,	!NULL!,	!NULL!,	!ug!
4,	68,	!NULL!,	!ng!,	!unit!,	0,	0,	0,	1E-09,	!NULL!,	!NULL!,	!ng!
4,	69,	!NULL!,	!hours!,	!unit!,	0,	1,	0,	3600,	!NULL!,	!NULL!,	!h!
4,	70,	!NULL!,	!ug/ul!,	!unit!,	0,	1,	0,	1,	!NULL!,	!NULL!,	!mg_per_mL!
4,	71,	!NULL!,	!ul!,	!unit!,	0,	1,	0,	1,	!NULL!,	!NULL!,	!uL!
4,	72,	!NULL!,	!deg C!,	!unit!,	0,	1,	0,	1,	!NULL!,	!NULL!,	!degree_C!
4,	208,	!NULL!,	!organisms/m2!,	!unit!,	0,	0,	0,	1,	!NULL!,	!NULL!,	!organisms/m2!
4,	209,	!NULL!,	!deg C!,	!unit!,	0,	0,	0,	1,	!NULL!,	!NULL!,	!degree_C!
4,	209,	!NULL!,	!deg F!,	!unit!,	0,	0,	-32,	0.555555555555555,	!NULL!,	!NULL!,	!degree_F!
4,	209,	!NULL!,	!K!,	!unit!,	0,	0,	-273.15,	1,	!NULL!,	!NULL!,	!K!
4,	212,	!NULL!,	!weeks!,	!unit!,	0,	0,	0,	604800,	!NULL!,	!NULL!,	!weeks!
4,	212,	!NULL!,	!days!,	!unit!,	0,	0,	0,	86400,	!NULL!,	!NULL!,	!d!
4,	212,	!NULL!,	!hours!,	!unit!,	0,	0,	0,	3600,	!NULL!,	!NULL!,	!h!
4,	212,	!NULL!,	!minutes!,	!unit!,	0,	0,	0,	60,	!NULL!,	!NULL!,	!m!
4,	212,	!NULL!,	!months!,	!unit!,	0,	0,	0,	2629743.83333333333,	!NULL!,	!NULL!,	!months!
4,	212,	!NULL!,	!ms!,	!unit!,	0,	0,	0,	1E-03,	!NULL!,	!NULL!,	!ms!
4,	212,	!NULL!,	!seconds!,	!unit!,	0,	0,	0,	1,	!NULL!,	!NULL!,	!s!
4,	212,	!NULL!,	!us!,	!unit!,	0,	0,	0,	1E-06,	!NULL!,	!NULL!,	!us!
4,	212,	!NULL!,	!years!,	!unit!,	0,	0,	0,	31556926,	!NULL!,	!NULL!,	!years!
4,	214,	!NULL!,	!fg!,	!unit!,	0,	0,	0,	1E-15,	!NULL!,	!NULL!,	!fg!
4,	214,	!NULL!,	!g!,	!unit!,	0,	0,	0,	1,	!NULL!,	!NULL!,	!g!
4,	214,	!NULL!,	!kg!,	!unit!,	0,	0,	0,	1000,	!NULL!,	!NULL!,	!kg!
4,	214,	!NULL!,	!mg!,	!unit!,	0,	1,	0,	1E-03,	!NULL!,	!NULL!,	!mg!
4,	214,	!NULL!,	!ng!,	!unit!,	0,	0,	0,	1E-09,	!NULL!,	!NULL!,	!ng!
4,	214,	!NULL!,	!pg!,	!unit!,	0,	0,	0,	1E-12,	!NULL!,	!NULL!,	!pg!
4,	214,	!NULL!,	!ug!,	!unit!,	0,	0,	0,	1E-06,	!NULL!,	!NULL!,	!ug!
4,	216,	!NULL!,	!Gy!,	!unit!,	0,	1,	0,	1,	!NULL!,	!NULL!,	!Gy!
4,	216,	!NULL!,	!Rad!,	!unit!,	0,	0,	0,	0.01,	!NULL!,	!NULL!,	!Rad!
4,	216,	!NULL!,	!Rem!,	!unit!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!Rem!
4,	216,	!NULL!,	!Ci!,	!unit!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!Ci!
4,	216,	!NULL!,	!Roentgen!,	!unit!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!R!
4,	216,	!NULL!,	!dpm!,	!unit!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!dpm!
4,	216,	!NULL!,	!cpm!,	!unit!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!cpm!
4,	217,	!NULL!,	!days!,	!unit!,	0,	0,	0,	86400,	!NULL!,	!NULL!,	!d!
4,	217,	!NULL!,	!hours!,	!unit!,	0,	0,	0,	3600,	!NULL!,	!NULL!,	!h!
4,	217,	!NULL!,	!minutes!,	!unit!,	0,	0,	0,	60,	!NULL!,	!NULL!,	!m!
4,	217,	!NULL!,	!months!,	!unit!,	0,	0,	0,	2629743.83333333,	!NULL!,	!NULL!,	!months!
4,	217,	!NULL!,	!ms!,	!unit!,	0,	0,	0,	0.001,	!NULL!,	!NULL!,	!ms!
4,	217,	!NULL!,	!seconds!,	!unit!,	0,	0,	0,	1,	!NULL!,	!NULL!,	!s!
4,	217,	!NULL!,	!us!,	!unit!,	0,	0,	0,	0.000001,	!NULL!,	!NULL!,	!us!
4,	217,	!NULL!,	!weeks!,	!unit!,	0,	0,	0,	604800,	!NULL!,	!NULL!,	!weeks!
4,	217,	!NULL!,	!years!,	!unit!,	0,	0,	0,	31556926,	!NULL!,	!NULL!,	!years!
4,	219,	!NULL!,	!ArrayExpress accession number!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	219,	!NULL!,	!GEO accession number!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	219,	!NULL!,	!CIBEX accession number!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	219,	!NULL!,	!NASCArrays accession number!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
4,	220,	!NULL!,	!organ/organism part (mixed cell types)!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!organism_part!
4,	220,	!NULL!,	!purified cell type!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!cell!
4,	220,	!NULL!,	!whole organism!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!whole_organism!
4,	220,	!NULL!,	!virus!,	!value!,	0,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!virus!
4,	220,	!NULL!,	!unknown!,	!value!,	1,	0,	!NULL!,	!NULL!,	!NULL!,	!NULL!,	!NULL!
5,	1,	!GeneChip!,	!Affymetrix GeneChip!,	!Affymetrix!
5,	2,	!ChIP-chip!,	!ChIP-chip!,	!Affymetrix!
5,	3,	!Tiling!,	!Tiling array!,	!Affymetrix!
5,	4,	!BeadArray!,	!Illumina BeadArray!,	!Illumina!
5,	5,	!Sequencing!,	!Illumina Genome Analyzer!,	!Illumina!
7,	1,     !Dr.!
7,	2,     !Prof.!
8,	1,     !Afghanistan!
8,	2,     !Albania!
8,	3,     !Algeria!
8,	4,     !American Samoa!
8,	5,     !Andorra!
8,	6,     !Angola!
8,	7,     !Anguilla!
8,	8,     !Antarctica!
8,	9,     !Antigua And Barbuda!
8,	10,    !Argentina!
8,	11,    !Armenia!
8,	12,    !Aruba!
8,	13,    !Australia!
8,	14,    !Austria!
8,	15,    !Azerbaijan!
8,	16,    !Bahamas!
8,	17,    !Bahrain!
8,	18,    !Bangladesh!
8,	19,    !Barbados!
8,	20,    !Belarus!
8,	21,    !Belgium!
8,	22,    !Belize!
8,	23,    !Benin!
8,	24,    !Bermuda!
8,	25,    !Bhutan!
8,	26,    !Bolivia!
8,	27,    !Bosnia And Herzegowina!
8,	28,    !Botswana!
8,	29,    !Bouvet Island!
8,	30,    !Brazil!
8,	31,    !British Indian Ocean Territory!
8,	32,    !Brunei Darussalam!
8,	33,    !Bulgaria!
8,	34,    !Burkina Faso!
8,	35,    !Burundi!
8,	36,    !Cambodia!
8,	37,    !Cameroon!
8,	38,    !Canada!
8,	39,    !Cape Verde!
8,	40,    !Cayman Islands!
8,	41,    !Central African Republic!
8,	42,    !Chad!
8,	43,    !Chile!
8,	44,    !China!
8,	45,    !Christmas Island!
8,	46,    !Cocos (Keeling) Islands!
8,	47,    !Colombia!
8,	48,    !Comoros!
8,	49,    !Congo!
8,	50,    !Cook Islands!
8,	51,    !Costa Rica!
8,	52,    !Cote D'Ivoire!
8,	53,    !Croatia (Hrvatska)!
8,	54,    !Cuba!
8,	55,    !Cyprus!
8,	56,    !Czech Republic!
8,	57,    !Denmark!
8,	58,    !Djibouti!
8,	59,    !Dominica!
8,	60,    !Dominican Republic!
8,	61,    !East Timor!
8,	62,    !Ecuador!
8,	63,    !Egypt!
8,	64,    !El Salvador!
8,	65,    !Equatorial Guinea!
8,	66,    !Eritrea!
8,	67,    !Estonia!
8,	68,    !Ethiopia!
8,	69,    !Falkland Islands (Malvinas)!
8,	70,    !Faroe Islands!
8,	71,    !Fiji!
8,	72,    !Finland!
8,	73,    !France!
8,	74,    !France, Metropolitan!
8,	75,    !French Guiana!
8,	76,    !French Polynesia!
8,	77,    !French Southern Territories!
8,	78,    !Gabon!
8,	79,    !Gambia!
8,	80,    !Georgia!
8,	81,    !Germany!
8,	82,    !Ghana!
8,	83,    !Gibraltar!
8,	84,    !Greece!
8,	85,    !Greenland!
8,	86,    !Grenada!
8,	87,    !Guadeloupe!
8,	88,    !Guam!
8,	89,    !Guatemala!
8,	90,    !Guinea!
8,	91,    !Guinea-Bissau!
8,	92,    !Guyana!
8,	93,    !Haiti!
8,	94,    !Heard And McDonald Islands!
8,	95,    !Honduras!
8,	96,    !Hong Kong!
8,	97,    !Hungary!
8,	98,    !Iceland!
8,	99,    !India!
8,	100,    !Indonesia!
8,	101,    !Iran, Islamic Republic Of!
8,	102,    !Iraq!
8,	103,    !Ireland!
8,	104,    !Israel!
8,	105,    !Italy!
8,	106,    !Jamaica!
8,	107,    !Japan!
8,	108,    !Jordan!
8,	109,    !Kazakhstan!
8,	110,    !Kenya!
8,	111,    !Kiribati!
8,	112,    !Korea, Democratic People's Republic Of!
8,	113,    !Korea, Republic Of!
8,	114,    !Kuwait!
8,	115,    !Kyrgyzstan!
8,	116,    !Laos, People's Democratic Republic Of!
8,	117,    !Latvia!
8,	118,    !Lebanon!
8,	119,    !Lesotho!
8,	120,    !Liberia!
8,	121,    !Libyan Arab Jamahiriya!
8,	122,    !Liechtenstein!
8,	123,    !Lithuania!
8,	124,    !Luxembourg!
8,	125,    !Macau!
8,	126,    !Macedonia, The Former Yugoslav Republic Of!
8,	127,    !Madagascar!
8,	128,    !Malawi!
8,	129,    !Malaysia!
8,	130,    !Maldives!
8,	131,    !Mali!
8,	132,    !Malta!
8,	133,    !Marshall Islands!
8,	134,    !Martinique!
8,	135,    !Mauritania!
8,	136,    !Mauritius!
8,	137,    !Mayotte!
8,	138,    !Mexico!
8,	139,    !Micronesia, Federated States Of!
8,	140,    !Moldova, Republic Of!
8,	141,    !Monaco!
8,	142,    !Mongolia!
8,	143,    !Montserrat!
8,	144,    !Morocco!
8,	145,    !Mozambique!
8,	146,    !Myanmar!
8,	147,    !Namibia!
8,	148,    !Nauru!
8,	149,    !Nepal!
8,	150,    !Netherlands!
8,	151,    !Netherlands Antilles!
8,	152,    !New Caledonia!
8,	153,    !New Zealand!
8,	154,    !Nicaragua!
8,	155,    !Niger!
8,	156,    !Nigeria!
8,	157,    !Niue!
8,	158,    !Norfolk Island!
8,	159,    !Northern Mariana Islands!
8,	160,    !Norway!
8,	161,    !Oman!
8,	162,    !Pakistan!
8,	163,    !Palau!
8,	164,    !Panama!
8,	165,    !Papua New Guinea!
8,	166,    !Paraguay!
8,	167,    !Peru!
8,	168,    !Philippines!
8,	169,    !Pitcairn!
8,	170,    !Poland!
8,	171,    !Portugal!
8,	172,    !Puerto Rico!
8,	173,    !Qatar!
8,	174,    !Reunion!
8,	175,    !Romania!
8,	176,    !Russian Federation!
8,	177,    !Rwanda!
8,	178,    !Saint Kitts And Nevis!
8,	179,    !Saint Lucia!
8,	180,    !Saint Vincent And The Grenadines!
8,	181,    !Samoa!
8,	182,    !San Marino!
8,	183,    !Sao Tome And Principe!
8,	184,    !Saudi Arabia!
8,	185,    !Senegal!
8,	186,    !Seychelles!
8,	187,    !Sierra Leone!
8,	188,    !Singapore!
8,	189,    !Slovakia (Slovak Republic)!
8,	190,    !Slovenia!
8,	191,    !Solomon Islands!
8,	192,    !Somalia!
8,	193,    !South Africa!
8,	194,    !South Georgia And The South Sandwich Islands!
8,	195,    !Spain!
8,	196,    !Sri Lanka!
8,	197,    !St. Helena!
8,	198,    !St. Pierre And Miquelon!
8,	199,    !Sudan!
8,	200,    !Suriname!
8,	201,    !Svalbard And Jan Mayen Islands!
8,	202,    !Swaziland!
8,	203,    !Sweden!
8,	204,    !Switzerland!
8,	205,    !Syrian Arab Republic!
8,	206,    !Taiwan, Province Of China!
8,	207,    !Tajikistan!
8,	208,    !Tanzania, United Republic Of!
8,	209,    !Thailand!
8,	210,    !Togo!
8,	211,    !Tokelau!
8,	212,    !Tonga!
8,	213,    !Trinidad And Tobago!
8,	214,    !Tunisia!
8,	215,    !Turkey!
8,	216,    !Turkmenistan!
8,	217,    !Turks And Caicos Islands!
8,	218,    !Tuvalu!
8,	219,    !Uganda!
8,	220,    !Ukraine!
8,	221,    !United Arab Emirates!
8,	222,    !United Kingdom!
8,	223,    !United States!
8,	224,    !United States Minor Outlying Islands!
8,	225,    !Uruguay!
8,	226,    !Uzbekistan!
8,	227,    !Vanuatu!
8,	228,    !Vatican City State (Holy See)!
8,	229,    !Venezuela!
8,	230,    !Viet Nam!
8,	231,    !Virgin Islands (British)!
8,	232,    !Virgin Islands (U.S.)!
8,	233,    !Wallis And Futuna Islands!
8,	234,    !Western Sahara!
8,	235,    !Yemen!
8,	236,    !Yugoslavia!
8,	237,    !Zaire!
8,	238,    !Zambia!
8,	239,    !Zimbabwe!
9,	1,	!MIMAS Adminstrators!,		0,	0,	1,	0,	!NULL!,		!System-wide administrators can modify data libraries (e.g. Array Collection), to approve new users, and modify user information!
9,	2,	!MIMAS Curators!,		0,	0,	1,	0,	!NULL!,		!System-wide curators can access all the annotation in the system and review submitted uploads!
9,	3,	!MIMAS Registered Users!,	0,	0,	1,	0,	!NULL!,		!All users of the MIMAS system!
9,	4,	!Lab editors!,			1,	1,	0,	0,	!lab!,		!Group of persons authorized, by default, to modify all annotation submitted from your lab!
9,	5,	!Organization editors!,		1,	1,	0,	0,	!organization!,	!Group of persons authorized, by default, to modify all annotation submitted from your organization!
9,	6,	!Lab readers!,			1,	0,	0,	0,	!lab!,		!Group of persons authorized, by default, to read all annotation submitted from your lab!
9,	7,	!Organization readers!,		1,	0,	0,	0,	!organization!,	!Group of persons authorized, by default, to read all annotation submitted from your organization!
9,	8,	!Lab members!,			0,	0,	0,	1,	!lab!,		!All members of the same lab as you!
9,	9,	!Organization members!,		0,	0,	0,	1,	!organization!,	!All members of the same organization as you!
9,	10,	!User!,				1,	1,	1,	1,	!user!,		!Current user!
9,	12,	!GermOnline managers!,		0,	0,	1,	0,	!NULL!,		!Persons who manage GermOnline external data!
9,	13,	!Facility editors!,		1,	1,	0,	0,	!facility!,	!Group of persons authorized, by default, to modify all annotation submitted for experiments performed at a given facility!
