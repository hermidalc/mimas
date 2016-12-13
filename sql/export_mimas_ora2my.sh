#!/bin/sh

export NLS_LANG=AMERICAN_AMERICA.AL32UTF8
export NLS_DATE_FORMAT="YYYY-MM-DD HH24:MI:SS"

DUMPDIR=/export01/dump/mysql
HOST=oraserv.vital-it.ch
PORT=1521


read -p "Enter MIMAS password: " PASSWORD

./dunldr \
-database "sid=MIMAS;host=$HOST;port=$PORT" \
-username MIMAS \
-password $PASSWORD \
-owner mimas \
-directory $DUMPDIR \
-mysql \
-schemadump \
-longlen 20000000 \
-lang AMERICAN_AMERICA.AL32UTF8
