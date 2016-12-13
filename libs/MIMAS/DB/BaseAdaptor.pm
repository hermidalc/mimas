# BaseAdaptor.pm
# MIMAS Base Class for all Adaptor Classes
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::BaseAdaptor;

use strict;
use warnings;
use Scalar::Util qw(weaken);
use MIMAS::Utils qw(get_caller_name);
use MIMAS::DB::SQL;
use base qw(Root);
use Encode qw(is_utf8 decode);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    my $self  = { };
    bless $self, $class;
    
    my $order = [qw( AREA
                     NAME )];
    
    # Arguments
    my ($area, $name) = $self->rearrange_params($order, @_);
    
    $self->area($area);
    $self->name($name);
    
    return $self;
}


sub area {
    my $self = shift;
    # Weaken reference to area object because it has a circular reference back to this adaptor
    &weaken($self->{area} = shift) if @_;
    return $self->{area};
}


sub name {
    my $self = shift;
    $self->{name} = shift if @_;
    return $self->{name};
}


# use with MySQL only!!
# don't ever use dbh->{mysql_insertid} because we are in a mod_perl, Apache::DBI environment and connections are shared
# so you might NOT get the autoincrement insertid for the insert you just did!
sub mysql_insertid {
    my $self = shift;
    $self->throw('The "mysql_insertid" method is only available for MySQL drivers') unless uc($self->area->db->driver) eq 'MYSQL';
    return $self->sth->{mysql_insertid};
}


#With Oracle as well as mysql, CLOB/TEXT values are returned as strings, so no treatment
#should be necessary. But the DBD::mysql driver does not set perl 5.8's "utf8" flag correctly.
#(See http://www.mail-archive.com/dbi-dev@perl.org/msg04319.html)
#(See http://www.simplicidade.org/notes/archives/2005/12/utf8_and_dbdmys.html)
#so for mysql we need to set the utf8 flag on ourselves.
sub decode_varchar {
    my $self = shift;
    return $self->area->db->Engine->decode_varchar(@_);
}

sub decode_clob {
    my $self = shift;
    return $self->area->db->Engine->decode_clob(@_);
}


sub sth {
    my $self = shift;
    $self->{sth} = shift if @_;
    return $self->{sth};
}


sub db_init_fetch {
    my $self = shift;
    
    # Arguments
    my @values = @_;
    my $query  = &get_caller_name();
    
                                                                                                                            # SELECT SQL HASH
    $self->throw("SQL Select lookup tree '@{[$self->area->name]}->@{[$self->name]}->$query' doesn't exist!") unless defined $Selects->{$self->area->name}                and
                                                                                                                    defined $Selects->{$self->area->name}->{$self->name} and
                                                                                                                    defined $Selects->{$self->area->name}->{$self->name}->{$query};
    
    my $statement = $Selects->{$self->area->name}->{$self->name}->{$query}->{sql};
    $self->throw("SQL Select statement '$query' doesn't exist!") unless defined $statement;
    
    # if we need to build the number of placeholders from @values
    if ($statement =~ m/#/) {
        my $placeholder_str = join(',', ('?') x @values);
        $statement =~ s/#/$placeholder_str/;
    }
    
    # check that scalar @values == number of placeholders (?)
    my @placeholders = $statement =~ m/\?/g;
    $self->throw('Number of placeholders not equal to number of bind values!') if scalar @placeholders != scalar @values;
    
    # Calculate LongReadLen attribute before sth prepare if this is a table with a LONG/LOB column.
    # If statement returns 'undef' (which means there is only NULL data in the LONG/LOB column) then set
    # LongReadLen = 0 which will cause DBI to not automatically fetch any LONG/LOB fields and 
    # will return 'undef' for any LONG/LOB field if they exist
    if ($self->area->db->Engine->has_LongReadLen and defined $Selects->{$self->area->name}->{$self->name}->{$query}->{LongReadLen}) {
        my $statement = $Selects->{$self->area->name}->{$self->name}->{$query}->{LongReadLen}->{sql};
        my $method    = $Selects->{$self->area->name}->{$self->name}->{$query}->{LongReadLen}->{method};
        $self->area->db->dbh->{LongReadLen} = $self->area->db->Engine->getLongReadLen($method, $statement, @values);
    }
    
    # I don't use "prepare_cached" for select statement sths because it is known to have a "misfeature" and doesn't obey changed LongReadLen 
    # and possibly other important dbh attributes and will give return an old sth with the correct SQL statement but not the correct attributes!
    $self->sth($self->area->db->dbh->prepare($statement));
    
    return $self->sth->execute(@values);
}


