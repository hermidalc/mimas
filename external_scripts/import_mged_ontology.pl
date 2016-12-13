#!/usr/bin/perl
# import_mged_ontology.pl
# MIMAS MGED Ontology import script
#
#######################################################
# Copyright 2003-2005 Alexandre Gattiker
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../libs";
use sigtrap qw(handler sig_handler normal-signals error-signals ALRM);
use MIMAS::DB;
use MIMAS::Consts;
use MIMAS::Utils;

use Data::Dumper;
use XML::Parser;

sub sig_handler {
    die "\nMIMAS User Approval exited.\n\n";
}

# Unbuffer error and output streams (make sure STDOUT is last so that it remains the default filehandle)
select(STDERR); $| = 1;
select(STDOUT); $| = 1;

# Set up Environment
&set_env();

my $mimas_db = MIMAS::DB->new(-service => 'ADMIN');

#shared var
my %data;

&store_mged();
&check_mged();

# commit to DB
$mimas_db->commit();

exit;

sub mged_id_2_mage_id {
    my $e = shift;
    my $v = shift;
    my %mged2mage = reverse qw(
    d           days
    degree_C    degrees_C
    degree_F    degrees_F
    h           hours
    m           minutes
    mg_per_mL   mg_per_ml
    s           seconds
    uL          ul
    mL          ml
    L           l
    );
    return $mged2mage{$v} || $v;
}

sub check_mged {
    my $mged_term_all = $mimas_db->Library->MgedTermAdaptor->select_all();
    my %mged;
    my %mgedrev;
    my %mimas;
    my %mimas_mged_to_attr;
    for my $mged_term (values %$mged_term_all) {
        $mged{$mged_term->mged_name}{$mged_term->mage_name} = $mged_term;
        $mgedrev{$mged_term->mage_name} = $mged_term;
    }

    my $attr_all = $mimas_db->Library->AttributeAdaptor->select_all();
    for my $attr (values %$attr_all) {
        my $details = $attr->details;
        next unless $details;
        for my $detail (values %$details) {
            my $mged_name = $attr->mged_name;
            my $mage_name = $detail->mage_name;
            if (!$mged_name) {
                if ($mage_name) {
                    my $mged_term = $mgedrev{$mage_name};
                    if ($mged_term) {
                        $mged_name = $mged_term->mged_name;
                    }
                    else {
                        report("MISSING IN MGED", "?" . $attr->name . "?", $mage_name, $mged_term, undef);
                    }
                }
            }
            if ($mged_name) {
                $mimas{$mged_name}{$mage_name || $detail->name} = $attr;
                $mimas_mged_to_attr{$mged_name}{$attr->dbID} = $attr;
            }
        }
    }
    for my $mged_name (keys %mimas) {
        next unless $mged{$mged_name};
        TERM:
        for my $mage_name (keys %{$mimas{$mged_name}}) {
            my $attr = $mimas{$mged_name}{$mage_name};
            my $mged_term = $mgedrev{$mage_name};
            my $mged_name2;
            if ($mged_term) {
                $mged_name2 = $mged_term->mged_name;
                if ($mged_term->deprecated) {
                    report("DEPRECATED IN MIMAS", $mged_name2, $mage_name, $mged_term, $attr);
                    next TERM;
                }
                next if $mged{$mged_name2}{$mage_name};
            }
            report("MISSING IN MGED", $mged_name, $mage_name, $mged_term, $attr);
        }
    }
    for my $mged_name (keys %mged) {
        next unless $mimas{$mged_name};
        for my $mage_name (keys %{$mged{$mged_name}}) {
            my $mged_term = $mged{$mged_name}{$mage_name};
            next if $mimas{$mged_name}{$mage_name};
            next if $mged_term->deprecated;
            my @mimas_attr = values(%{$mimas_mged_to_attr{$mged_name} || {}});
            my @mimas_attr2;
            for my $attr (@mimas_attr) {
                #Nucleic Acid Type is a subset of MaterialType, so don't report MaterialType's that are not DNA/RNA
                next if $attr->name eq 'Nucleic Acid Type' and $mged_name eq 'MaterialType' and $mage_name !~ /[DR]NA$/;
                #Sample Material Type is a subset of MaterialType, so don't report MaterialType's that refer to biomolecular entities
                next if $attr->name eq 'Sample Material Type' and $mged_name eq 'MaterialType' and $mage_name =~ /[DR]NA$/ or grep {$_ eq $mage_name} qw(protein molecular_mixture cell_lysate);
                push @mimas_attr2, $attr;
            }
            if (@mimas_attr2) {
                for my $attr (@mimas_attr2) {
                    report("MISSING IN MIMAS", $mged_name, $mage_name, $mged_term, $attr);
                }
            }
            else {
                report("MISSING IN MIMAS", $mged_name, $mage_name, $mged_term, undef);
            }
        }
    }
}

sub report {
    my ($msg, $mged_name, $mage_name, $mged_term, $attr) = @_;
    my $deprecated = $mged_term ? $mged_term->deprecated : undef;
    my $attr_name = $attr ? $attr->name : undef;
    $msg .= " $deprecated" if $deprecated;
    print join("\t", $msg, $mged_name, $mage_name, $attr_name || "?"), "\n";
}

sub store_mged {

    my $file = shift @ARGV or die "Must pass a file MGEDOntology_*.owl";

    die "Can't find file \"$file\""
    unless -f $file;

    my $count = 0;

    my $parser = new XML::Parser(ErrorContext => 2);

    $parser->setHandlers(
        Char => \&char_handler,
        Default => \&default_handler,
        Start => \&start_handler,
        End => \&end_handler,
    );

    $mimas_db->Library->MgedTermAdaptor->remove_all;

    $parser->parsefile($file);
}


sub char_handler {
    my ($p, $s) = @_;
    if (defined $data{pcomment}) {
        ${$data{pcomment}} .= $s;
    }
}
sub default_handler {}

sub start_handler {
    my ($p, $e, %attrs) = @_;
    $data{pcomment} = undef;
    push @{$data{stack}}, [$e];
    if ($e =~ /^rdfs:/) {
        if ($e eq 'rdfs:comment') {
            $data{stack}[-2][2] = "";
            $data{pcomment} = \$data{stack}[-2][2];
        }
    }
    elsif ($e =~ /^rdf:/) {
    }
    elsif ($e =~ /^owl:/) {
    }
    else {
#		warn $e;
        if ($e eq 'deprecated_from_version') {
            $data{stack}[-2][3] ||= "$e " . ($attrs{'rdf:resource'} || "");
        }
        if ($e eq 'has_reason_for_deprecation') {
            my $deprecated = $attrs{'rdf:resource'} || $e;
            $deprecated =~ s/^#//;
            $data{stack}[-2][3] = $deprecated;
        }
        while (my ($k, $v) = each %attrs) {
            if ($k eq 'rdf:ID') {
                $data{stack}[-1][1] = $v;
#				warn Dumper \%data;
            }
        }
    }
}

sub end_handler {
    my ($p, $e) = @_;
    my $parr = pop @{$data{stack}};
    my ($e1, $id, $comment, $deprecated) = @$parr;
    if (defined $comment) {
        $comment =~ s/\A\s+//;
        $comment =~ s/\s+\Z//;
    }
    if (defined $id) {
        my $id_mage = mged_id_2_mage_id($e1, $id);
        $mimas_db->Library->MgedTermAdaptor->store(
            -mged_name => $e,
            -mged_type => 'Class',
            -mage_name_mged => $id,
            -mage_name => $id_mage,
            -deprecated => $deprecated,
            -description => $comment,
        );
    }
}

