#!/usr/bin/env bash

# Sample script for installing Apache 1 with mod_perl as required for MIMAS. 

# Directory where the source will be unpacked and compilation will take place
SRC_DIR=/tmp

# Directory for the apache installation (all under 1 directory)
INST_DIR=`dirname \`dirname $PWD\``/mimas-work/apache

cd $SRC_DIR
wget -nc http://archive.apache.org/dist/httpd/apache_1.3.41.tar.gz || true
wget -nc http://www.cpan.org/modules/by-module/Apache/mod_perl-1.30.tar.gz || true
tar zxf apache_1.3.41.tar.gz
tar zxf mod_perl-1.30.tar.gz

cd mod_perl-1.30
perl Makefile.PL PREFIX=$INST_DIR APACHE_SRC=../apache_1.3.41/src NO_HTTPD=1 USE_APACI=1 PREP_HTTPD=1 EVERYTHING=1
make install
cd ..

cd apache_1.3.41
./configure \
"--with-layout=Apache" \
"--activate-module=src/modules/perl/libperl.a" \
"--disable-rule=EXPAT" \
"--enable-module=perl" \
"--enable-module=include" \
"--enable-module=rewrite" \
"--enable-module=status" \
"--enable-module=so" \
"--prefix=$INST_DIR" \

make install
cd ..

echo Now edit $INST_DIR/bin/apachectl
echo Set HTTPD= line as follows:
echo HTTPD="$INST_DIR/bin/httpd -f path..to..mimas/startup/<configname>.conf"
echo Then use apachectl to start MIMAS.