sub db_select {
    my $self = shift;
    
    # Arguments
    my @values = @_;
    my $query  = &get_caller_name();
    
                                                                                                                            # SELECT SQL HASH
    $self->throw("SQL Select lookup tree '@{[$self->area->name]}->@{[$self->name]}->$query' doesn't exist!") unless defined $Selects->{$self->area->name}                and
                                                                                                                    defined $Selects->{$self->area->name}->{$self->name} and
                                                                                                                    defined $Selects->{$self->area->name}->{$self->name}->{$query};

    my $statement;
    if ( my $psequence = $Selects->{$self->area->name}->{$self->name}->{$query}->{sequence} ) {
        my $sequence = $psequence->[0];
        $statement = $self->area->db->Engine->nextval($sequence);
    }
    else {
        $statement = $Selects->{$self->area->name}->{$self->name}->{$query}->{sql};
        $self->throw("SQL Select statement '$query' doesn't exist!") unless defined $statement;
    }
    
    # if we need to build the number of placeholders from @values
    if ($statement =~ m/#/) {
        my $placeholder_str = join(',', ('?') x @values);
        $statement =~ s/#/$placeholder_str/;
    }
    
    # check that scalar @values == number of placeholders (?)
    my @placeholders = $statement =~ m/\?/g;
    $self->throw('Number of placeholders not equal to number of bind values!') if scalar @placeholders != scalar @values;
    
    # Calculate LongReadLen attribute before sth prepare if this is a table with a LONG/LOB column.
    # If statement returns 'undef' (which means there is only NULL data in the LONG/LOB column) then set
    # LongReadLen = 0 which will cause DBI to not automatically fetch any LONG/LOB fields and 
    # will return 'undef' for any LONG/LOB field if they exist
    if (defined $Selects->{$self->area->name}->{$self->name}->{$query}->{LongReadLen}) {
        my $statement = $Selects->{$self->area->name}->{$self->name}->{$query}->{LongReadLen}->{sql};
        my $method    = $Selects->{$self->area->name}->{$self->name}->{$query}->{LongReadLen}->{method};
       	my $longReadLen = $self->area->db->Engine->getLongReadLen($method, $statement, @values);
        $self->area->db->dbh->{LongReadLen} = $longReadLen if defined $longReadLen;
    }
    
    # I don't use "prepare_cached" for select statement sths because it is known to have a "misfeature" and doesn't obey changed LongReadLen 
    # and possibly other important dbh attributes and will give return an old sth with the correct SQL statement but not the correct attributes!
    $self->sth($self->area->db->dbh->prepare($statement));
    
    my $method    = $Selects->{$self->area->name}->{$self->name}->{$query}->{method};
    my $key_field = $Selects->{$self->area->name}->{$self->name}->{$query}->{keyfield} || undef;
    my $attrs     = $Selects->{$self->area->name}->{$self->name}->{$query}->{attrs}    || undef;
    
    # DBI select: dbh->method(sth, [[key_field], attrs, bind_values])
    my @arguments;
    push @arguments, $self->sth;
    push @arguments, $key_field if defined $key_field;
    push @arguments, $attrs     if defined $attrs or @values;
    push @arguments, @values    if @values;
    
    return $self->area->db->dbh->$method(@arguments);
}


sub fix_sequences {
    my $self = shift;
    
    for my $area (keys %$Selects) {
        for my $name (keys %{$Selects->{$area}}) {
            for my $query (keys %{$Selects->{$area}->{$name}}) {
                my $psequence = $Selects->{$area}->{$name}->{$query}->{sequence} or next;
                my $sequence = $psequence->[0];
                my $sequence_source = $psequence->[1] or next;
                my $statement0 = "SELECT $sequence_source";
    
                $self->sth($self->area->db->dbh->prepare($statement0));
                my ($val) = $self->area->db->dbh->selectrow_array($self->sth);

                my $statement = $self->area->db->Engine->setval($sequence, $val);
            }
        }

    }
}


sub db_insert {
    my $self = shift;
    
    my $order = [qw( VALUES )];
    
    # Arguments
    my ($values) = $self->rearrange_params($order, @_);
                                                                                                                    # INSERT SQL HASH
    $self->throw("SQL Insert lookup tree '@{[$self->area->name]}->@{[$self->name]}' doesn't exist!") unless defined $Inserts->{$self->area->name} and
                                                                                                            defined $Inserts->{$self->area->name}->{$self->name};
    
    my $statement = $Inserts->{$self->area->name}->{$self->name}->{sql};
    $self->throw("SQL Insert statement doesn't exist!") unless defined $statement;
    
    my @values = (defined $values and ref($values) eq 'ARRAY') ? @{$values} : ();
    
    # check that scalar @values = number of placeholders (?)
    my @placeholders = $statement =~ m/\?/g;
    $self->throw('Number of placeholders not equal to number of bind values!') if scalar @placeholders != scalar @values;
    
    # prepare and bind parameters
    $self->sth($self->area->db->dbh->prepare_cached($statement));
    for my $i (0 .. $#placeholders) {
        # DBI: sth->bind_param(p_num, bind_value, [bind_type])
        my @arguments;
        push @arguments, ($i + 1, $values[$i]);
        push @arguments, $Inserts->{$self->area->name}->{$self->name}->{bind_types}->[$i] if defined $Inserts->{$self->area->name}->{$self->name}->{bind_types} and
                                                                                             defined $Inserts->{$self->area->name}->{$self->name}->{bind_types}->[$i];
        $self->sth->bind_param(@arguments);
    }
    
    return $self->sth->execute;
}


