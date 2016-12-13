#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../libs";
use MIMAS::DB;
use MIMAS::Utils;
use Data::Dumper;

# Set up Environment
&set_env();

my $mimas_db = MIMAS::DB->new(-service => 'WEB');

# User Working Data Hash
print "\nEnter MIMAS Username: ";
chomp(my $username = <STDIN>);
if ($username ne '') {
    my $user = $mimas_db->User->UserAdaptor->select_by_username_ci($username);
    print "\n\"$username\" Working Data:\n";
    print Dumper($user->working_data), "\n";
}
else {
    # Session Hash
    print "\nEnter Session ID: ";
    chomp(my $session_id = <STDIN>);
    if ($session_id ne '') {
        my $session = $mimas_db->Web->SessionAdaptor->fetch($session_id);
        print "\nSession Data:\n";
        print Dumper($session), "\n";
    }
}

print "\n";
exit;

