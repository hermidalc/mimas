# Utils.pm
# MIMAS General Utilities
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::Utils;

use strict;
use warnings;
use Digest::MD5 qw(md5_hex);
use MIME::Base64 qw(encode_base64 decode_base64);
use MIME::Lite;
use POSIX qw(strtod);
use Storable qw(nfreeze thaw);
use Symbol qw(gensym);
use MIMAS::Consts;
require Exporter;
use File::Temp qw(tempdir);

our @ISA      = qw(Exporter);
our @EXPORT   = qw( 
		    send_email
		    dir_size		get_html								ignoring_case
		    by_order_then_name	by_group_order_then_order_then_name	
            by_detail_group_order_then_order_then_name
            by_attr_info			is_numeric
		    is_integer		numerically				escapeJS			clean_whitespace
		    clean_freetext	encrypt_password			generate_fingerprint		serialize
		    unserialize		get_caller_name				set_env				escapeXML
		    toJSON		orderedHash				newTempDir                      parse_file_components
		    io_string
                    );
our $VERSION  = 1.00;


sub send_email {
    my $email = MIME::Lite->new(@_);
    return $email->send();
}

sub dir_size {
    my $dirpath  = shift;
    my $dir_size = 0;
    
    opendir DIR, $dirpath or die "Unable to open $dirpath: $!\n";
    my @filenames = readdir DIR;
    closedir DIR;
    
    for my $filename (@filenames) {
        next if -d "$dirpath/$filename";
	$dir_size += -s "$dirpath/$filename";
    }
    return $dir_size;
}


sub get_html {
    my ($html_path, $sub_field_values) = @_;
    
    local $/;
    open(INFILE, "$ENV{DOCUMENT_ROOT}/ssi/${html_path}") or die "\nCould not open file $ENV{DOCUMENT_ROOT}/ssi/${html_path}!!: $!\n";
    my $html = <INFILE>;
    close(INFILE);
    
    if (defined $sub_field_values) {
        my @sub_field_values = %{$sub_field_values};
        die "Incomplete get_html name/value pairs!\n" if scalar @sub_field_values % 2 != 0;
	undef @sub_field_values;
	
	while (my ($field, $value) = each %{$sub_field_values}) {
	    $field =~ s/^-//;
	    $field =~ tr/a-z/A-Z/;
	    $html  =~ s/\$\{$field\}/$value/g;
	}
    } else {
        $html =~ s/\$\{\w+\}//g;
    }
    
    $html =~ s/^\s+//;
    $html =~ s/\s+$//;
    
    return $html;
}


sub ignoring_case ($$) {
    my ($a, $b) = @_;
    lc($a) cmp lc($b);
}


sub by_order_then_name ($$) {
    my ($a, $b) = @_;
    (defined $a->display_order and defined $b->display_order)
       ? $a->display_order <=> $b->display_order
	     ||
	 lc($a->name) cmp lc($b->name)
       : defined $a->display_order
           ? -1
	   : defined $b->display_order
	       ? 1
	       : lc($a->name) cmp lc($b->name);
}


# for sorting attributes only
sub by_group_order_then_order_then_name ($$) {
    my ($a, $b) = @_;
    (defined $a->attr_group and defined $b->attr_group)
      ? $a->attr_group->view_display_order <=> $b->attr_group->view_display_order
            ||
	((defined $a->display_order and defined $b->display_order)
	     ? $a->display_order <=> $b->display_order
	           ||
	       lc($a->name) cmp lc($b->name)
	     : defined $a->display_order
	         ? -1
		 : defined $b->display_order
		     ? 1
		     : lc($a->name) cmp lc($b->name))
      : defined $a->attr_group
          ? -1
	  : defined $b->attr_group
	      ? 1
	      : (defined $a->display_order and defined $b->display_order)
	           ? $a->display_order <=> $b->display_order
		         ||
	             lc($a->name) cmp lc($b->name)
		   : defined $a->display_order
		       ? -1
		       : defined $b->display_order
		           ? 1
			   : lc($a->name) cmp lc($b->name);
}

# for sorting attribute_detail only
sub by_detail_group_order_then_order_then_name ($$) {
    my ($a, $b) = @_;
    (defined $a->group and defined $b->group)
      ? $a->group->display_order <=> $b->group->display_order
            ||
	((defined $a->display_order and defined $b->display_order)
	     ? $a->display_order <=> $b->display_order
	           ||
	       lc($a->name) cmp lc($b->name)
	     : defined $a->display_order
	         ? -1
		 : defined $b->display_order
		     ? 1
		     : lc($a->name) cmp lc($b->name))
      : defined $a->group
          ? -1
	  : defined $b->group
	      ? 1
	      : (defined $a->display_order and defined $b->display_order)
	           ? $a->display_order <=> $b->display_order
		         ||
	             lc($a->name) cmp lc($b->name)
		   : defined $a->display_order
		       ? -1
		       : defined $b->display_order
		           ? 1
			   : lc($a->name) cmp lc($b->name);
}