sub db_update {
    my $self = shift;
    
    my $order = [qw( SET_PARAMS
                     QUAL_PARAMS )];
    
    my ($set_params, $qual_params) = $self->rearrange_params($order, @_);
                                                                                                                    # UPDATE SQL HASH
    $self->throw("SQL Update lookup tree '@{[$self->area->name]}->@{[$self->name]}' doesn't exist!") unless defined $Updates->{$self->area->name} and
                                                                                                            defined $Updates->{$self->area->name}->{$self->name};
    
    # Parse, check, and cleanup fields
    $self->throw('Incomplete SET name/value pairs!')       if scalar @{$set_params}  % 2 != 0;
    $self->throw('Incomplete QUALIFIER name/value pairs!') if scalar @{$qual_params} % 2 != 0;
    
    my $db_set_fields  = $Updates->{$self->area->name}->{$self->name}->{set_fields};
    my $db_qual_fields = $Updates->{$self->area->name}->{$self->name}->{qual_fields};
    $self->throw("SQL Update qualifier and/or set fields don't exist!") unless defined $db_set_fields and 
                                                                               defined $db_qual_fields;
    my (%db_set_fields, %db_qual_fields);
    $db_set_fields{$_}++  for @{$db_set_fields};
    $db_qual_fields{$_}++ for @{$db_qual_fields};
    undef $db_set_fields;
    undef $db_qual_fields;
    
    for (my $i = 0; $i < $#{$set_params}; $i += 2) {
        $set_params->[$i] =~ s/^-//;
        $set_params->[$i] =~ tr/A-Z/a-z/;
        $self->throw("Bad set field name '$set_params->[$i]' used in database update!") unless $db_set_fields{$set_params->[$i]};
    }
    for (my $i = 0; $i < $#{$qual_params}; $i += 2) {
        $qual_params->[$i] =~ s/^-//;
        $qual_params->[$i] =~ tr/A-Z/a-z/;
        $self->throw("Bad qualifier field name '$qual_params->[$i]' used in database update!") unless $db_qual_fields{$qual_params->[$i]};
    }
    
    my %set_params  = @{$set_params};
    my %qual_params = @{$qual_params};
    undef $set_params;
    undef $qual_params;
    
    my $table     = $Updates->{$self->area->name}->{$self->name}->{table};
    my $set       = 'SET ' . join(', ', map("$_ = ?", keys %set_params));
    my $qualifier = %qual_params ? 'WHERE ' . join(' AND ', map("$_ = ?", keys %qual_params)) : '';
    my $statement = "UPDATE $table $set $qualifier";
    
    # prepare and bind parameters
    my $p_num = 1;
    $self->sth($self->area->db->dbh->prepare_cached($statement));
    for my $set_field (keys %set_params) {
        # DBI: sth->bind_param(p_num, bind_value, [bind_type])
        my @arguments;
        push @arguments, ($p_num++, $set_params{$set_field});
        push @arguments, $Updates->{$self->area->name}->{$self->name}->{bind_types}->{$set_field} if defined $Updates->{$self->area->name}->{$self->name}->{bind_types} and
                                                                                                     defined $Updates->{$self->area->name}->{$self->name}->{bind_types}->{$set_field};
        $self->sth->bind_param(@arguments);
    }
    for my $qual_field (keys %qual_params) {
        $self->sth->bind_param($p_num++, $qual_params{$qual_field});
    }
    
    return $self->sth->execute;
}


sub db_delete {
    my $self = shift;
    
    my $order = [qw( VALUES )];
    
    my ($values) = $self->rearrange_params($order, @_);
    my $delete   = &get_caller_name();
                                                                                                                             # DELETE SQL HASH
    $self->throw("SQL Delete lookup tree '@{[$self->area->name]}->@{[$self->name]}->$delete' doesn't exist!") unless defined $Deletes->{$self->area->name}                and
                                                                                                                     defined $Deletes->{$self->area->name}->{$self->name} and
                                                                                                                     defined $Deletes->{$self->area->name}->{$self->name}->{$delete};
    
    my $statement = $Deletes->{$self->area->name}->{$self->name}->{$delete}->{sql};
    $self->throw("SQL Delete statement '$delete' doesn't exist!") unless defined $statement;
    
    my @values = (defined $values and ref($values) eq 'ARRAY') ? @{$values} : ();
    
    # if we need to build the number of placeholders from @values
    if ($statement =~ m/#/) {
        my $placeholder_str = join(',', ('?') x @values);
        $statement =~ s/#/$placeholder_str/;
    }
    
    # check that scalar @values = number of placeholders (?)
    my @placeholders = $statement =~ m/\?/g;
    $self->throw('Number of placeholders not equal to number of bind values!') if scalar @placeholders != scalar @values;
    
    $self->sth($self->area->db->dbh->prepare_cached($statement));
    
    return $self->sth->execute(@values);
}


1;

