# Handlers.pm
# MIMAS Apache mod_perl Handlers
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::Apache::Handlers;

use strict;
use warnings;
use Apache::Constants qw(DECLINED);
use Apache::URI ();
use MIMAS::Consts qw(MIMAS_SCRIPT_URL_PATH);

our $VERSION = 1.00;


sub TransHandler {
    my $r = shift;
    
    my $script_name = pop @{[split /\//, $r->parsed_uri->path, -1]};
    
    $r->uri(MIMAS_SCRIPT_URL_PATH . $script_name) unless -e $r->document_root . $r->parsed_uri->path;

    #Translate URIs to add the /perl directory prefix
    #Exceptions: 
    #/downloads = serves zip file downloads
    #/server-status and /server-info = generic Apache status pages
    $r->uri($r->parsed_uri->path) if $r->parsed_uri->path =~ m!^/+(downloads|server)!;

    return DECLINED;
}


1;

