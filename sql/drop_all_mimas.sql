--# drop_all_mimas.sql
--# Drop MIMAS Database
--# 
--#######################################################
--# Copyright 2003-2005 Leandro C. Hermida
--# This code is part of MIMAS and is distributed under
--# GNU Public License Version 2.
--#######################################################
--# $Id$

-- Drop MIMAS Database
DROP USER mimas      CASCADE;
DROP USER mimas_web  CASCADE;
DROP USER mimas_read;

EXIT;