# for sorting experiment/sample attributes only
sub by_attr_info ($$) {
    my ($a, $b) = @_;
    (defined $a->attribute->attr_group and defined $b->attribute->attr_group)
       ? $a->attribute->attr_group->view_display_order <=> $b->attribute->attr_group->view_display_order
             ||
	 ((defined $a->attribute->display_order and defined $b->attribute->display_order)
	     ? $a->attribute->display_order <=> $b->attribute->display_order
	           ||
	       lc($a->attribute->name) cmp lc($b->attribute->name)
	           ||
	       lc($a->detail->name)    cmp lc($b->detail->name)
	     : defined $a->attribute->display_order
	         ? -1
		 : defined $b->attribute->display_order
		     ? 1
		     : lc($a->attribute->name) cmp lc($b->attribute->name)
	                   ||
	               lc($a->detail->name)    cmp lc($b->detail->name))
       : defined $a->attribute->attr_group
           ? -1
	   : defined $b->attribute->attr_group
	       ? 1
	       : (defined $a->attribute->display_order and defined $b->attribute->display_order)
	            ? $a->attribute->display_order <=> $b->attribute->display_order
		          ||
	              lc($a->attribute->name) cmp lc($b->attribute->name)
	                  ||
	              lc($a->detail->name)    cmp lc($b->detail->name)
		    : defined $a->attribute->display_order
		        ? -1
			: defined $b->attribute->display_order
			    ? 1
			    : lc($a->attribute->name) cmp lc($b->attribute->name)
			          ||
			      lc($a->detail->name)    cmp lc($b->detail->name);
}


sub is_numeric {
    my $str = shift;
    $str =~ s/^\s+//;
    $str =~ s/\s+$//;
    $! = 0;
    my ($num, $n_unparsed) = strtod($str);
    return (($str eq '') || ($n_unparsed != 0) || $!) ? 0 : 1;
}


sub is_integer {
    my $value = shift;
    return $value =~ m/^-?\d+$/ ? 1 : 0;
}


sub numerically ($$) {
    my ($a, $b) = @_;
    $a <=> $b;
}


sub escapeJS {
    my $value = shift;
    $value =~ s/\\/\\\\/g;
    $value =~ s/"/\\"/g;
    return $value;
}


sub clean_whitespace {
    my $value = shift;
    $value =~ s/^\s+//;
    $value =~ s/\s+$//;
    $value =~ s/\s+/ /g;
    return $value;
}


sub clean_freetext {
    my $value = shift;
    $value =~ s/^\s+//;
    $value =~ s/\s+$//;
    return $value;
}


sub encrypt_password {
    my $password = shift;
    return md5_hex($password);
}


sub generate_fingerprint {
    my $data = shift;
    return md5_hex($data);
}


sub serialize {
    my $data = shift;
    return encode_base64(nfreeze($data));
}


sub unserialize {
    my $serialized_data = shift;
    return thaw(decode_base64($serialized_data));
}


sub get_caller_name {
    return pop @{[split /::/, (caller(2))[3]]};  # need to go 2 frames back to find out name of subroutine that called me
}


sub set_env {
    $ENV{NLS_DATE_FORMAT} = MIMAS_ENV_NLS_DATE_FORMAT;
    $ENV{NLS_LANG}        = MIMAS_ENV_NLS_LANG;
    $ENV{LANG}            = MIMAS_ENV_LANG;
}


sub escapeXML {
    my $value = shift;
    $value =~ s/&/&amp;/g;
    $value =~ s/</&lt;/g;
    $value =~ s/>/&gt;/g;
    $value =~ s/"/&quot;/g;
    $value =~ s/'/&#39;/g;
    return $value;
}

sub toJSON {
    require JSON;
    return JSON::objToJson(@_);
}

sub orderedHash {
    #other possible modules: Tie::LLHash, Tie::IxHash
    require Tie::Hash::Indexed;
    tie my %hash, 'Tie::Hash::Indexed';
    return \%hash;
}


sub newTempDir {
    # Apache::Registry should run the END{} block which does tempdir cleanup (rmtree())as long as when I change any scripts
    # I reboot the server
    return &tempdir(DIR => MIMAS_TEMP_DIR, CLEANUP => 1);
}

