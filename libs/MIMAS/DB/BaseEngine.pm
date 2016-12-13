# Engine::mysql.pm
# MIMAS Engine-specific base Database Area Class
#
#######################################################
# Copyright 2006 Alexandre Gattiker
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::BaseEngine;

use strict;
use warnings;
use base qw(MIMAS::DB::BaseArea);
use POSIX qw(strftime);


our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $db = shift;
    
    my $self = $class->SUPER::new(-db   => $db,
                                  -name => 'Engine');
    
    return $self;
}

sub dsn {
    my $self = shift;
    my ($driver, $host, $database, $port) = @_;

    my $dsn = "DBI:${driver}:database=${database};host=${host};port=${port}";

    return $dsn;
}

sub after_connection {
    my $self = shift;
    return;
}

sub session {
    my $self = shift;
    my $session_id = shift || undef;
    die "abstract";

}

sub nextval {
    my $self = shift;
    my $sequence = shift;
    die "abstract";
}

sub setval {
    my $self = shift;
    my $sequence = shift;
    my $value = shift;
    die "abstract";
}

sub getLongReadLen {
    my $self = shift;
    my ($method, $statement, @values) = @_;
    return undef;
}

sub decode_varchar {
    my $self = shift;
    my $value = shift;
    return $value;
}

sub decode_clob {
    my $self = shift;
    my $value = shift;
    return $value;
}

sub format_date {
    my $self = shift;
    my $unix_time = shift;
    return strftime("%F", gmtime($unix_time));
}

1;

