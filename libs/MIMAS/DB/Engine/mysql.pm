# Engine::mysql.pm
# MIMAS Engine-specific mysql Database Area Class
#
#######################################################
# Copyright 2006 Alexandre Gattiker
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Engine::mysql;

use strict;
use warnings;
use base qw(MIMAS::DB::BaseEngine);

use Encode;

our $VERSION = 1.00;




sub after_connection {
    my $self = shift;

    #important to have mysql return utf8 strings!
    $self->db->dbh->do("SET NAMES 'utf8'");
}

sub session {
    my $self = shift;
    my $session_id = shift || undef;
    my %session;

    require MIMAS::DB::Engine::mysql::Session;

    tie %session, 'MIMAS::DB::Engine::mysql::Session', $session_id,
    {
        Handle => $self->db->dbh,
        LockHandle => $self->db->dbh,
        TableName => 'mimas_web.sessions',
    };

    return \%session;

}

sub nextval {
    my $self = shift;
    my $sequence = shift;
    my $statement1 = "UPDATE $sequence SET id=LAST_INSERT_ID(id+1);";
    $self->db->dbh->do($statement1);
    my $statement = "SELECT LAST_INSERT_ID();";
    return $statement;
}

sub setval {
    my $self = shift;
    my $sequence = shift;
    my $value = shift;
    my $statement = "UPDATE $sequence SET id=?";
    $self->db->dbh->do($statement, {}, $value);
    return;

}





#With Oracle as well as mysql, CLOB/TEXT values are returned as strings, so no treatment
#should be necessary. But the DBD::mysql driver does not set perl 5.8's "utf8" flag correctly.
#(See http://www.mail-archive.com/dbi-dev@perl.org/msg04319.html)
#(See http://www.simplicidade.org/notes/archives/2005/12/utf8_and_dbdmys.html)
#so for mysql we need to set the utf8 flag on ourselves.
sub decode_varchar {
    my $self = shift;
    my $value = shift;
    if (! Encode::is_utf8($value)) {
        $value = Encode::decode("utf8", $value, Encode::FB_CROAK);
    }
    return $value;
}

sub decode_clob {
    my $self = shift;
    return $self->decode_varchar(@_);
}


