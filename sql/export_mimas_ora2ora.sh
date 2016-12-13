#!/bin/sh

export NLS_LANG=AMERICAN_AMERICA.AL32UTF8
export NLS_DATE_FORMAT="DD-MON-YYYY HH24:MI:SS"

DUMPDIR=/export01/dump/oracle

read -p "Enter MIMAS password: " PASSWORD

dunldr -database mimas -username MIMAS -password $PASSWORD \
-owner mimas \
-directory $DUMPDIR \
-schemadump \
-longlen 20000000 \
-lang AMERICAN_AMERICA.AL32UTF8 \
-rs "|\n" \
-lobcol up_sample_file_data=contents \
-lobcol up_sample_attribute=char_value \
-lobcol up_exp_attribute=char_value \
-lobcol mimas_user=working_data \