sub parse_file_components {
	my ($mimas_web, $filename) = @_;
	my @errors;
	use File::Basename;

        if    ( $mimas_web->cgi->user_agent =~ /windows/i   ) { fileparse_set_fstype('MSWin32')     }
        elsif ( $mimas_web->cgi->user_agent =~ /linux/i     ) { fileparse_set_fstype('Unix')        }
        elsif ( $mimas_web->cgi->user_agent =~ /macintosh/i ) { fileparse_set_fstype('MacOS')       }
        else                                                  { push @errors, 'Invalid browser OS!' }

	my ($name, $dirs, $ext) = fileparse($filename, qr/\.[^.]*/);
	return ($name, $ext, @errors);
}

sub io_string {
	my ($string) = @_;
	my $fh = gensym;
	open $fh, '<', (ref($string) ? $string : \$string) or die $!;
	return $fh;
}

1;

my $mimas = MIMAS_DB_SCHEMA;

#TODO: create views!!!
our $cast = uc MIMAS_DB_DRIVER eq 'ORACLE' ? sub {"CAST($_[0] AS VARCHAR2(4000))"} : sub {$_[0]};

our $TMP_VIEW_SAMPLE_ATTRIBUTE =  <<ENDDDL;
SELECT @{[&$cast("sa.char_value")]} AS char_value, sa.numeric_value, sa.attr_detail_id, sa.attribute_id, s.experiment_id, s.sample_id
FROM $mimas.up_sample s JOIN $mimas.up_sample_attribute sa ON (s.sample_id=sa.sample_id)

UNION ALL
SELECT @{[&$cast("ea.char_value")]}, ea.numeric_value, ea.attr_detail_id, ea.attribute_id, s.experiment_id, s.sample_id
FROM $mimas.up_sample s JOIN $mimas.up_exp_attribute ea ON (s.experiment_id=ea.experiment_id)

UNION ALL
SELECT  NULL, s.experiment_id, NULL, a.attribute_id, s.experiment_id, s.sample_id
FROM $mimas.up_sample s JOIN $mimas.attribute a ON (a.name='Experiment ID')

UNION ALL
SELECT  e.name, NULL, NULL, a.attribute_id, s.experiment_id, s.sample_id
FROM $mimas.up_sample s JOIN $mimas.attribute a ON (a.name='Experiment Name') JOIN $mimas.up_experiment e ON (e.experiment_id=s.experiment_id)

UNION ALL
SELECT  @{[&$cast("f.upload_date")]}, NULL, NULL, a.attribute_id, s.experiment_id, s.sample_id
FROM $mimas.up_sample s JOIN $mimas.attribute a ON (a.name='Upload date') JOIN $mimas.up_sample_to_file j ON (s.sample_id=j.sample_id) JOIN $mimas.up_sample_file f ON (j.sample_file_id=f.sample_file_id AND f.upload_date IS NOT NULL)

UNION ALL
SELECT  NULL, s.sample_id, NULL, a.attribute_id, s.experiment_id, s.sample_id
FROM $mimas.up_sample s JOIN $mimas.attribute a ON (a.name='Sample ID')

UNION ALL
SELECT  s.name, NULL, NULL, a.attribute_id, s.experiment_id, s.sample_id
FROM $mimas.up_sample s JOIN $mimas.attribute a ON (a.name='Sample Name')

UNION ALL
SELECT  c.name, NULL, NULL, a.attribute_id, s.experiment_id, s.sample_id
FROM $mimas.up_sample s JOIN $mimas.attribute a ON (a.name='Experimental Condition Name') JOIN $mimas.up_exp_condition c ON (s.condition_id=c.condition_id)

UNION ALL
SELECT  @{[&$cast("f.hybridization_date")]}, NULL, NULL, a.attribute_id, s.experiment_id, s.sample_id
FROM $mimas.up_sample s JOIN $mimas.attribute a ON (a.name='Hybridization date') JOIN $mimas.up_sample_to_file j ON (s.sample_id=j.sample_id) JOIN $mimas.up_sample_file f ON (j.sample_file_id=f.sample_file_id AND f.hybridization_date IS NOT NULL)

UNION ALL
SELECT  NULL, NULL, e.owner_id, a.attribute_id, s.experiment_id, s.sample_id
FROM $mimas.up_sample s JOIN $mimas.attribute a ON (a.name='Sample Owner') JOIN $mimas.up_experiment e ON (e.experiment_id=s.experiment_id)

UNION ALL
SELECT  NULL, NULL, s.array_id, a.attribute_id, s.experiment_id, s.sample_id
FROM $mimas.up_sample s JOIN $mimas.attribute a ON (a.name='Array Design Name')

