# Attribute.pm
# MIMAS Library Attribute Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::Library::Attribute;

use strict;
use warnings;
use base qw(MIMAS::DB::BaseDataEntity);

use MIMAS::DB::Library::AttrDetail;

our $VERSION = 1.00;


sub name {
    my $self = shift;
    $self->{name} = shift if @_;
    return $self->{name};
}


sub is_attribute {
    my $self = shift;
    $self->{is_attribute} = shift if @_;
    return $self->{is_attribute};
}


sub is_factor {
    my $self = shift;
    $self->{is_factor} = shift if @_;
    return $self->{is_factor};
}


sub is_numeric {
    my $self = shift;
    $self->{is_numeric} = shift if @_;
    return $self->{is_numeric};
}


sub deprecated {
    my $self = shift;
    $self->{deprecated} = shift if @_;
    return $self->{deprecated};
}


sub required {
    my $self = shift;
    $self->{required} = shift if @_;
    return $self->{required};
}


sub other {
    my $self = shift;
    $self->{other} = shift if @_;
    return $self->{other};
}


sub none_na {
    my $self = shift;
    $self->{none_na} = shift if @_;
    return $self->{none_na};
}


sub search_form_type {
    my $self = shift;
    $self->{search_form_type} = shift if @_;
    return $self->{search_form_type};
}


sub upload_form_type {
    my $self = shift;
    $self->{upload_form_type} = shift if @_;
    return $self->{upload_form_type};
}


sub upload_web_page {
    my $self = shift;
    $self->{upload_web_page} = shift if @_;
    return $self->{upload_web_page};
}


sub display_order {
    my $self = shift;
    $self->{display_order} = shift if @_;
    return $self->{display_order};
}


sub description {
    my $self = shift;
    $self->{description} = shift if @_;
    return $self->{description};
}


sub mage_category {
    my $self = shift;
    $self->{mage_category} = shift if @_;
    return $self->{mage_category};
}


sub mged_name {
    my $self = shift;
    $self->{mged_name} = shift if @_;
    return $self->{mged_name};
}


sub attr_group {
    my $self = shift;
    $self->{attr_group} = $self->adaptor->area->AttrGroupAdaptor->select_by_dbID($self->{attr_group_id}) unless defined $self->{attr_group};
    return $self->{attr_group};
}


sub factor_group {
    my $self = shift;
    $self->{factor_group} = $self->adaptor->area->FactorGroupAdaptor->select_by_dbID($self->{factor_group_id}) unless defined $self->{factor_group};
    return $self->{factor_group};
}


sub details {
    my $self = shift;
    $self->{details} = $self->adaptor->area->AttrDetailAdaptor->select_all_by_attrID($self->dbID) unless defined $self->{details};
    return $self->{details};
}

sub search_details {
    my $self = shift;
    if ($self->name eq 'Sample Owner') {
        my %attr_details;
        my $all = $self->adaptor->area->db->User->UserAdaptor->select_all_with_sample();
        my %name_counts;
        for my $item (values %$all) {
            $name_counts{$item->full_name_reversed}++;
        }
        while (my ($dbID, $item) = each %$all) {
            my $name = $item->full_name_reversed;
            if ($name_counts{$name} > 1) {
                $name .= " (" . $item->username . ")";
            }
            $attr_details{$dbID} = MIMAS::DB::Library::AttrDetail->new(
                adaptor              => $self->adaptor,
                dbID                 => $dbID,
                name                 => $name,
                attribute_id         => $self->dbID,
            );

        }
        return \%attr_details;
    }
    elsif ($self->name eq 'Array Design Name') {
        my %attr_details;
        my $all = $self->adaptor->area->ArrayAdaptor->select_all();
        while (my ($dbID, $item) = each %$all) {
            $attr_details{$dbID} = MIMAS::DB::Library::AttrDetail->new(
                adaptor              => $self->adaptor,
                dbID                 => $dbID,
                name                 => $item->design_name,
                attribute_id         => $self->dbID,
            );

        }
        return \%attr_details;
    }
    elsif ($self->name eq 'Technology') {
        my %attr_details;
        my $all = $self->adaptor->area->TechnologyAdaptor->select_all();
        while (my ($dbID, $item) = each %$all) {
            $attr_details{$dbID} = MIMAS::DB::Library::AttrDetail->new(
                adaptor              => $self->adaptor,
                dbID                 => $dbID,
                name                 => $item->display_name,
                attribute_id         => $self->dbID,
            );

        }
        return \%attr_details;
    }
    # general case (attribute has values described in MIMAS Library)
    else {
        return $self->details;
    }
}


1;

