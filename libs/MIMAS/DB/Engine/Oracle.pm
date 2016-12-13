# Engine::Oracle.pm
# MIMAS Engine-specific Oracle Database Area Class
#
#######################################################
# Copyright 2006 Alexandre Gattiker
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Engine::Oracle;

use strict;
use warnings;
use base qw(MIMAS::DB::BaseEngine);


use MIMAS::Consts;

our $VERSION = 1.00;



sub dsn {
    my $self = shift;
    my ($driver, $host, $database, $port) = @_;

    my $dsn = "DBI:${driver}:sid=${database};host=${host};port=${port}";

    return $dsn;
}

sub session {
    my $self = shift;
    my $session_id = shift || undef;
    my %session;

    require Apache::Session::Oracle;

    # For some reason, since Apache::Session::Oracle uses "prepare_cached" to fetch the old session, if I change
    # the LongReadLen after the first session fetch, prepare_cached will NOT notice that and gives me
    # the cached sth with a old LongReadLen which then can cause problems with LongReadLen too short for LOB errors!
    # So I bascially cannot do a dynamic LongReadLen and I have to set it to something big at the beginning
    # and hope the session never gets bigger than that.  Apache::Session::Oracle default LongReadLen = 8192

    # If I can't get LongReadLen then it should return undef or 0 which will cause Apache::Session::Oracle to set
    # $dbh->{LongReadLen} = 8192 which is its default (see Apache::Session::Oracle.pm file)

    tie %session, 'Apache::Session::Oracle', $session_id,
    {
        Handle => $self->db->dbh,
        Commit => 0,
        LongReadLen => MIMAS_SESSION_LONGREADLEN,
    };

    return \%session;

}

sub nextval {
    my $self = shift;
    my $sequence = shift;
    my $statement = "SELECT $sequence.NEXTVAL FROM DUAL";
    return $statement;
}

#Does not support concurrency, but there does not seem to be any other way...
#Oracle does not have any setval command, unlike PostgreSQL.
sub setval {
    my $self = shift;
    my $sequence = shift;
    my $value = shift;

    my $dbh = $self->db->dbh;

    my ($curval) = $dbh->selectrow_array("SELECT $sequence.NEXTVAL FROM dual");

    my $shift = $value - $curval;

    $dbh->do("ALTER SEQUENCE $sequence INCREMENT BY $shift MINVALUE 0");
    $dbh->do("SELECT $sequence.NEXTVAL FROM dual");

    $dbh->do("ALTER SEQUENCE $sequence INCREMENT BY 1");

    return;

}

sub getLongReadLen {
    my $self = shift;
    my ($method, $statement, @values) = @_;
    return $self->db->dbh->$method($statement, undef, @values) || 0;
}

sub format_date {
    my $self = shift;
    my $unix_time = shift;
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday) = gmtime($unix_time);
    my $fmt_mon = qw(JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC)[$mon];
    my $fmt_year = 1900+$year;
    my $fmt_day = $mday;
    return "$fmt_day-$fmt_mon-$fmt_year";
}

1;