UNION ALL
SELECT  NULL, e.num_hybrids, NULL, a.attribute_id, s.experiment_id, s.sample_id
FROM $mimas.up_sample s JOIN $mimas.attribute a ON (a.name='Number of Hybridizations') JOIN $mimas.up_experiment e ON (e.experiment_id=s.experiment_id)

UNION ALL
SELECT  NULL, c.num_replicates, NULL, a.attribute_id, s.experiment_id, s.sample_id
FROM $mimas.up_sample s JOIN $mimas.attribute a ON (a.name='Number of Replicates')
JOIN (SELECT s.condition_id, count(s.condition_id) AS num_replicates FROM $mimas.up_sample s GROUP BY s.condition_id) c
     ON c.condition_id = s.condition_id

UNION ALL
SELECT  NULL, NULL, y.technology_id, a.attribute_id, s.experiment_id, s.sample_id
FROM $mimas.up_sample s JOIN $mimas.attribute a ON (a.name='Technology') JOIN $mimas.array y ON (s.array_id=y.array_id)

ENDDDL
push @EXPORT, qw($TMP_VIEW_SAMPLE_ATTRIBUTE);


our $TMP_VIEW_USER_TO_ALL_GROUPS =  <<ENDDDL;
SELECT ug.user_id, ug.group_id FROM $mimas.user_to_group ug
UNION 
SELECT  u.user_id,  g.group_id FROM $mimas.mimas_user u
JOIN $mimas.mimas_group g ON g.is_auto=1
ENDDDL
push @EXPORT, qw($TMP_VIEW_USER_TO_ALL_GROUPS);


our $TMP_VIEW_USER_TO_GROUP_EXT =  <<ENDDDL;
SELECT u.user_id, g.group_id,
CASE g.restrict_level WHEN 'user' THEN u.user_id END AS r_user_id,
CASE g.restrict_level WHEN 'lab' THEN u.lab_id END AS r_lab_id,
CASE g.restrict_level WHEN 'organization' THEN l.organization_id END AS r_organization_id,
CASE g.restrict_level WHEN 'facility' THEN uf.attr_detail_id END AS r_facility_id
FROM $mimas.mimas_user u
JOIN $mimas.lab l ON u.lab_id = l.lab_id
JOIN ($TMP_VIEW_USER_TO_ALL_GROUPS) ug ON u.user_id=ug.user_id
JOIN $mimas.mimas_group g ON ug.group_id=g.group_id
LEFT JOIN $mimas.user_to_facility uf ON u.user_id=uf.user_id
ENDDDL
push @EXPORT, qw($TMP_VIEW_USER_TO_GROUP_EXT);


our $TMP_VIEW_GROUP_EXP_PRIVILEGE_EXT =  <<ENDDDL;
SELECT p.group_id, p.can_write, p.experiment_id,
CASE g.restrict_level WHEN 'user' THEN u.user_id END AS r_user_id,
CASE g.restrict_level WHEN 'lab' THEN u.lab_id END AS r_lab_id,
CASE g.restrict_level WHEN 'organization' THEN l.organization_id END AS r_organization_id,
CASE g.restrict_level WHEN 'facility' THEN ea.attr_detail_id END AS r_facility_id
FROM $mimas.group_exp_privilege p
JOIN $mimas.up_experiment e ON p.experiment_id = e.experiment_id
JOIN $mimas.mimas_user u ON e.owner_id = u.user_id
JOIN $mimas.lab l ON u.lab_id = l.lab_id
JOIN $mimas.mimas_group g ON p.group_id = g.group_id
JOIN $mimas.attribute a ON a.name = 'Microarray Facility'
LEFT JOIN $mimas.up_exp_attribute ea ON ea.experiment_id=e.experiment_id AND ea.attribute_id = a.attribute_id
ENDDDL
push @EXPORT, qw($TMP_VIEW_GROUP_EXP_PRIVILEGE_EXT);


our $TMP_VIEW_USER_EXP_PRIVILEGE =  <<ENDDDL;
SELECT ep.experiment_id, ug.user_id, ug.group_id, ep.can_write
FROM ( $TMP_VIEW_GROUP_EXP_PRIVILEGE_EXT ) ep
JOIN ( $TMP_VIEW_USER_TO_GROUP_EXT ) ug
ON  ep.group_id = ug.group_id
AND (ep.r_user_id = ug.r_user_id OR ep.r_user_id IS NULL)
AND (ep.r_lab_id = ug.r_lab_id OR ep.r_lab_id IS NULL)
AND (ep.r_organization_id = ug.r_organization_id OR ep.r_organization_id IS NULL)
AND (ep.r_facility_id = ug.r_facility_id OR ep.r_facility_id IS NULL)
ENDDDL
push @EXPORT, qw($TMP_VIEW_USER_EXP_PRIVILEGE);
