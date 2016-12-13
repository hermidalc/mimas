#!/usr/bin/perl

# import_affy_cdf_libs.pl
# MIMAS Affymetrix CDF Library Import Script
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

use strict;
use warnings;
use DBI;
use DBD::Oracle qw(:ora_types);
use File::Basename;

# Set up Environment
&set_env();

&fileparse_set_fstype('Unix');


print "\n" x 2,
'
------------------------------------------------------------------
|/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\|
|\/\/\/        AFFYMETRIX CDF LIBRARY MIMAS IMPORT        /\/\/\/|
|/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\|
------------------------------------------------------------------
';

my $srcdir = @ARGV ? shift @ARGV : $ENV{PWD};
die "\nSource files location is not a directory!\n\n" unless -d $srcdir;
die "\nNo CDF files found in '$srcdir' directory!\n\n"  unless glob "$srcdir/*.{CDF,cdf}";
$srcdir =~ s/\/$//;


print "\nPlease select host:\n> ";
chomp(my $host = <STDIN>);
print '----------> Oracle instance SID: ';
chomp(my $sid = <STDIN>);
print '----------> User name: ';
chomp(my $username = <STDIN>);
system('stty -echo') == 0 or die "Could not hide shell echo: " . $? >> 8 . "\n";
print '----------> Password: ';
chomp(my $password = <STDIN>);
system('stty echo') == 0 or die "Could not unhide shell echo: " . $? >> 8 . "\n";


my $attrs = { PrintError => 0, RaiseError => 1, AutoCommit => 0, FetchHashKeyName => 'NAME_lc', LongTruncOk => 0 };

my $dbh = DBI->connect("DBI:Oracle:host=${host};sid=${sid}", $username, $password, $attrs)
  or die "\nUnable to connect to MIMAS Repository!: $DBI::errstr\n";

# ------------------------------------------------------------------------------------------------------------------------------ #

# Sequences
my @cdf_sequences = qw(  seq_library  
                         seq_array_feature  );
my %cdf_sequences;
$cdf_sequences{$_}++ for @cdf_sequences;
undef @cdf_sequences;

# Tables
my @cdf_tables = qw(  array_series 
                      array  
		      array_feature  );
my %cdf_tables;
$cdf_tables{$_}++ for @cdf_tables;
undef @cdf_tables;

# Constraints (to be disabled/enabled for loading)
my %cdf_constraints = (
  
  # pk_array_feature_id      => {
  #                               table_name   => 'array_feature'
  # 			        },
  
  fk_array_id              => {
                                table_name   => 'array_feature'
			      },
  ck_match_type            => {
                                table_name   => 'array_feature'
			      }
);

# Indexes (to be dropped/recreated for loading)
my %cdf_indexes = (
  
  # ndx_array_id      => {
  #                        table_name   => 'array_feature',
  # 			   column_name  => 'array_id'
  # 		         },
  # ndx_x             => {
  #                        table_name   => 'array_feature',
  # 			   column_name  => 'x'
  # 		         },
  # ndx_y             => {
  #                        table_name   => 'array_feature',
  #  			   column_name  => 'y'
  # 		         }
  
  ndx_array_id_x_y    => {
                           table_name   => 'array_feature',
			   column_name  => 'array_id, x, y'
			 },
  ndx_name_pos_type   => {
                           table_name   => 'array_feature',
			   column_name  => 'probeset_name, feature_pos, match_type'
			 }
);

# ------------------------------------------------------------------------------------------------------------------------------ #

# Get CDF database information from Data Dictionary

