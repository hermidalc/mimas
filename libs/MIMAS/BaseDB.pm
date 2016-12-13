# BaseDB.pm
# MIMAS Base Class for all Database Objects
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::BaseDB;

use strict;
use warnings;
use DBI;
use base qw(Root);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    my $self  = { };
    bless $self, $class;
    
    my $order = [qw( DRIVER
		     HOST
		     DATABASE
		     PORT
		     USER
		     PASSWORD )];
    
    # Arguments
    my ($driver, $host, $database, $port, $user, $password) = $self->rearrange_params($order, @_);

    $self->driver($driver);

    my $data_source = $self->Engine->dsn($driver, $host, $database, $port);

    $self->throw("Invalid database driver!: $driver") unless $data_source;
    
    # DBI connection attributes
    my $attrs = { PrintError => 0, RaiseError => 1, AutoCommit => 0, FetchHashKeyName => 'NAME_lc', LongTruncOk => 0 };
    
    my $dbh = DBI->connect($data_source, $user, $password, $attrs)
      or $self->throw("Cannot connect to database [$database] as user [$user]: $DBI::errstr");
    
    $self->dbh($dbh);

    $self->Engine->after_connection();
    
    return $self;
}


sub dbh {
    my $self = shift;
    $self->{dbh} = shift if @_;
    return $self->{dbh};
}


sub driver {
    my $self = shift;
    $self->{driver} = shift if @_;
    return $self->{driver};
}


sub commit {
    my $self = shift;
    $self->{dbh}->commit;
}


sub rollback {
    my $self = shift;
    $self->{dbh}->rollback;
}


sub disconnect {
    my $self = shift;
    $self->{dbh}->rollback;
    $self->{dbh}->disconnect;
}


# only used internally
sub _get_area {
    my $self = shift;
    
    # Arguments
    my ($module, @args) = @_;
    
    eval "require $module";
    $self->throw("Database Area Module [$module] load error: $@") if $@;
    
    my $area = $module->new($self, @args);
    
    return $area;
}


sub Engine {
    my $self = shift;
    my $driver = $self->driver;
    $self->{areas}->{Engine} = $self->_get_area("MIMAS::DB::Engine::$driver") unless defined $self->{areas}->{Engine};
    return $self->{areas}->{Engine};
}


sub DESTROY {
    my $self = shift;
    
    if (defined $self->{dbh}) {
        $self->disconnect;
	$self->{dbh} = undef;
	
	# print STDERR "DISCONNECTED FROM DATABASE\n";
    }
    
    # print STDERR "DESTROYED BASEDB OBJECT\n";
}


1;

