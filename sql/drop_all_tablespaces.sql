--# drop_all_tablespaces.sql
--# Drop All MIMAS Tablespaces
--# 
--#######################################################
--# Copyright 2003-2005 Leandro C. Hermida
--# This code is part of MIMAS and is distributed under
--# GNU Public License Version 2.
--#######################################################
--# $Id$

DROP TABLESPACE MIMAS                  INCLUDING CONTENTS AND DATAFILES  CASCADE CONSTRAINTS;
DROP TABLESPACE MIMAS_FILE_DATA        INCLUDING CONTENTS AND DATAFILES  CASCADE CONSTRAINTS;
DROP TABLESPACE MIMAS_TEMP_FILE_DATA   INCLUDING CONTENTS AND DATAFILES  CASCADE CONSTRAINTS;
/* DROP TABLESPACE MIMAS_FILE_DATA_IDXS   INCLUDING CONTENTS AND DATAFILES  CASCADE CONSTRAINTS; */

EXIT;