my %db_sequences   = %{$dbh->selectall_hashref('SELECT   LOWER(sequence_name) as sequence_name, 1 
                                                FROM     user_sequences',                           'sequence_name'   )};

my %db_tables      = %{$dbh->selectall_hashref('SELECT   LOWER(table_name) as table_name, 1
                                                FROM     user_tables',                              'table_name'      )};

my %db_constraints = %{$dbh->selectall_hashref('SELECT   LOWER(constraint_name) as constraint_name, 
                                                         LOWER(table_name) as table_name
                                                FROM     user_constraints',                         'constraint_name' )};

my %db_indexes     = %{$dbh->selectall_hashref('SELECT   LOWER(index_name) as index_name, 
                                                         LOWER(table_name) as table_name
                                                FROM     user_indexes',                             'index_name'      )};

my $errors;
my $pad_length = 70;
my $pad_char   = '.';

print "\nChecking database sequences:\n";
for my $sequence_name (sort keys %cdf_sequences) {
    print "\t\U$sequence_name\E", $pad_char x ($pad_length - length $sequence_name);
    if (defined $db_sequences{$sequence_name}) {
        print "OK\n";
    } else {
        print "ERROR!  Does not exist!\n";
	$errors++;
    }
}

print "\nChecking database tables:\n";
for my $table_name (sort keys %cdf_tables) {
    print "\t\U$table_name\E", $pad_char x ($pad_length - length $table_name);
    if (defined $db_tables{$table_name}) {
        print "OK\n";
    } else {
        print "ERROR!  Does not exist!\n";
	$errors++;
    }
}

print "\nChecking database constraints:\n";
for my $constraint_name (sort keys %cdf_constraints) {
    print "\t\U$constraint_name\E", $pad_char x ($pad_length - length $constraint_name);
    if (defined $db_constraints{$constraint_name}) {
        if ($db_constraints{$constraint_name}->{table_name} eq $cdf_constraints{$constraint_name}->{table_name}) {
	    print "OK\n";
	} else {
	    print "ERROR!  Constraint applied to table [\U$db_constraints{$constraint_name}->{table_name}\E] " . 
	          "which is not the required table [\U$cdf_constraints{$constraint_name}->{table_name}\E]\n";
	    $errors++;
	}
    } else {
        print "ERROR!  Does not exist!\n";
	$errors++;
    }
}

print "\nChecking database indexes:\n";
for my $index_name (sort keys %cdf_indexes) {
    print "\t\U$index_name\E", $pad_char x ($pad_length - length $index_name);
    if (defined $db_indexes{$index_name}) {
        if ($db_indexes{$index_name}->{table_name} eq $cdf_indexes{$index_name}->{table_name}) {
	    print "OK\n";
	} else {
	    print "ERROR!  Index applied to table [\U$db_indexes{$index_name}->{table_name}\E] " . 
	          "which is not the required table [\U$cdf_indexes{$index_name}->{table_name}\E]\n";
            $errors++;
	}
    } else {
        print "ERROR!  Does not exist!\n";
	$errors++;
    }
}

if ($errors) {
    warn "\nErrors in MIMAS Repository Array Library database.  Please correct these errors and re-attempt import!\n\n";
    eval { $dbh->rollback };
    $dbh->disconnect;
    exit;
}

# ------------------------------------------------------------------------------------------------------------------------------ #

eval {
    print "\nDropping indexes:\n";
    for my $index_name (sort keys %cdf_indexes) {
        print "\t\U$index_name\E", $pad_char x ($pad_length - length $index_name);
        $dbh->do("DROP INDEX $index_name");
        print "DROPPED\n";
    }
    
    print "\nDisabling constraints:\n";
    for my $constraint_name (sort keys %cdf_constraints) {
        print "\t\U$constraint_name\E", $pad_char x ($pad_length - length $constraint_name);
        if ($constraint_name =~ /^PK_/i) {
            $dbh->do("ALTER TABLE $cdf_constraints{$constraint_name}->{table_name} DISABLE PRIMARY KEY");
        } else {
	    $dbh->do("ALTER TABLE $cdf_constraints{$constraint_name}->{table_name} DISABLE CONSTRAINT $constraint_name");
	}
	print "DISABLED\n";
    }
};

if ($@) {
    warn "\nMIMAS Repository Array Library database error:\n$@\n";
    eval { $dbh->rollback };
    $dbh->disconnect;
    exit;
}

# ------------------------------------------------------------------------------------------------------------------------------ #

print "\nMIMAS Repository Array Library tables & relationships ready.\n";

my %sths;

$sths{seq_library}      = $dbh->prepare('SELECT    seq_library.NEXTVAL
                                         FROM      DUAL');

$sths{array_serieses}   = $dbh->prepare('SELECT    *
                                         FROM      array_series');

$sths{check_array}      = $dbh->prepare('SELECT    *
                                         FROM      array
				         WHERE     cdf_name = ?');

$sths{check_features}   = $dbh->prepare('SELECT    COUNT(*)
                                         FROM      array_feature
					 WHERE     array_id = ?');

$sths{update_array}     = $dbh->prepare('UPDATE    array
                                         SET       alt_name = ?, version = ?, num_probesets = ?
					 WHERE     array_id = ?');

$sths{insert_series}    = $dbh->prepare('INSERT INTO array_series  (array_series_id, name, display_name, manufacturer, type)
                                         VALUES                    (?, ?, ?, ?, ?)');

$sths{insert_array}     = $dbh->prepare('INSERT INTO array         (array_id, design_name, cdf_name, alt_name, version, num_probesets, array_series_id)
                                         VALUES                    (?, ?, ?, ?, ?, ?, ?)'); 

$sths{insert_feature}   = $dbh->prepare('INSERT INTO array_feature (array_feature_id, probeset_name, x, y, feature_pos, match_type, array_id)
                                         VALUES                    (seq_array_feature.NEXTVAL, ?, ?, ?, ?, ?, ?)');

# ------------------------------------------------------------------------------------------------------------------------------ #

for my $filespec (glob "$srcdir/*.{CDF,cdf}") {
    my ($filebase, undef, $file_ext) = &fileparse($filespec, qr/\.CDF/i);
    my $alt_name = $filebase;
    
    my ($header, $block_str, $version, $array_id, $probeset_count, $feature_import_count);
    
    eval {
        open(CDFFILE, "$filespec") or die "Could not open ${filebase}${file_ext}: $!";
        print "\nParsing and importing ${filebase}${file_ext}:\n";
        while (<CDFFILE>) {
            if (m/^\[(\w+)\]\s*$/ or eof) {
                if ($block_str) {
                    my $next_header = $1;
                    my %block_data = ( $block_str =~ /^(.+?)=(.*?)$/gm );
	            s/\s+$// for values %block_data;     # DOS file has \r\n at end of each line
	            
		    # CDF Header Information
		    if ( $header =~ /^CDF$/i ) {
	                $version = $block_data{Version};
	            }
		    
		    # CDF Chip Information
		    elsif ( $header =~ /^Chip$/i ) {
	                if ($version and $alt_name) {
			    my $array_name    = $block_data{Name};
			    my $num_probesets = $block_data{NumberOfUnits};
			    
			    my $existing_array = $dbh->selectrow_hashref($sths{check_array}, undef, $array_name);
			    if (defined $existing_array) {
			        print "\tArray '$array_name' exists in MIMAS Array Library.\n";
			        $array_id = $existing_array->{array_id};
			        my $existing_cdflib = $dbh->selectrow_array($sths{check_features}, undef, $array_id);
				die "CDF Library feature information already exists in repository." if $existing_cdflib;
				
				$sths{update_array}->execute($alt_name, $version, $num_probesets, $array_id) unless defined $existing_array->{alt_name} and
				                                                                                    defined $existing_array->{version}  and
														    defined $existing_array->{num_probesets};
			    } else {
			        my $serieses = $dbh->selectall_hashref($sths{array_serieses}, 'array_series_id');
				print "\tArray '$array_name' does not exist in MIMAS Array Library.\n",
				      "\tPlease select the appropriate array series ID for this CDF file or type 'NEW':\n";
                                for my $series_id (sort { $a <=> $b } keys %{$serieses}) {
				        my $space = $series_id < 10 ? ' ' : '';
				        print "\t\t$space\[$series_id\]\t$serieses->{$series_id}->{name}\n";
				}
				
				my $series_id;
				my $good_series = 0;
				until ($good_series) {
				    print "\n\t> ";
				    chomp(my $answer = <STDIN>);
				    if (defined $serieses->{$answer}) {
				        $series_id = $answer;
					$good_series++;
				    } elsif ($answer =~ /^new$/i) {
				        print "\t----------> Series Name: ";
					my $series_name = <STDIN>;
					for ($series_name) { s/^\s+//; s/\s+$//; s/\s+/ /g; }
					print "\t----------> Series Full Display Name: ";
					my $display_name = <STDIN>;
					for ($display_name) { s/^\s+//; s/\s+$//; s/\s+/ /g; }
					print "\t----------> Manufacturer [Affymetrix]: ";
					my $manufacturer = <STDIN>;
					for ($manufacturer) { s/^\s+//; s/\s+$//; s/\s+/ /g; }
					$manufacturer = 'Affymetrix' if $manufacturer =~ /^\s*$/;
					print "\t----------> Series Type [Affymetrix]: ";
					my $type = <STDIN>;
					for ($type) { s/^\s+//; s/\s+$//; s/\s+/ /g; }
					$type = 'Affymetrix' if $type =~ /^\s*$/;
					
					$series_id = $dbh->selectrow_array($sths{seq_library});
					$sths{insert_series}->execute($series_id, $series_name, $display_name, $manufacturer, $type);
					
					$good_series++;
				    } else {
				        print "\tPlease type in an array series ID or 'NEW':\n";
				    }
				}
				
				print "\t----------> Array Design Name: ";
				my $design_name = <STDIN>;
				for ($design_name) { s/^\s+//; s/\s+$//; s/\s+/ /g; }
				
				$array_id = $dbh->selectrow_array($sths{seq_library});
				$sths{insert_array}->execute($array_id, $design_name, $array_name, $alt_name, $version, $num_probesets, $series_id);
				print "\n";
			    }
		        } else {
		            die "CDF file header information not properly acquired.  Check CDF file.";
		        }
	            }
		    
		    # QC Section
		    elsif ( $header =~ /^QC\d+$/i ) {
		        my @field_names = split /\t/, $block_data{CellHeader}, -1;
		        my %field_pos;
		        for my $i (0 .. $#field_names) { $field_pos{$field_names[$i]} = $i }
		        
		        my $cell_count = 0;
	                for (sort keys %block_data) {     # sort so that I go from Cell01 --> CellNN in order
		            if ( m/^Cell\d+$/i ) {
		                my @field_data = split /\t/, $block_data{$_}, -1;
			        
			        $sths{insert_feature}->execute($header,
				                               $field_data[$field_pos{X}],
							       $field_data[$field_pos{Y}],
				                               $field_data[$field_pos{ATOM}],
						               'QC',
							       $array_id);
				$cell_count++;
			    }
		        }
		        
		        die "Number of cells imported [$cell_count] in $header section not equal to ",
		            "file NumberCells spec [$block_data{NumberCells}]." unless $block_data{NumberCells} == $cell_count;
		        
		        print "\t$header features imported [$cell_count cells].\n"; 
		    }
		    
		    #
		    # Probeset Supersection
		    # elsif ( $header =~ /^Unit\d+$/i ) {
	            #    # do nothing right now -- supersection gives no information
		    # }
	     
	            # Probeset Section
		    elsif ( $header =~ /^Unit\d+_Block\d+$/i ) {
		        my @field_names = split /\t/, $block_data{CellHeader}, -1;
		        my %field_pos;
		        for my $i (0 .. $#field_names) { $field_pos{$field_names[$i]} = $i }
	                
	                my $cell_count = 0;
	                for (sort keys %block_data) {     # sort so that I go from Cell01 --> CellNN in order
		            if ( m/^Cell\d+$/i ) {
		                my @field_data = split /\t/, $block_data{$_}, -1;
			        
				my $match_type = (($field_data[$field_pos{CBASE}] eq $field_data[$field_pos{PBASE}]) and 
			                          ($field_data[$field_pos{CBASE}] eq $field_data[$field_pos{TBASE}])) ? 'PM' : 'MM';
						   
			        $sths{insert_feature}->execute($block_data{Name},
				                               $field_data[$field_pos{X}],
							       $field_data[$field_pos{Y}],
				                               $field_data[$field_pos{EXPOS}],
							       $match_type,
							       $array_id);
			        $cell_count++;
			        $feature_import_count++;
		            }
		        }
		        
		        die "Number of cells imported [$cell_count] in $header section not equal to ",
		            "file NumCells spec [$block_data{NumCells}]." unless $block_data{NumCells} == $cell_count;
		        
		        print "\t$probeset_count probesets/$feature_import_count features imported.\n" if ++$probeset_count % 10000 == 0;
	            }
	            
	            $block_str = '';
                    $header = $next_header;
	        } else {
	            $header = $1;
	        }
            } else {
	        s/^Cell(\d)=/Cell0$1=/;              # convert Cell1, Cell2, ... lines to Cell01, Cell02 so that they sort properly
                $block_str .= $_ unless m/^\s*$/;    # add line to $block_str if it is not empty
            }
        }
        close(CDFFILE);
        print "\t$probeset_count probesets/$feature_import_count features TOTAL imported.\n";
        $dbh->commit;
    };
    
    if ($@) {
        warn "\nTransaction to import ${filebase}${file_ext} aborted:\n$@\n";
	eval { $dbh->rollback };
    }
}

$_->finish for values %sths;

# ------------------------------------------------------------------------------------------------------------------------------ #

eval {
    print "\nReenabling constraints:\n";
    for my $constraint_name (reverse sort keys %cdf_constraints) {   # reverse sort to make sure PKs are enabled before FKs
        print "\t\U$constraint_name\E", $pad_char x ($pad_length - length $constraint_name);
        if ($constraint_name =~ /^PK_/i) { 
            $dbh->do("ALTER TABLE $cdf_constraints{$constraint_name}->{table_name} ENABLE PRIMARY KEY");
        } else { 
            $dbh->do("ALTER TABLE $cdf_constraints{$constraint_name}->{table_name} ENABLE CONSTRAINT $constraint_name");
        }
        print "ENABLED\n";
    }
    
    print "\nRecreating indexes:\n";
    for my $index_name (sort keys %cdf_indexes) {
        print "\t\U$index_name\E", $pad_char x ($pad_length - length $index_name);
        $dbh->do("CREATE INDEX $index_name ON $cdf_indexes{$index_name}->{table_name} ($cdf_indexes{$index_name}->{column_name})");
        print "CREATED\n";
    }
};

if ($@) {
    warn "\nMIMAS Repository Array Library database error:\n$@\n";
    eval { $dbh->rollback };
    $dbh->disconnect;
    exit;
}


$dbh->disconnect;

print "\nProgram complete!\n\n";
exit 0;

