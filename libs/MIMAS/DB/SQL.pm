# SQL.pm
# MIMAS Master SQL File
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::DB::SQL;

use strict;
use warnings;
use MIMAS::Utils qw(
    $TMP_VIEW_USER_EXP_PRIVILEGE
    $TMP_VIEW_SAMPLE_ATTRIBUTE
    $TMP_VIEW_USER_TO_GROUP_EXT
);
use MIMAS::Consts qw(MIMAS_DB_SCHEMA ORA_CLOB ORA_BLOB);
require Exporter;

our @ISA       = qw(Exporter);
our @EXPORT    = qw($Selects $Inserts $Updates $Deletes);
our $VERSION   = 1.00;

our $mimas     = MIMAS_DB_SCHEMA;

our $Selects = {
    
    Library        =>  {
                         MgedTerm            =>  {
                                                   select_all                      =>  {
                                                                                         sql                => "SELECT    mged_name, mged_type, mage_name_mged, mage_name, deprecated, description
                                                                                                                FROM      $mimas.mged_term
                                                                                                                ",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
                                                   
                                                   select_by_mage_name             =>  {
                                                                                         sql                => "SELECT    mged_name, mged_type, mage_name_mged, mage_name, deprecated, description
                                                                                                                FROM      $mimas.mged_term
                                                                                                                WHERE     mage_name = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
                                                 },
                         Array               =>  {
                                                   select_all                      =>  {
                                                                                         sql                => "SELECT    array_id, design_name, display_name,
                                                                                                                          num_probesets, num_cel_features,
                                                                                                                          technology_id, arrayexpress_accession,
                                                                                                                          manufacturer
                                                                                                                FROM      $mimas.array",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
                                                   
                                                   select_by_design_name           =>  {
                                                                                         sql                => "SELECT    array_id, design_name, display_name,
                                                                                                                          num_probesets, num_cel_features,
                                                                                                                          technology_id, arrayexpress_accession,
                                                                                                                          manufacturer
                                                                                                                FROM      $mimas.array
                                                                                                                WHERE     LOWER(design_name) = LOWER(?)",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
                                                   
                                                   select_by_dbID                  =>  {
                                                                                         sql                => "SELECT    array_id, design_name, display_name,
                                                                                                                          num_probesets, num_cel_features,
                                                                                                                          technology_id, arrayexpress_accession,
                                                                                                                          manufacturer
                                                                                                                FROM      $mimas.array
                                                                                                                WHERE     array_id = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },

                                                   select_all_by_technologyID      =>  {
                                                                                         sql                => "SELECT    array_id, design_name, display_name,
                                                                                                                          num_probesets, num_cel_features,
                                                                                                                          technology_id, arrayexpress_accession,
                                                                                                                          manufacturer
                                                                                                                FROM      $mimas.array
                                                                                                                WHERE     technology_id = ?",

                                                                                         method             => 'selectall_arrayref',

                                                                                         attrs              => { Slice => {} }
                                                                                       },
                                                 },

                         Technology          =>  {
                                                   select_all                      =>  {
                                                                                         sql                => "SELECT    technology_id, name, display_name,
                                                                                                                          default_manufacturer
                                                                                                                FROM      $mimas.technology",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
                                                   
                                                   select_by_display_name          =>  {
                                                                                         sql                => "SELECT    technology_id, name, display_name,
                                                                                                                          default_manufacturer
                                                                                                                FROM      $mimas.technology
                                                                                                                WHERE     display_name = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
                                                   
                                                   select_by_dbID                  =>  {
                                                                                         sql                => "SELECT    technology_id, name, display_name,
                                                                                                                          default_manufacturer
                                                                                                                FROM      $mimas.technology
                                                                                                                WHERE     technology_id = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
                                                 },
                         
                         AttrDetail          =>  {
                                                   select_all                      =>  {
                                                                                         sql                => "SELECT    attr_detail_id, name, type, deprecated,
											                                  default_selection, display_order, base_conv_scalar,
                                                                                                                          base_conv_factor, description, link_id,
											                                  attr_detail_group_id, attribute_id,
                                                                                                                          mage_name
                                                                                                                FROM      $mimas.attr_detail",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
						   
                                                   select_all_by_type              =>  {
                                                                                         sql                => "SELECT    attr_detail_id, name, type, deprecated,
											                                  default_selection, display_order, base_conv_scalar,
                                                                                                                          base_conv_factor, description, link_id,
											                                  attr_detail_group_id, attribute_id,
                                                                                                                          mage_name
                                                                                                                FROM      $mimas.attr_detail
                                                                                                                WHERE     type = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
						   
                                                   select_all_by_groupID           =>  {
                                                                                         sql                => "SELECT    attr_detail_id, name, type, deprecated,
											                                  default_selection, display_order, base_conv_scalar,
                                                                                                                          base_conv_factor, description, link_id,
											                                  attr_detail_group_id, attribute_id,
                                                                                                                          mage_name
                                                                                                                FROM      $mimas.attr_detail
                                                                                                                WHERE     attr_detail_group_id = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
						 
                                                   select_all_by_attrID            =>  {
                                                                                         sql                => "SELECT    attr_detail_id, name, type, deprecated,
											                                  default_selection, display_order, base_conv_scalar,
                                                                                                                          base_conv_factor, description, link_id,
											                                  attr_detail_group_id, attribute_id,
                                                                                                                          mage_name
                                                                                                                FROM      $mimas.attr_detail
                                                                                                                WHERE     attribute_id = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
						 
                                                   select_all_facilities_by_userID =>  {
                                                                                         sql                => "SELECT    attr_detail_id, name, type, deprecated,
											                                  default_selection, display_order, base_conv_scalar,
                                                                                                                          base_conv_factor, description, link_id,
											                                  attr_detail_group_id, attribute_id,
                                                                                                                          mage_name
                                                                                                                FROM      $mimas.attr_detail
                                                                                                                WHERE     exists(SELECT e.user_id FROM $mimas.user_to_facility e WHERE e.attribute_id = attr_detail.attribute_id AND e.attr_detail_id = attr_detail.attr_detail_id AND e.user_id = ?)
                                                                                                                ",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
						 
                                                   select_by_attrs                 =>  {
                                                                                         sql                => "SELECT    attr_detail_id, name, type, deprecated,
											                                  default_selection, display_order, base_conv_scalar,
                                                                                                                          base_conv_factor, description, link_id,
											                                  attr_detail_group_id, attribute_id,
                                                                                                                          mage_name
                                                                                                                FROM      $mimas.attr_detail
                                                                                                                WHERE     name = ?
                                                                                                                          AND
                                                                                                                          type = ?
                                                                                                                          AND
                                                                                                                          attribute_id = ?",
                                                                    
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
						 
                                                   select_by_attrs_ci              =>  {
                                                                                         sql                => "SELECT    attr_detail_id, name, type, deprecated,
											                                  default_selection, display_order, base_conv_scalar,
                                                                                                                          base_conv_factor, description, link_id,
											                                  attr_detail_group_id, attribute_id,
                                                                                                                          mage_name
                                                                                                                FROM      $mimas.attr_detail
                                                                                                                WHERE     LOWER(name) = LOWER(?)
                                                                                                                          AND
                                                                                                                          type = ?
                                                                                                                          AND
                                                                                                                          attribute_id = ?",
                                                                    
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
						 
                                                   select_by_attr_link_id          =>  {
                                                                                         sql                => "SELECT    attr_detail_id, name, type, deprecated,
											                                  default_selection, display_order, base_conv_scalar,
                                                                                                                          base_conv_factor, description, link_id,
											                                  attr_detail_group_id, attribute_id,
                                                                                                                          mage_name
                                                                                                                FROM      $mimas.attr_detail
                                                                                                                WHERE     link_id = ?
                                                                                                                          AND
                                                                                                                          attribute_id = ?",
                                                                    
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
						 
                                                   select_by_attr_id_name          =>  {
                                                                                         sql                => "SELECT    attr_detail_id, name, type, deprecated,
											                                  default_selection, display_order, base_conv_scalar,
                                                                                                                          base_conv_factor, description, link_id,
											                                  attr_detail_group_id, attribute_id,
                                                                                                                          mage_name
                                                                                                                FROM      $mimas.attr_detail
                                                                                                                WHERE     attribute_id = ?
                                                                                                                          AND
                                                                                                                          name = ?",
                                                                    
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
						 
                                                   select_by_dbID                  =>  {
                                                                                         sql                => "SELECT    attr_detail_id, name, type, deprecated,
											                                  default_selection, display_order, base_conv_scalar,
                                                                                                                          base_conv_factor, description, link_id,
											                                  attr_detail_group_id, attribute_id,
                                                                                                                          mage_name
                                                                                                                FROM      $mimas.attr_detail
                                                                                                                WHERE     attr_detail_id = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       }
                                                 },      
                         
                         AttrDetailGroup     =>  {
                                                   select_all                      =>  {
                                                                                         sql                => "SELECT    attr_detail_group_id, name, display_order,
                                                                                                                          description, attribute_id
                                                                                                                FROM      $mimas.attr_detail_group",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
                                                   
                                                   select_all_by_attrID            =>  {
                                                                                         sql                => "SELECT    attr_detail_group_id, name, display_order,
                                                                                                                          description, attribute_id
                                                                                                                FROM      $mimas.attr_detail_group
                                                                                                                WHERE     attribute_id = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
                                                   
                                                   select_by_name                  =>  {
                                                                                         sql                => "SELECT    attr_detail_group_id, name, display_order,
                                                                                                                          description, attribute_id
                                                                                                                FROM      $mimas.attr_detail_group
                                                                                                                WHERE     name = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
                                                   
                                                   select_by_name_ci               =>  {
                                                                                         sql                => "SELECT    attr_detail_group_id, name, display_order,
                                                                                                                          description, attribute_id
                                                                                                                FROM      $mimas.attr_detail_group
                                                                                                                WHERE     LOWER(name) = LOWER(?)",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
                                                   
                                                   select_by_dbID                  =>  {
                                                                                         sql                => "SELECT    attr_detail_group_id, name, display_order,
                                                                                                                          description, attribute_id
                                                                                                                FROM      $mimas.attr_detail_group
                                                                                                                WHERE     attr_detail_group_id = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       }
                                                 },
                         
                         AttrGroup           =>  {
                                                   select_all                      =>  {
                                                                                         sql                => "SELECT    attr_group_id, name, upload_display_order,
                                                                                                                          view_display_order, description
                                                                                                                FROM      $mimas.attr_group
														WHERE     type = 'attribute'",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
                                                   
                                                   select_by_name                  =>  {
                                                                                         sql                => "SELECT    attr_group_id, name, upload_display_order,
                                                                                                                          view_display_order, description
                                                                                                                FROM      $mimas.attr_group
                                                                                                                WHERE     type = 'attribute'
															  AND
															  name = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
                                                   
                                                   select_by_name_ci               =>  {
                                                                                         sql                => "SELECT    attr_group_id, name, upload_display_order,
                                                                                                                          view_display_order, description
                                                                                                                FROM      $mimas.attr_group
                                                                                                                WHERE     type = 'attribute'
															  AND
															  LOWER(name) = LOWER(?)",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
                                                   
                                                   select_by_dbID                  =>  {
                                                                                         sql                => "SELECT    attr_group_id, name, upload_display_order,
                                                                                                                          view_display_order, description
                                                                                                                FROM      $mimas.attr_group
                                                                                                                WHERE     type = 'attribute'
															  AND
															  attr_group_id = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       }
                                                 },
                         
                         Attribute           =>  {
                                                   select_all                      =>  {
                                                                                         sql                => "SELECT    attribute_id, name, deprecated, required,
                                                                                                                          is_attribute, is_factor, is_numeric, other,
															  none_na, search_form_type, upload_form_type,
															  upload_web_page, display_order, description,
															  attr_group_id, factor_group_id,
                                                                                                                          mage_category, mged_name
                                                                                                                FROM      $mimas.attribute",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
                                                   
                                                   select_all_attrs                =>  {
                                                                                         sql                => "SELECT    attribute_id, name, deprecated, required,
                                                                                                                          is_attribute, is_factor, is_numeric, other,
															  none_na, search_form_type, upload_form_type,
															  upload_web_page, display_order, description,
															  attr_group_id, factor_group_id,
                                                                                                                          mage_category, mged_name
                                                                                                                FROM      $mimas.attribute
														WHERE     is_attribute = 1",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
                                                   
                                                   select_all_factors              =>  {
                                                                                         sql                => "SELECT    attribute_id, name, deprecated, required,
                                                                                                                          is_attribute, is_factor, is_numeric, other,
															  none_na, search_form_type, upload_form_type,
															  upload_web_page, display_order, description,
															  attr_group_id, factor_group_id,
                                                                                                                          mage_category, mged_name
                                                                                                                FROM      $mimas.attribute
														WHERE     is_factor = 1",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
                                                   
                                                   select_all_by_attr_groupID      =>  {
                                                                                         sql                => "SELECT    attribute_id, name, deprecated, required,
                                                                                                                          is_attribute, is_factor, is_numeric, other,
															  none_na, search_form_type, upload_form_type,
															  upload_web_page, display_order, description,
															  attr_group_id, factor_group_id,
                                                                                                                          mage_category, mged_name
                                                                                                                FROM      $mimas.attribute
                                                                                                                WHERE     attr_group_id = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
                                                   
                                                   select_all_by_factor_groupID    =>  {
                                                                                         sql                => "SELECT    attribute_id, name, deprecated, required,
                                                                                                                          is_attribute, is_factor, is_numeric, other,
															  none_na, search_form_type, upload_form_type,
															  upload_web_page, display_order, description,
															  attr_group_id, factor_group_id,
                                                                                                                          mage_category, mged_name
                                                                                                                FROM      $mimas.attribute
                                                                                                                WHERE     factor_group_id = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
                                                   
                                                   select_all_attrs_by_webpage     =>  {
                                                                                         sql                => "SELECT    attribute_id, name, deprecated, required,
                                                                                                                          is_attribute, is_factor, is_numeric, other,
															  none_na, search_form_type, upload_form_type,
															  upload_web_page, display_order, description,
															  attr_group_id, factor_group_id,
                                                                                                                          mage_category, mged_name
                                                                                                                FROM      $mimas.attribute
                                                                                                                WHERE     is_attribute = 1
															  AND
															  upload_web_page = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
                                                   
                                                   select_all_factors_by_expID     =>  {
                                                                                         sql                => "SELECT    A.attribute_id, A.name, A.deprecated, A.required,
                                                                                                                          A.is_attribute, A.is_factor, A.is_numeric, A.other,
															  A.none_na, A.search_form_type, A.upload_form_type,
															  A.upload_web_page, A.display_order, A.description,
															  A.attr_group_id, A.factor_group_id,
                                                                                                                          mage_category, mged_name
                                                                                                                FROM      $mimas.attribute A INNER JOIN $mimas.up_exp_factor B
                                                                                                                          ON A.attribute_id = B.factor_id
                                                                                                                WHERE     A.is_factor = 1
															  AND
															  B.experiment_id = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
                                                   
                                                   select_by_attr_name             =>  {
                                                                                         sql                => "SELECT    attribute_id, name, deprecated, required,
                                                                                                                          is_attribute, is_factor, is_numeric, other,
															  none_na, search_form_type, upload_form_type,
															  upload_web_page, display_order, description,
															  attr_group_id, factor_group_id,
                                                                                                                          mage_category, mged_name
                                                                                                                FROM      $mimas.attribute
                                                                                                                WHERE     is_attribute = 1
															  AND
															  name = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
                                                   
                                                   select_by_attr_name_ci          =>  {
                                                                                         sql                => "SELECT    attribute_id, name, deprecated, required,
                                                                                                                          is_attribute, is_factor, is_numeric, other,
															  none_na, search_form_type, upload_form_type,
															  upload_web_page, display_order, description,
															  attr_group_id, factor_group_id,
                                                                                                                          mage_category, mged_name
                                                                                                                FROM      $mimas.attribute
                                                                                                                WHERE     is_attribute = 1
															  AND
															  LOWER(name) = LOWER(?)",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
                                                   
                                                   select_by_factor_name           =>  {
                                                                                         sql                => "SELECT    attribute_id, name, deprecated, required,
                                                                                                                          is_attribute, is_factor, is_numeric, other,
															  none_na, search_form_type, upload_form_type,
															  upload_web_page, display_order, description,
															  attr_group_id, factor_group_id,
                                                                                                                          mage_category, mged_name
                                                                                                                FROM      $mimas.attribute
                                                                                                                WHERE     is_factor = 1
															  AND
															  name = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
                                                   
                                                   select_by_factor_name_ci        =>  {
                                                                                         sql                => "SELECT    attribute_id, name, deprecated, required,
                                                                                                                          is_attribute, is_factor, is_numeric, other,
															  none_na, search_form_type, upload_form_type,
															  upload_web_page, display_order, description,
															  attr_group_id, factor_group_id,
                                                                                                                          mage_category, mged_name
                                                                                                                FROM      $mimas.attribute
                                                                                                                WHERE     is_factor = 1
															  AND
															  LOWER(name) = LOWER(?)",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
                                                   
                                                   select_by_dbID                  =>  {
                                                                                         sql                => "SELECT    attribute_id, name, deprecated, required,
                                                                                                                          is_attribute, is_factor, is_numeric, other,
															  none_na, search_form_type, upload_form_type,
															  upload_web_page, display_order, description,
															  attr_group_id, factor_group_id,
                                                                                                                          mage_category, mged_name
                                                                                                                FROM      $mimas.attribute
                                                                                                                WHERE     attribute_id = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       }
                                                 },
    
                         FactorGroup         =>  {
                                                   select_all                      =>  {
                                                                                         sql                => "SELECT    attr_group_id as factor_group_id, name,
                                                                                                                          upload_display_order, view_display_order,
                                                                                                                          description
                                                                                                                FROM      $mimas.factor_group
                                                                                                                WHERE     type = 'factor'",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
                                                   
                                                   select_by_name                  =>  {
                                                                                         sql                => "SELECT    attr_group_id as factor_group_id, name,
                                                                                                                          upload_display_order, view_display_order,
                                                                                                                          description
                                                                                                                FROM      $mimas.factor_group
                                                                                                                WHERE     type = 'factor'
                                                                                                                          AND
                                                                                                                          name = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
                                                   
                                                   select_by_name_ci               =>  {
                                                                                         sql                => "SELECT    attr_group_id as factor_group_id, name,
                                                                                                                          upload_display_order, view_display_order,
                                                                                                                          description
                                                                                                                FROM      $mimas.factor_group
                                                                                                                WHERE     type = 'factor'
                                                                                                                          AND
                                                                                                                          LOWER(name) = LOWER(?)",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
                                                   
                                                   select_by_dbID                  =>  {
                                                                                         sql                => "SELECT    attr_group_id as factor_group_id, name,
                                                                                                                          upload_display_order, view_display_order,
                                                                                                                          description
                                                                                                                FROM      $mimas.factor_group
                                                                                                                WHERE     type = 'factor'
                                                                                                                          AND
                                                                                                                          factor_group_id = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       }
                                                 },
    
                         Incrementer         =>  {
                                                   get_new_groupID                 =>  {
                                                                                         sequence           => ["$mimas.seq_attr_group", "max(attr_group_id) FROM $mimas.attr_group"],
                                                                                         
                                                                                         method             => 'selectrow_array'
                                                                                       },
                                                   
                                                   get_new_attrID                  =>  {
                                                                                         sequence           => ["$mimas.seq_attribute", "max(attr_group_id) FROM $mimas.attr_group"],
                                                                                         
                                                                                         method             => 'selectrow_array'
                                                                                       },
                                                   
                                                   get_new_detail_groupID          =>  {
                                                                                         sequence           => ["$mimas.seq_detail_group", "max(attr_detail_group_id) FROM $mimas.attr_detail_group"],
                                                                                         
                                                                                         method             => 'selectrow_array'
                                                                                       },
                                                   
                                                   get_new_detailID                =>  {
                                                                                         sequence           => ["$mimas.seq_attr_detail", "max(attr_detail_id) FROM $mimas.attr_detail"],
                                                                                         
                                                                                         method             => 'selectrow_array'
                                                                                       },
                                                   
						   get_new_technologyID            =>  {
                                                                                         sequence           => ["$mimas.seq_technology", "max(technology_id) FROM $mimas.technology"],
                                                                                         
                                                                                         method             => 'selectrow_array'
                                                                                       },
                                                   
                                                   get_new_arrayID                 =>  {
                                                                                         sequence           => ["$mimas.seq_array", "max(array_id) FROM $mimas.array"],
                                                                                         
                                                                                         method             => 'selectrow_array'
                                                                                       }
                                                 }
                       },
    
    Upload         =>  {
                         Auth                =>  {
			                           auth_owner                      =>  {
                                                                                         sql                => "SELECT    owner_id
                                                                                                                FROM      $mimas.up_experiment
                                                                                                                WHERE     state = ?
                                                                                                                          AND
                                                                                                                          owner_id = ?
                                                                                                                          AND 
                                                                                                                          experiment_id = ?",
                                                                                         
                                                                                         method             => 'selectrow_arrayref'
                                                                                       },

                                                   auth_reader                     =>  {
                                                                                         sql                => "SELECT    owner_id
                                                                                                                FROM      $mimas.up_experiment A INNER JOIN ($TMP_VIEW_USER_EXP_PRIVILEGE) B
                                                                                                                          ON A.experiment_id = B.experiment_id
                                                                                                                WHERE
                                                                                                                          B.user_id = ?
                                                                                                                          AND 
                                                                                                                          A.experiment_id = ?
                                                                                                                          ",
                                                                                         
                                                                                         method             => 'selectrow_arrayref'
                                                                                       },

                                                   auth_writer                     =>  {
                                                                                         sql                => "SELECT    owner_id
                                                                                                                FROM      $mimas.up_experiment A INNER JOIN ($TMP_VIEW_USER_EXP_PRIVILEGE) B
                                                                                                                          ON A.experiment_id = B.experiment_id
                                                                                                                WHERE     B.user_id = ?
                                                                                                                          AND 
                                                                                                                          A.experiment_id = ?
                                                                                                                          AND
                                                                                                                          B.can_write = 1
                                                                                                                          ",
                                                                                         
                                                                                         method             => 'selectrow_arrayref'
                                                                                       },
			                           
                                                   auth_writer_state               =>  {
                                                                                         sql                => "SELECT    owner_id
                                                                                                                FROM      $mimas.up_experiment A INNER JOIN ($TMP_VIEW_USER_EXP_PRIVILEGE) B
                                                                                                                          ON A.experiment_id = B.experiment_id
                                                                                                                WHERE     A.state = ?
                                                                                                                          AND
                                                                                                                          B.user_id = ?
                                                                                                                          AND 
                                                                                                                          A.experiment_id = ?
                                                                                                                          AND
                                                                                                                          B.can_write = 1
                                                                                                                          ",
                                                                                         
                                                                                         method             => 'selectrow_arrayref'
                                                                                       },
			                           
                                                   auth_curator                    =>  {
                                                                                         sql                => "SELECT    owner_id
                                                                                                                FROM      $mimas.up_experiment
                                                                                                                WHERE     state = ?
                                                                                                                          AND
                                                                                                                          curator_id = ?
                                                                                                                          AND 
                                                                                                                          experiment_id = ?",
                                                                                         
                                                                                         method             => 'selectrow_arrayref'
                                                                                       }
                                                 },
                         
                         ExpAttribute        =>  {
			                           select_all                      =>  {
                                                                                         sql                => "SELECT    exp_attribute_id, char_value, numeric_value,
                                                                                                                          attr_detail_id, attribute_id, experiment_id
                                                                                                                FROM      $mimas.up_exp_attribute",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} },
                                                                                         
                                                                                         LongReadLen        => {
                                                                                                                 sql      => "SELECT    MAX(LENGTH(char_value))
                                                                                                                              FROM      $mimas.up_exp_attribute",
                                                                                                                 
                                                                                                                 method   => 'selectrow_array'
                                                                                                               }
                                                                                       },
			                           
			                           select_all_by_expID             =>  {
                                                                                         sql                => "SELECT    exp_attribute_id, char_value, numeric_value,
                                                                                                                          attr_detail_id, attribute_id, experiment_id
                                                                                                                FROM      $mimas.up_exp_attribute
                                                                                                                WHERE     experiment_id = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} },
                                                                                         
                                                                                         LongReadLen        => {
                                                                                                                 sql      => "SELECT    MAX(LENGTH(char_value))
                                                                                                                              FROM      $mimas.up_exp_attribute
                                                                                                                              WHERE     experiment_id = ?",
                                                                                                                 
                                                                                                                 method   => 'selectrow_array'
                                                                                                               }
                                                                                       },

			                           select_all_by_attr_name_expID   =>  {
                                                                                          sql                => "SELECT    A.exp_attribute_id, A.char_value, A.numeric_value,
                                                                                                                           A.attr_detail_id, A.attribute_id, A.experiment_id
                                                                                                                 FROM      $mimas.up_exp_attribute A INNER JOIN $mimas.attribute B
                                                                                                                           ON A.attribute_id = B.attribute_id
                                                                                                                 WHERE     B.name = ?
                                                                                                                           AND
                                                                                                                           B.is_attribute = 1
                                                                                                                           AND
                                                                                                                           A.experiment_id = ?",
                                                                                          
                                                                                          method             => 'selectall_arrayref',
                                                                                          
                                                                                          attrs              => { Slice => {} },
                                                                                          
                                                                                          LongReadLen        => {
                                                                                                                  sql      => "SELECT    MAX(LENGTH(A.char_value))
                                                                                                                               FROM      $mimas.up_exp_attribute A INNER JOIN $mimas.attribute B
                                                                                                                                         ON A.attribute_id = B.attribute_id
                                                                                                                               WHERE     B.name = ?
                                                                                                                                         AND
                                                                                                                                         B.is_attribute = 1
                                                                                                                                         AND
                                                                                                                                         A.experiment_id = ?",
                                                                                                                  
                                                                                                                  method   => 'selectrow_array'
                                                                                                                }
                                                                                       },
			                           
			                           
			                           select_by_dbID                  =>  {
                                                                                         sql                => "SELECT    exp_attribute_id, char_value, numeric_value,
                                                                                                                          attr_detail_id, attribute_id, experiment_id
                                                                                                                FROM      $mimas.up_exp_attribute
                                                                                                                WHERE     exp_attribute_id = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref',
                                                                                         
                                                                                         LongReadLen        => {
                                                                                                                 sql      => "SELECT    LENGTH(char_value)
                                                                                                                              FROM      $mimas.up_exp_attribute
                                                                                                                              WHERE     exp_attribute_id = ?",
                                                                                                                 
                                                                                                                 method   => 'selectrow_array'
                                                                                                               }
                                                                                       }
                                                 },
                         
                         ExpCondition        =>  {
			                           select_all                      =>  {
                                                                                         sql                => "SELECT    condition_id, name, display_order, experiment_id,
                                                                                                                          color
                                                                                                                FROM      $mimas.up_exp_condition",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
			                           
			                           select_all_by_expID             =>  {
                                                                                         sql                => "SELECT    condition_id, name, display_order, experiment_id,
                                                                                                                          color
                                                                                                                FROM      $mimas.up_exp_condition
                                                                                                                WHERE     experiment_id = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
			                           
			                           select_all_with_color           =>  {
                                                                                         sql                => "SELECT    condition_id, name, display_order, experiment_id,
                                                                                                                          color
                                                                                                                FROM      $mimas.up_exp_condition
                                                                                                                WHERE     color IS NOT NULL",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
			                           
			                           select_by_sampleID              =>  {
                                                                                         sql                => "SELECT    A.condition_id, A.name, A.display_order, A.experiment_id,
                                                                                                                          color
                                                                                                                FROM      $mimas.up_exp_condition A INNER JOIN $mimas.up_sample B
                                                                                                                          ON A.condition_id = B.condition_id
                                                                                                                WHERE     B.sample_id = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
			                           
			                           select_by_dbID                  =>  {
                                                                                         sql                => "SELECT    condition_id, name, display_order, experiment_id,
                                                                                                                          color
                                                                                                                FROM      $mimas.up_exp_condition
                                                                                                                WHERE     condition_id = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       }
                                                 },
                         
                         Experiment          =>  {
			                           select_all                      =>  {
                                                                                         sql                => "SELECT    experiment_id, name, num_hybrids, progress,
                                                                                                                          state, owner_id, curator_id
                                                                                                                FROM      $mimas.up_experiment",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
			                           
			                           select_all_by_state             =>  {
                                                                                         sql                => "SELECT    experiment_id, name, num_hybrids, progress,
                                                                                                                          state, owner_id, curator_id
                                                                                                                FROM      $mimas.up_experiment
                                                                                                                WHERE     state = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
			                           
			                           select_all_by_ownerID           =>  {
                                                                                         sql                => "SELECT    experiment_id, name, num_hybrids, progress,
                                                                                                                          state, owner_id, curator_id
                                                                                                                FROM      $mimas.up_experiment
                                                                                                                WHERE     owner_id = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
			                           
			                           select_all_by_curatorID         =>  {
                                                                                         sql                => "SELECT    experiment_id, name, num_hybrids, progress,
                                                                                                                          state, owner_id, curator_id
                                                                                                                FROM      $mimas.up_experiment
                                                                                                                WHERE     curator_id = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
			                           
			                           select_by_dbID                  =>  {
                                                                                         sql                => "SELECT    experiment_id, name, num_hybrids, progress,
                                                                                                                          state, owner_id, curator_id
                                                                                                                FROM      $mimas.up_experiment
                                                                                                                WHERE     experiment_id = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       }
                                                 },
                         
                         Incrementer         =>  {
			                           get_new_expID                   =>  {
                                                                                         sequence           => ["$mimas.seq_up_experiment", "max(experiment_id) FROM $mimas.up_experiment"],
                                                                                         
                                                                                         method             => 'selectrow_array'
                                                                                       },
                                                   
						   get_new_condID                  =>  {
                                                                                         sequence           => ["$mimas.seq_up_exp_condition", "max(condition_id) FROM $mimas.up_exp_condition"],
                                                                                         
                                                                                         method             => 'selectrow_array'
                                                                                       },
			                           
			                           get_new_sampleID                =>  {
                                                                                         sequence           => ["$mimas.seq_up_sample", "max(sample_id) FROM $mimas.up_sample"],
                                                                                         
                                                                                         method             => 'selectrow_array'
                                                                                       },
			                           
			                           get_new_sample_fileID           =>  {
                                                                                         sequence           => ["$mimas.seq_up_sample_file", "max(sample_file_id) FROM $mimas.up_sample_file"],
                                                                                         
                                                                                         method             => 'selectrow_array'
                                                                                       },
			                           
			                           get_new_sample_to_fileID        =>  {
                                                                                         sequence           => ["$mimas.seq_up_sample_to_file", "max(sample_to_file_id) FROM $mimas.up_sample_to_file"],
                                                                                         
                                                                                         method             => 'selectrow_array'
                                                                                       },
			                           
			                           get_new_exp_attrID              =>  {
                                                                                         sequence           => ["$mimas.seq_up_exp_attr", "max(exp_attribute_id) FROM $mimas.up_exp_attribute"],
                                                                                         
                                                                                         method             => 'selectrow_array'
                                                                                       },
			                           
			                           get_new_sample_attrID           =>  {
                                                                                         sequence           => ["$mimas.seq_up_sample_attr", "max(sample_attribute_id) FROM $mimas.up_sample_attribute"],
                                                                                         
                                                                                         method             => 'selectrow_array'
                                                                                       }
                                                 },
                         
                         Sample              =>  {
			                           select_all                      =>  {
                                                                                         sql                => "SELECT    sample_id, name,
                                                                                                                          attrs_complete, attrs_exist, array_id,
                                                                                                                          condition_id, experiment_id
                                                                                                                FROM      $mimas.up_sample",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
			                           
			                           select_all_by_expID             =>  {
                                                                                         sql                => "SELECT    sample_id, name,
                                                                                                                          attrs_complete, attrs_exist, array_id,
                                                                                                                          condition_id, experiment_id
                                                                                                                FROM      $mimas.up_sample
                                                                                                                WHERE     experiment_id = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
			                           
			                           select_all_by_condID            =>  {
                                                                                         sql                => "SELECT    sample_id, name,
                                                                                                                          attrs_complete, attrs_exist, array_id,
                                                                                                                          condition_id, experiment_id
                                                                                                                FROM      $mimas.up_sample
                                                                                                                WHERE     condition_id = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
			                           
			                           select_all_by_ensembl_array_name=>  {
                                                                                         sql                => "SELECT    S.sample_id, S.name,
                                                                                                                          S.attrs_complete, S.attrs_exist, S.array_id,
                                                                                                                          S.condition_id, S.experiment_id
                                                                                                                FROM      $mimas.up_sample S
                                                                                                                JOIN      $mimas.array R ON (R.array_id = S.array_id)
                                                                                                                WHERE     LOWER(REPLACE(?, '-', '_')) = LOWER(REPLACE(R.design_name, '-', '_'))
                                                                                                                ",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },

			                           select_all_by_sample_file_id    =>  {
                                                                                         sql                => "SELECT    sample_id, name,
                                                                                                                          attrs_complete, attrs_exist, array_id,
                                                                                                                          condition_id, experiment_id
                                                                                                                FROM      $mimas.up_sample 
                                                                                                                WHERE     sample_id IN (SELECT sample_id FROM $mimas.up_sample_to_file WHERE
                                                                                                                            sample_file_id=?)",
                                                                                                                
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },

			                           
			                           select_by_dbID                  =>  {
                                                                                         sql                => "SELECT    sample_id, name,
                                                                                                                          attrs_complete, attrs_exist, array_id,
                                                                                                                          condition_id, experiment_id
                                                                                                                FROM      $mimas.up_sample
                                                                                                                WHERE     sample_id = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
			                           
			                           select_by_expID_name            =>  {
                                                                                         sql                => "SELECT    sample_id, name,
                                                                                                                          attrs_complete, attrs_exist, array_id,
                                                                                                                          condition_id, experiment_id
                                                                                                                FROM      $mimas.up_sample
                                                                                                                WHERE     experiment_id = ? AND LOWER(name) = LOWER(?)",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },

                                                 },
                         
                         SampleAttribute     =>  {
			                           select_all                      =>  {
                                                                                         sql                => "SELECT    sample_attribute_id, char_value, numeric_value,
                                                                                                                          attr_detail_id, attribute_id, sample_id
                                                                                                                FROM      $mimas.up_sample_attribute",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} },
                                                                                         
                                                                                         LongReadLen        => {
                                                                                                                 sql      => "SELECT    MAX(LENGTH(char_value))
                                                                                                                              FROM      $mimas.up_sample_attribute",
                                                                                                                 
                                                                                                                 method   => 'selectrow_array'
                                                                                                               }
                                                                                       },
			                           
			                           select_all_by_expID             =>  {
                                                                                         sql                => "SELECT    A.sample_attribute_id, A.char_value, A.numeric_value,
                                                                                                                          A.attr_detail_id, A.attribute_id, A.sample_id
                                                                                                                FROM      $mimas.up_sample_attribute A INNER JOIN $mimas.up_sample B 
                                                                                                                          ON A.sample_id = B.sample_id
                                                                                                                WHERE     B.experiment_id = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} },
                                                                                         
                                                                                         LongReadLen        => {
                                                                                                                 sql      => "SELECT    MAX(LENGTH(A.char_value))
                                                                                                                              FROM      $mimas.up_sample_attribute A INNER JOIN $mimas.up_sample B 
                                                                                                                                        ON A.sample_id = B.sample_id
                                                                                                                              WHERE     B.experiment_id = ?",
                                                                                                                 
                                                                                                                 method   => 'selectrow_array'
                                                                                                               }
                                                                                       },
			                           
			                           select_all_by_sampleID          =>  {
                                                                                         sql                => "SELECT    sample_attribute_id, char_value, numeric_value,
                                                                                                                          attr_detail_id, attribute_id, sample_id
                                                                                                                FROM      $mimas.up_sample_attribute
                                                                                                                WHERE     sample_id = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} },
                                                                                         
                                                                                         LongReadLen        => {
                                                                                                                 sql      => "SELECT    MAX(LENGTH(char_value))
                                                                                                                              FROM      $mimas.up_sample_attribute
                                                                                                                              WHERE     sample_id = ?",
                                                                                                                 
                                                                                                                 method   => 'selectrow_array'
                                                                                                               }
                                                                                       },
			                           
			                           select_all_extended_by_sampleID =>  {
                                                                                         sql                => "SELECT    NULL AS sample_attribute_id, char_value, numeric_value,
                                                                                                                          attr_detail_id, attribute_id, sample_id
                                                                                                                FROM      ($TMP_VIEW_SAMPLE_ATTRIBUTE) D
                                                                                                                WHERE     sample_id = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} },
                                                                                         
                                                                                         LongReadLen        => {
                                                                                                                 sql      => "SELECT    MAX(LENGTH(char_value))
                                                                                                                              FROM      ($TMP_VIEW_SAMPLE_ATTRIBUTE) D
                                                                                                                              WHERE     sample_id = ?",
                                                                                                                 
                                                                                                                 method   => 'selectrow_array'
                                                                                                               }
                                                                                       },
			                           
			                           select_by_dbID                  =>  {
                                                                                         sql                => "SELECT    sample_attribute_id, char_value, numeric_value,
                                                                                                                          attr_detail_id, attribute_id, sample_id
                                                                                                                FROM      $mimas.up_sample_attribute
                                                                                                                WHERE     sample_attribute_id = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref',
                                                                                         
                                                                                         LongReadLen        => {
                                                                                                                 sql      => "SELECT    LENGTH(char_value)
                                                                                                                              FROM      $mimas.up_sample_attribute
                                                                                                                              WHERE     sample_attribute_id = ?",
                                                                                                                 
                                                                                                                 method   => 'selectrow_array'
                                                                                                               }
                                                                                       }
                                                 },
                         
                         # By default, the SampleFileAdaptor creates SampleFile objects without the BLOB data "contents" property
                         # So we do not select the "contents" column and we do not need to calculate the LongReadLen.
                         # When the programmer then tries to access the "contents" property by saying $sample_file->contents_ptr
                         # then the "fetch_contents_by_sample_fileID" SQL statement is called below
                         
                         SampleFile          =>  {
			                           select_all                      =>  {
                                                                                         sql                => "SELECT    A.sample_file_id, A.format, A.experiment_id,
                                                                                                                          A.upload_date, A.hybridization_date,
                                                                                                                          A.fingerprint, A.file_name
                                                                                                                FROM      $mimas.up_sample_file A
                                                                                                                ",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
			                           
			                           select_all_by_expID             =>  {
                                                                                         sql                => "SELECT    A.sample_file_id, A.format, A.experiment_id,
                                                                                                                          A.upload_date, A.hybridization_date,
                                                                                                                          A.fingerprint, A.file_name
                                                                                                                FROM      $mimas.up_sample_file A
                                                                                                                INNER JOIN $mimas.up_sample_to_file J
                                                                                                                        ON A.sample_file_id = J.sample_file_id
                                                                                                                INNER JOIN $mimas.up_sample B ON B.sample_id = J.sample_id
                                                                                                                WHERE     B.experiment_id = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
			                           
			                           select_all_by_condID            =>  {
                                                                                         sql                => "SELECT    A.sample_file_id, A.format, A.experiment_id,
                                                                                                                          A.upload_date, A.hybridization_date,
                                                                                                                          A.fingerprint, A.file_name
                                                                                                                FROM      $mimas.up_sample_file A
                                                                                                                INNER JOIN $mimas.up_sample_to_file J
                                                                                                                        ON A.sample_file_id = J.sample_file_id
                                                                                                                INNER JOIN $mimas.up_sample B ON B.sample_id = J.sample_id
                                                                                                                WHERE     B.condition_id = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },

			                           select_all_by_sampleID          =>  {
                                                                                         sql                => "SELECT    A.sample_file_id, A.format, A.experiment_id,
                                                                                                                          A.upload_date, A.hybridization_date,
                                                                                                                          A.fingerprint, A.file_name
                                                                                                                FROM      $mimas.up_sample_file A
                                                                                                                INNER JOIN $mimas.up_sample_to_file J
                                                                                                                        ON A.sample_file_id = J.sample_file_id
                                                                                                                WHERE     J.sample_id = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
			                           
			                           select_all_germonline_by_expID  =>  {
                                                                                         sql                => "SELECT    A.sample_file_id, A.format, A.experiment_id,
                                                                                                                          A.upload_date, A.hybridization_date,
                                                                                                                          A.fingerprint, A.file_name
                                                                                                                FROM      $mimas.up_sample_file A
                                                                                                                INNER JOIN $mimas.up_sample_to_file J
                                                                                                                           ON J.sample_file_id = A.sample_file_id
                                                                                                                WHERE     J.is_germonline = 1
                                                                                                                AND       A.experiment_id = ?
                                                                                                                ",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },

			                           select_by_dbID                  =>  {
                                                                                         sql                => "SELECT    A.sample_file_id, A.format, A.experiment_id,
                                                                                                                          A.upload_date, A.hybridization_date,
                                                                                                                          A.fingerprint, A.file_name
                                                                                                                FROM      $mimas.up_sample_file A
                                                                                                                WHERE     sample_file_id = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
                                                   
			                           select_by_expID_fingerprint     =>  {
                                                                                         sql                => "SELECT    A.sample_file_id, A.format, A.experiment_id,
                                                                                                                          A.upload_date, A.hybridization_date,
                                                                                                                          A.fingerprint, A.file_name
                                                                                                                FROM      $mimas.up_sample_file A
                                                                                                                WHERE     experiment_id = ?
                                                                                                                          AND fingerprint = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
                                                 },

                         SampleToFile        =>  {
			                           select_all                      =>  {
                                                                                         sql                => "SELECT    A.sample_to_file_id, A.sample_id,
                                                                                                                          A.sample_file_id, A.format, A.is_germonline,
                                                                                                                          A.hybridization_name
                                                                                                                FROM      $mimas.up_sample_to_file A
                                                                                                                ",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
			                           
			                           select_all_by_expID             =>  {
                                                                                         sql                => "SELECT    A.sample_to_file_id, A.sample_id,
                                                                                                                          A.sample_file_id, A.format, A.is_germonline,
                                                                                                                          A.hybridization_name
                                                                                                                FROM      $mimas.up_sample_to_file A
                                                                                                                INNER JOIN $mimas.up_sample B ON B.sample_id = A.sample_id
                                                                                                                WHERE     B.experiment_id = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
			                           
			                           select_all_by_condID            =>  {
                                                                                         sql                => "SELECT    A.sample_to_file_id, A.sample_id,
                                                                                                                          A.sample_file_id, A.format, A.is_germonline,
                                                                                                                          A.hybridization_name
                                                                                                                FROM      $mimas.up_sample_to_file A
                                                                                                                INNER JOIN $mimas.up_sample B ON B.sample_id = A.sample_id
                                                                                                                WHERE     B.condition_id = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
			                           
			                           select_all_by_sampleID          =>  {
                                                                                         sql                => "SELECT    A.sample_to_file_id, A.sample_id,
                                                                                                                          A.sample_file_id, A.format, A.is_germonline,
                                                                                                                          A.hybridization_name
                                                                                                                FROM      $mimas.up_sample_to_file A
                                                                                                                WHERE     A.sample_id = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
			                           
			                           select_all_by_sample_file_id    =>  {
                                                                                         sql                => "SELECT    A.sample_to_file_id, A.sample_id,
                                                                                                                          A.sample_file_id, A.format, A.is_germonline,
                                                                                                                          A.hybridization_name
                                                                                                                FROM      $mimas.up_sample_to_file A
                                                                                                                WHERE     A.sample_file_id = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
			                           
			                           select_all_germonline           =>  {
                                                                                         sql                => "SELECT    A.sample_to_file_id, A.sample_id,
                                                                                                                          A.sample_file_id, A.format, A.is_germonline,
                                                                                                                          A.hybridization_name
                                                                                                                FROM      $mimas.up_sample_to_file A
                                                                                                                WHERE     A.is_germonline = 1",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
			                           
			                           select_all_germonline_by_expID  =>  {
                                                                                         sql                => "SELECT    A.sample_to_file_id, A.sample_id,
                                                                                                                          A.sample_file_id, A.format, A.is_germonline,
                                                                                                                          A.hybridization_name
                                                                                                                FROM      $mimas.up_sample_to_file A
                                                                                                                INNER JOIN $mimas.up_sample S ON S.sample_id = A.sample_id
                                                                                                                WHERE     A.is_germonline = 1
                                                                                                                AND       S.experiment_id = ?
                                                                                                                ",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
			                           
			                           select_by_dbID                  =>  {
                                                                                         sql                => "SELECT    A.sample_to_file_id, A.sample_id,
                                                                                                                          A.sample_file_id, A.format, A.is_germonline,
                                                                                                                          A.hybridization_name
                                                                                                                FROM      $mimas.up_sample_to_file A
                                                                                                                WHERE     sample_to_file_id = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },

			                           select_by_expID_name_format  =>  {
                                                                                         sql                => "SELECT    A.sample_to_file_id, A.sample_id,
                                                                                                                          A.sample_file_id, A.format, A.is_germonline,
                                                                                                                          A.hybridization_name
                                                                                                                FROM      $mimas.up_sample_to_file A
                                                                                                                INNER JOIN $mimas.up_sample S ON S.sample_id = A.sample_id
                                                                                                                WHERE     S.experiment_id = ?
                                                                                                                          AND LOWER(S.name) = LOWER(?)
                                                                                                                          AND format = ?
                                                                                                                ",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },

			                           select_by_dbID                  =>  {
                                                                                         sql                => "SELECT    A.sample_to_file_id, A.sample_id,
                                                                                                                          A.sample_file_id, A.format, A.is_germonline,
                                                                                                                          A.hybridization_name
                                                                                                                FROM      $mimas.up_sample_to_file A
                                                                                                                WHERE     sample_to_file_id = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
                                                   
                                                 },

                         SampleFileData      =>  {

						   fetch_contents_by_sample_fileID =>  {
                                                                                         sql                => "SELECT    contents
                                                                                                                FROM      $mimas.up_sample_file_data
                                                                                                                WHERE     sample_file_id = ?
                                                                                                                ORDER BY  chunk_number
                                                                                                                ",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         LongReadLen        => {
                                                                                                                 sql      => "SELECT    max(LENGTH(contents))
                                                                                                                              FROM      $mimas.up_sample_file_data
                                                                                                                              WHERE     sample_file_id = ?",
                                                                                                                 
                                                                                                                 method   => 'selectrow_array'
                                                                                                               }
                                                                                       },

						   fetch_max_chunk_size_by_sample_fileID =>  {
                                                                                         sql                => "SELECT    max(length(contents))
                                                                                                                FROM      $mimas.up_sample_file_data
                                                                                                                WHERE     sample_file_id = ?
                                                                                                                ",
                                                                                         
                                                                                         method             => 'selectrow_arrayref',
                                                                                         
                                                                                       },
                                                 },

                         GroupExpPrivilege   =>  {
			                           
			                           select_all_by_expID             =>  {
                                                                                         sql                => "SELECT    group_id, experiment_id, can_write
                                                                                                                FROM      $mimas.group_exp_privilege
                                                                                                                WHERE     experiment_id = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} },
                                                                                         
                                                                                       },
                                                 },
                         
                       },
    
    User           =>  {
                         Auth                =>  {
			                           auth_admin                      =>  {
                                                                                         sql                => "SELECT    A.user_id
                                                                                                                FROM      $mimas.mimas_user A INNER JOIN $mimas.user_to_group B
                                                                                                                          ON A.user_id = B.user_id
                                                                                                                WHERE     A.user_id = ?
                                                                                                                          AND
                                                                                                                          B.group_id = 1",  # MIMAS Adminstrators Group ID
                                                                                         
                                                                                         method             => 'selectrow_arrayref'
                                                                                       },
			                           
			                           auth_curator                    =>  {
                                                                                         sql                => "SELECT    A.user_id
                                                                                                                FROM      $mimas.mimas_user A INNER JOIN $mimas.user_to_group B
                                                                                                                          ON A.user_id = B.user_id
                                                                                                                WHERE     A.user_id = ?
                                                                                                                          AND
                                                                                                                          B.group_id = 2",  # MIMAS Curators group ID
                                                                                         
                                                                                         method             => 'selectrow_arrayref'
                                                                                       },
			                           
			                           auth_login                      =>  {
                                                                                         sql                => "SELECT    A.user_id
                                                                                                                FROM      $mimas.mimas_user A INNER JOIN $mimas.user_to_group B
                                                                                                                          ON A.user_id = B.user_id
                                                                                                                WHERE     A.username = ? 
                                                                                                                          AND 
                                                                                                                          A.password = ?
                                                                                                                          AND
                                                                                                                          A.disabled = 0
																														  ", #-- AND B.group_id = 3 --# MIMAS Registered Users Group ID
                                                                    
                                                                                         method             => 'selectrow_array'  # need to return the User ID
                                                                                       }
                                                 },
                         
                         Country             =>  {
                                                   select_all                      =>  {
                                                                                         sql                => "SELECT    country_id, name
                                                                                                                FROM      $mimas.country",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
                                                   
                                                   select_by_name                  =>  {
                                                                                         sql                => "SELECT    country_id, name
                                                                                                                FROM      $mimas.country
                                                                                                                WHERE     name = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
                                                   
                                                   select_by_name_ci               =>  {
                                                                                         sql                => "SELECT    country_id, name
                                                                                                                FROM      $mimas.country
                                                                                                                WHERE     LOWER(name) = LOWER(?)",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
                                                   
                                                   select_by_dbID                  =>  {
                                                                                         sql                => "SELECT    country_id, name
                                                                                                                FROM      $mimas.country
                                                                                                                WHERE     country_id = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       }
                                                 },
                         
                         Group               =>  {
                                                   select_all                      =>  {
                                                                                         sql                => "SELECT    A.group_id, A.name,
                                                                                                                          A.is_default_reader, A.is_default_writer,
                                                                                                                          A.is_system, A.is_auto,
                                                                                                                          A.restrict_level, A.description
                                                                                                                FROM      $mimas.mimas_group A",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
                                                   
                                                   select_all_by_userID            =>  {
                                                                                         sql                => "SELECT    A.group_id, A.name,
                                                                                                                          A.is_default_reader, A.is_default_writer,
                                                                                                                          A.is_system, A.is_auto,
                                                                                                                          A.restrict_level, A.description
                                                                                                                FROM      $mimas.mimas_group A INNER JOIN $mimas.user_to_group B
                                                                                                                          ON A.group_id = B.group_id
                                                                                                                WHERE     B.user_id = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
                                                   
                                                   select_all_read_by_expID        =>  {
                                                                                         sql                => "SELECT    A.group_id, A.name,
                                                                                                                          A.is_default_reader, A.is_default_writer,
                                                                                                                          A.is_system, A.is_auto,
                                                                                                                          A.restrict_level, A.description
                                                                                                                FROM      $mimas.mimas_group A INNER JOIN $mimas.group_exp_privilege B
                                                                                                                          ON A.group_id = B.group_id
                                                                                                                WHERE     B.experiment_id = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
                                                   
                                                   select_all_write_by_expID       =>  {
                                                                                         sql                => "SELECT    A.group_id, A.name,
                                                                                                                          A.is_default_reader, A.is_default_writer,
                                                                                                                          A.is_system, A.is_auto,
                                                                                                                          A.restrict_level, A.description
                                                                                                                FROM      $mimas.mimas_group A INNER JOIN $mimas.group_exp_privilege B
                                                                                                                          ON A.group_id = B.group_id
                                                                                                                WHERE     B.experiment_id = ? AND B.can_write = 1",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
                                                   
                                                   select_by_name                  =>  {
                                                                                         sql                => "SELECT    A.group_id, A.name,
                                                                                                                          A.is_default_reader, A.is_default_writer,
                                                                                                                          A.is_system, A.is_auto,
                                                                                                                          A.restrict_level, A.description
                                                                                                                FROM      $mimas.mimas_group A
                                                                                                                WHERE     name = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
                                                   
                                                   select_by_name_ci               =>  {
                                                                                         sql                => "SELECT    Agroup_id, A.name,
                                                                                                                          A.is_default_reader, A.is_default_writer,
                                                                                                                          A.is_system, A.is_auto,
                                                                                                                          A.restrict_level, A.description
                                                                                                                FROM      $mimas.mimas_group A
                                                                                                                WHERE     LOWER(name) = LOWER(?)",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
                                                   
                                                   select_by_dbID                  =>  {
                                                                                         sql                => "SELECT    A.group_id, A.name,
                                                                                                                          A.is_default_reader, A.is_default_writer,
                                                                                                                          A.is_system, A.is_auto,
                                                                                                                          A.restrict_level, A.description
                                                                                                                FROM      $mimas.mimas_group A
                                                                                                                WHERE     group_id = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       }
                                                 },
                         
                         Lab                 =>  {
                                                   select_all                      =>  {
                                                                                         sql                => "SELECT    lab_id, name, address, postcode, state, city,
                                                                                                                          url, pi_name, pi_email, valid, organization_id
                                                                                                                FROM      $mimas.lab",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
                                                   
                                                   select_all_valid                =>  {
                                                                                         sql                => "SELECT    lab_id, name, address, postcode, state, city,
                                                                                                                          url, pi_name, pi_email, valid, organization_id
                                                                                                                FROM      $mimas.lab
                                                                                                                WHERE     valid = 1",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
                                                   
                                                   select_all_by_orgID             =>  {
                                                                                         sql                => "SELECT    lab_id, name, address, postcode, state, city,
                                                                                                                          url, pi_name, pi_email, valid, organization_id
                                                                                                                FROM      $mimas.lab
                                                                                                                WHERE     organization_id = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
                                                   
                                                   select_by_name                  =>  {
                                                                                         sql                => "SELECT    lab_id, name, address, postcode, state, city,
                                                                                                                          url, pi_name, pi_email, valid, organization_id
                                                                                                                FROM      $mimas.lab
                                                                                                                WHERE     name = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
                                                   
                                                   select_by_name_ci               =>  {
                                                                                         sql                => "SELECT    lab_id, name, address, postcode, state, city,
                                                                                                                          url, pi_name, pi_email, valid, organization_id
                                                                                                                FROM      $mimas.lab
                                                                                                                WHERE     LOWER(name) = LOWER(?)",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
                                                   
                                                   select_by_pi_email              =>  {
                                                                                         sql                => "SELECT    lab_id, name, address, postcode, state, city,
                                                                                                                          url, pi_name, pi_email, valid, organization_id
                                                                                                                FROM      $mimas.lab
                                                                                                                WHERE     pi_email = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
                                                   
                                                   select_by_pi_email_ci           =>  {
                                                                                         sql                => "SELECT    lab_id, name, address, postcode, state, city,
                                                                                                                          url, pi_name, pi_email, valid, organization_id
                                                                                                                FROM      $mimas.lab
                                                                                                                WHERE     LOWER(pi_email) = LOWER(?)",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
                                                   
                                                   select_by_dbID                  =>  {
                                                                                         sql                => "SELECT    lab_id, name, address, postcode, state, city,
                                                                                                                          url, pi_name, pi_email, valid, organization_id
                                                                                                                FROM      $mimas.lab
                                                                                                                WHERE     lab_id = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       }
                                                 },
                         
                         Incrementer         =>  {
                                                   get_new_labID                   =>  {
                                                                                         sequence           => ["$mimas.seq_lab", "max(lab_id) FROM $mimas.lab"],
                                                                                         
                                                                                         method             => 'selectrow_array'
                                                                                       },
			                           
			                           get_new_orgID                   =>  {
                                                                                         sequence           => ["$mimas.seq_org", "max(organization_id) FROM $mimas.organization"],
                                                                                         
                                                                                         method             => 'selectrow_array'
                                                                                       },
			                           
			                           get_new_userID                  =>  {
                                                                                         sequence           => ["$mimas.seq_user", "max(user_id) FROM $mimas.mimas_user"],
                                                                                         
                                                                                         method             => 'selectrow_array'
                                                                                       },
                                                   
						   get_new_groupID                 =>  {
                                                                                         sequence           => ["$mimas.seq_user_group", "max(group_id) FROM $mimas.mimas_group"],
                                                                                         
                                                                                         method             => 'selectrow_array'
                                                                                       }
                                                 },
                         
                         Organization        =>  {
			                           select_all                      =>  {
                                                                                         sql                => "SELECT    organization_id, name, url, valid, country_id
                                                                                                                FROM      $mimas.organization",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
			                           
			                           select_all_valid                =>  {
                                                                                         sql                => "SELECT    organization_id, name, url, valid, country_id
                                                                                                                FROM      $mimas.organization
                                                                                                                WHERE     valid = 1",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
			                           
			                           select_by_name                  =>  {
                                                                                         sql                => "SELECT    organization_id, name, url, valid, country_id
                                                                                                                FROM      $mimas.organization
                                                                                                                WHERE     name = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
                                                   
                                                   select_by_name_ci               =>  {
                                                                                         sql                => "SELECT    organization_id, name, url, valid, country_id
                                                                                                                FROM      $mimas.organization
                                                                                                                WHERE     LOWER(name) = LOWER(?)",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       },
                                                   
                                                   select_by_dbID                  =>  {
                                                                                         sql                => "SELECT    organization_id, name, url, valid, country_id
                                                                                                                FROM      $mimas.organization
                                                                                                                WHERE     organization_id = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       }
                                                 },
                         
                         Title               =>  {
			                           select_all                      =>  {
                                                                                         sql                => "SELECT    title_id, name
                                                                                                                FROM      $mimas.title",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} }
                                                                                       },
			                           
			                           select_by_dbID                  =>  {
                                                                                         sql                => "SELECT    title_id, name
                                                                                                                FROM      $mimas.title
                                                                                                                WHERE     title_id = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref'
                                                                                       }
                                                 },
                         
                         User                =>  {
			                           select_all                      =>  {
                                                                                         sql                => "SELECT    user_id, username, password, disabled,
                                                                                                                          first_name, middle_name, last_name, position,
                                                                                                                          email, phone, fax, reg_date, working_data,
                                                                                                                          title_id, lab_id
                                                                                                                FROM      $mimas.mimas_user",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} },
                                                                                         
                                                                                         LongReadLen        => {
                                                                                                                 sql      => "SELECT    MAX(LENGTH(working_data))
                                                                                                                              FROM      $mimas.mimas_user",
                                                                                                                 
                                                                                                                 method   => 'selectrow_array'
                                                                                                               }
                                                                                       },
			                           
			                           select_all_enabled              =>  {
                                                                                         sql                => "SELECT    user_id, username, password, disabled,
                                                                                                                          first_name, middle_name, last_name, position,
                                                                                                                          email, phone, fax, reg_date, working_data,
                                                                                                                          title_id, lab_id
                                                                                                                FROM      $mimas.mimas_user
                                                                                                                WHERE     disabled = 0",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} },
                                                                                         
                                                                                         LongReadLen        => {
                                                                                                                 sql      => "SELECT    MAX(LENGTH(working_data))
                                                                                                                              FROM      $mimas.mimas_user
                                                                                                                              WHERE     disabled = 0",
                                                                                                                 
                                                                                                                 method   => 'selectrow_array'
                                                                                                               }
                                                                                       },
			                           
			                           select_all_disabled             =>  {
                                                                                         sql                => "SELECT    user_id, username, password, disabled,
                                                                                                                          first_name, middle_name, last_name, position,
                                                                                                                          email, phone, fax, reg_date, working_data,
                                                                                                                          title_id, lab_id
                                                                                                                FROM      $mimas.mimas_user
                                                                                                                WHERE     disabled = 1",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} },
                                                                                         
                                                                                         LongReadLen        => {
                                                                                                                 sql      => "SELECT    MAX(LENGTH(working_data))
                                                                                                                              FROM      $mimas.mimas_user
                                                                                                                              WHERE     disabled = 1",
                                                                                                                 
                                                                                                                 method   => 'selectrow_array'
                                                                                                               }
                                                                                       },
			                           
			                           select_all_with_sample          =>  {
                                                                                         sql                => "SELECT    user_id, username, password, disabled,
                                                                                                                          first_name, middle_name, last_name, position,
                                                                                                                          email, phone, fax, reg_date, working_data,
                                                                                                                          title_id, lab_id
                                                                                                                FROM      $mimas.mimas_user
                                                                                                                WHERE     exists(SELECT e.experiment_id FROM $mimas.up_experiment e JOIN $mimas.up_sample s ON e.experiment_id=s.experiment_id WHERE e.owner_id = mimas_user.user_id)
                                                                                                                ",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} },
                                                                                         
                                                                                         LongReadLen        => {
                                                                                                                 sql      => "SELECT    MAX(LENGTH(working_data))
                                                                                                                              FROM      $mimas.mimas_user
                                                                                                                             ",
                                                                                                                 
                                                                                                                 method   => 'selectrow_array'
                                                                                                               }
                                                                                       },
			                           
			                           select_all_by_labID             =>  {
                                                                                         sql                => "SELECT    user_id, username, password, disabled,
                                                                                                                          first_name, middle_name, last_name, position,
                                                                                                                          email, phone, fax, reg_date, working_data,
                                                                                                                          title_id, lab_id
                                                                                                                FROM      $mimas.mimas_user
                                                                                                                WHERE     lab_id = ?",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} },
                                                                                         
                                                                                         LongReadLen        => {
                                                                                                                 sql      => "SELECT    MAX(LENGTH(working_data))
                                                                                                                              FROM      $mimas.mimas_user
                                                                                                                              WHERE     lab_id = ?",
                                                                                                                 
                                                                                                                 method   => 'selectrow_array'
                                                                                                               }
                                                                                       },
			                           
			                           select_all_by_groupID_experiment        =>  {
                                                                                         sql                => "SELECT    A.user_id, A.username, A.password, A.disabled,
                                                                                                                          A.first_name, A.middle_name, A.last_name, A.position,
                                                                                                                          A.email, A.phone, A.fax, A.reg_date, A.working_data,
                                                                                                                          A.title_id, A.lab_id
                                                                                                                FROM      $mimas.mimas_user A
                                                                                                                          INNER JOIN ($TMP_VIEW_USER_TO_GROUP_EXT) B ON A.user_id = B.user_id
                                                                                                                WHERE     B.group_id = ?
                                                                                                                          AND (B.r_user_id = ? OR B.r_user_id IS NULL)
                                                                                                                          AND (B.r_lab_id = ? OR B.r_lab_id IS NULL)
                                                                                                                          AND (B.r_organization_id = ? OR B.r_organization_id IS NULL)
                                                                                                                          AND (B.r_facility_id = ? OR B.r_facility_id IS NULL)
                                                                                                                ",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} },
                                                                                         
                                                                                         LongReadLen        => {
                                                                                                                 sql      => "SELECT    MAX(LENGTH(A.working_data))
                                                                                                                FROM      $mimas.mimas_user A INNER JOIN ($TMP_VIEW_USER_TO_GROUP_EXT) B
                                                                                                                          ON A.user_id = B.user_id
                                                                                                                WHERE     B.group_id = ?
                                                                                                                          AND (B.r_user_id = ? OR B.r_user_id IS NULL)
                                                                                                                          AND (B.r_lab_id = ? OR B.r_lab_id IS NULL)
                                                                                                                          AND (B.r_organization_id = ? OR B.r_organization_id IS NULL)
                                                                                                                          AND (B.r_facility_id = ? OR B.r_facility_id IS NULL)
                                                                                                                          ",
                                                                                                                 
                                                                                                                 method   => 'selectrow_array'
                                                                                                               }
                                                                                       },
			                           
			                           select_by_email                 =>  {
                                                                                         sql                => "SELECT    user_id, username, password, disabled,
                                                                                                                          first_name, middle_name, last_name, position,
                                                                                                                          email, phone, fax, reg_date, working_data,
                                                                                                                          title_id, lab_id
                                                                                                                FROM      $mimas.mimas_user
                                                                                                                WHERE     email = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref',
                                                                                         
                                                                                         LongReadLen        => {
                                                                                                                 sql      => "SELECT    LENGTH(working_data)
                                                                                                                              FROM      $mimas.mimas_user
                                                                                                                              WHERE     email = ?",
                                                                                                                 
                                                                                                                 method   => 'selectrow_array'
                                                                                                               }
                                                                                       },
			                           
			                           select_by_email_ci              =>  {
                                                                                         sql                => "SELECT    user_id, username, password, disabled,
                                                                                                                          first_name, middle_name, last_name, position,
                                                                                                                          email, phone, fax, reg_date, working_data,
                                                                                                                          title_id, lab_id
                                                                                                                FROM      $mimas.mimas_user
                                                                                                                WHERE     LOWER(email) = LOWER(?)",
                                                                                         
                                                                                         method             => 'selectrow_hashref',
                                                                                         
                                                                                         LongReadLen        => {
                                                                                                                 sql      => "SELECT    LENGTH(working_data)
                                                                                                                              FROM      $mimas.mimas_user
                                                                                                                              WHERE     LOWER(email) = LOWER(?)",
                                                                                                                 
                                                                                                                 method   => 'selectrow_array'
                                                                                                               }
                                                                                       },
			                           
			                           select_by_username              =>  {
                                                                                         sql                => "SELECT    user_id, username, password, disabled,
                                                                                                                          first_name, middle_name, last_name, position,
                                                                                                                          email, phone, fax, reg_date, working_data,
                                                                                                                          title_id, lab_id
                                                                                                                FROM      $mimas.mimas_user
                                                                                                                WHERE     username = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref',
                                                                                         
                                                                                         LongReadLen        => {
                                                                                                                 sql      => "SELECT    LENGTH(working_data)
                                                                                                                              FROM      $mimas.mimas_user
                                                                                                                              WHERE     username = ?",
                                                                                                                 
                                                                                                                 method   => 'selectrow_array'
                                                                                                               }
                                                                                       },
			                           
			                           select_by_username_ci           =>  {
                                                                                         sql                => "SELECT    user_id, username, password, disabled,
                                                                                                                          first_name, middle_name, last_name, position,
                                                                                                                          email, phone, fax, reg_date, working_data,
                                                                                                                          title_id, lab_id
                                                                                                                FROM      $mimas.mimas_user
                                                                                                                WHERE     LOWER(username) = LOWER(?)",
                                                                                         
                                                                                         method             => 'selectrow_hashref',
                                                                                         
                                                                                         LongReadLen        => {
                                                                                                                 sql      => "SELECT    LENGTH(working_data)
                                                                                                                              FROM      $mimas.mimas_user
                                                                                                                              WHERE     LOWER(username) = LOWER(?)",
                                                                                                                 
                                                                                                                 method   => 'selectrow_array'
                                                                                                               }
                                                                                       },
			                           
			                           select_by_dbID                  =>  {
                                                                                         sql                => "SELECT    user_id, username, password, disabled,
                                                                                                                          first_name, middle_name, last_name, position,
                                                                                                                          email, phone, fax, reg_date, working_data,
                                                                                                                          title_id, lab_id
                                                                                                                FROM      $mimas.mimas_user
                                                                                                                WHERE     user_id = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref',
                                                                                         
                                                                                         LongReadLen        => {
                                                                                                                 sql      => "SELECT    LENGTH(working_data)
                                                                                                                              FROM      $mimas.mimas_user
                                                                                                                              WHERE     user_id = ?",
                                                                                                                 
                                                                                                                 method   => 'selectrow_array'
                                                                                                               }
                                                                                       }
                                                 }
                       },
    
    Web            =>  {
                         Job                 =>  {
                                                   select_all                      =>  {
                                                                                         sql                => "SELECT    job_id, type, request_time, data, user_id
                                                                                                                FROM      mimas_web.job
                                                                                                                ORDER BY  request_time",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} },
                                                                                         
                                                                                         LongReadLen        => {
                                                                                                                 sql      => "SELECT    MAX(LENGTH(data))
                                                                                                                              FROM      mimas_web.job",
                                                                                                                 
                                                                                                                 method   => 'selectrow_array'
                                                                                                               }
                                                                                       },
                                                   
                                                   select_all_by_userID            =>  {
                                                                                         sql                => "SELECT    job_id, type, request_time, data, user_id
                                                                                                                FROM      mimas_web.job
                                                                                                                WHERE     user_id = ?
                                                                                                                ORDER BY  request_time",
                                                                                         
                                                                                         method             => 'selectall_arrayref',
                                                                                         
                                                                                         attrs              => { Slice => {} },
                                                                                         
                                                                                         LongReadLen        => {
                                                                                                                 sql      => "SELECT    MAX(LENGTH(data))
                                                                                                                              FROM      mimas_web.job
                                                                                                                              WHERE     user_id = ?",
                                                                                                                 
                                                                                                                 method   => 'selectrow_array'
                                                                                                               }
                                                                                       },
                                                   
                                                   select_by_dbID                  =>  {
                                                                                         sql                => "SELECT    job_id, type, request_time, data, user_id
                                                                                                                FROM      mimas_web.job
                                                                                                                WHERE     job_id = ?",
                                                                                         
                                                                                         method             => 'selectrow_hashref',
                                                                                         
                                                                                         LongReadLen        => {
                                                                                                                 sql      => "SELECT    LENGTH(data)
                                                                                                                              FROM      mimas_web.job
                                                                                                                              WHERE     job_id = ?",
                                                                                                                 
                                                                                                                 method   => 'selectrow_array'
                                                                                                               }
                                                                                       }
                                                 },
                         
                         Incrementer         =>  {
                                                   get_new_dbID                    =>  {
                                                                                         sequence           => ["mimas_web.seq_web", undef],
                                                                                         
                                                                                         method             => 'selectrow_array'
                                                                                       }
                                                 },
                         
                         Session             =>  {
			                           get_LongReadLen                 =>  {
                                                                                         sql                 => "SELECT    MAX(LENGTH(a_session))
                                                                                                                 FROM      mimas_web.sessions",
                                                                                         
                                                                                         method              => 'selectrow_array'
                                                                                       }
                                                 },
                        
                         Alert               =>  {
			                           select_all                      =>  {
                                                                                         sql                 => "SELECT    alert_id, type, time, data, user_id
                                                                                                                 FROM      mimas_web.alert
                                                                                                                 ORDER BY  time DESC",
                                                                                         
                                                                                         method              => 'selectall_arrayref',
                                                                                         
                                                                                         attrs               => { Slice => {} },
                                                                                         
                                                                                         LongReadLen         => {
                                                                                                                  sql      => "SELECT    MAX(LENGTH(data))
                                                                                                                               FROM      mimas_web.alert",
                                                                                                                  
                                                                                                                  method   => 'selectrow_array'
                                                                                                                }
                                                                                       },
			                           
			                           select_all_by_userID            =>  {
                                                                                         sql                 => "SELECT    alert_id, type, time, data, user_id
                                                                                                                 FROM      mimas_web.alert
                                                                                                                 WHERE     user_id = ?
                                                                                                                 ORDER BY  time DESC",
                                                                                         
                                                                                         method              => 'selectall_arrayref',
                                                                                         
                                                                                         attrs               => { Slice => {} },
                                                                                         
                                                                                         LongReadLen         => {
                                                                                                                  sql      => "SELECT    MAX(LENGTH(data))
                                                                                                                               FROM      mimas_web.alert
                                                                                                                               WHERE     user_id = ?",
                                                                                                                  
                                                                                                                  method   => 'selectrow_array'
                                                                                                                }
                                                                                       },
			                          
			                           select_by_dbID                  =>  {
                                                                                         sql                 => "SELECT    alert_id, type, time, data, user_id
                                                                                                                 FROM      mimas_web.alert
                                                                                                                 WHERE     alert_id = ?",
                                                                                         
                                                                                         method              => 'selectrow_hashref',
                                                                                         
                                                                                         LongReadLen         => {
                                                                                                                  sql      => "SELECT    LENGTH(data)
                                                                                                                               FROM      mimas_web.alert
                                                                                                                               WHERE     alert_id = ?",
                                                                                                                  
                                                                                                                  method   => 'selectrow_array'
                                                                                                                }
                                                                                       }
                                                 }
                       }
};


our $Deletes = {
    
    Library        =>  {
                         
                         MgedTerm            =>  {
			                           remove_all                      =>  {
                                                                                         sql                 => "DELETE
                                                                                                                 FROM      $mimas.mged_term
                                                                                                                 "
                                                                                       }
                                                 },
                         
                         Technology          =>  {
			                           remove_by_dbID                  =>  {
                                                                                         sql                 => "DELETE
                                                                                                                 FROM      $mimas.technology
                                                                                                                 WHERE     technology_id = ?"
                                                                                       }
                                                 },
                         
                         Array               =>  {
			                           remove_by_dbID                  =>  {
                                                                                         sql                 => "DELETE
                                                                                                                 FROM      $mimas.array
                                                                                                                 WHERE     array_id = ?"
                                                                                       }
                                                 },
                         
                         AttrDetail          =>  {
			                           remove_by_dbID                  =>  {
                                                                                         sql                 => "DELETE
                                                                                                                 FROM      $mimas.attr_detail
                                                                                                                 WHERE     attr_detail_id = ?"
                                                                                       }
                                                 },
                       },

    Upload         =>  {
                         ExpAttribute        =>  {
			                           remove_all_by_expID             =>  {
                                                                                         sql                 => "DELETE
                                                                                                                 FROM      $mimas.up_exp_attribute
                                                                                                                 WHERE     experiment_id = ?"
                                                                                      }
                                                 },
                         
                         ExpCondition        =>  {
			                           remove_all_by_expID             =>  {
                                                                                         sql                 => "DELETE
                                                                                                                 FROM      $mimas.up_exp_condition
                                                                                                                 WHERE     experiment_id = ?"
                                                                                       },
						  
			                           remove_by_dbID                  =>  {
                                                                                         sql                 => "DELETE
                                                                                                                 FROM      $mimas.up_exp_condition
                                                                                                                 WHERE     condition_id = ?"
                                                                                       }
                                                 },
                         
                         Experiment          =>  {
			                           remove_by_dbID                  =>  {
                                                                                         sql                 => "DELETE
                                                                                                                 FROM      $mimas.up_experiment
                                                                                                                 WHERE     experiment_id = ?"
                                                                                       }
                                                 },
                         
                         ExpFactor           =>  {
			                           remove_all_by_expID             =>  {
                                                                                         sql                 => "DELETE
                                                                                                                 FROM      $mimas.up_exp_factor
                                                                                                                 WHERE     experiment_id = ?"
                                                                                       }
                                                 },
                         
                         Sample              =>  {
			                           remove_all_by_expID             =>  {
                                                                                         sql                 => "DELETE
                                                                                                                 FROM      $mimas.up_sample
                                                                                                                 WHERE     experiment_id = ?"
                                                                                       },
                                                   
			                           remove_by_dbID                  =>  {
                                                                                         sql                 => "DELETE
                                                                                                                 FROM      $mimas.up_sample
                                                                                                                 WHERE     sample_id = ?"
                                                                                       }
                                                 },
                         
                         SampleAttribute     =>  {
			                           remove_all_by_sampleID          =>  {
                                                                                         sql                 => "DELETE
                                                                                                                 FROM      $mimas.up_sample_attribute
                                                                                                                 WHERE     sample_id = ?"
                                                                                       },
						   
						   remove_all_by_sample_and_attrID =>  {
                                                                                         sql                 => "DELETE
                                                                                                                 FROM      $mimas.up_sample_attribute
                                                                                                                 WHERE     sample_id = ?
                                                                                                                           AND
                                                                                                                           attribute_id = ?"
                                                                                       }
                                                 },
                        
                          SampleFile         =>  {
			                           remove_by_dbID                  =>  {
                                                                                         sql                 => "DELETE
                                                                                                                 FROM      $mimas.up_sample_file
                                                                                                                 WHERE     sample_file_id = ?"
                                                                                       },

			                           remove_all_by_sampleID          =>  {
                                                                                         sql                 => "DELETE
                                                                                                                 FROM      $mimas.up_sample_file
                                                                                                                 WHERE     sample_file_id IN (
                                                                                                                 	SELECT sample_file_id
															FROM $mimas.up_sample_to_file
															WHERE sample_id = ?)"
                                                                                       }
                                                 },

                          SampleToFile       =>  {
			                           remove_all_by_sampleID          =>  {
                                                                                         sql                 => "DELETE
                                                                                                                 FROM      $mimas.up_sample_to_file
                                                                                                                 WHERE     sample_id = ?"
                                                                                       }
                                                 },

                          SampleFileData     =>  {
			                           remove_by_sample_file_ID        =>  {
                                                                                         sql                 => "DELETE
                                                                                                                 FROM      $mimas.up_sample_file_data
                                                                                                                 WHERE     sample_file_id = ?"
                                                                                       }
                                                 },

                          GroupExpPrivilege  =>  {
			                           remove_all_by_expID             =>  {
                                                                                         sql                 => "DELETE
                                                                                                                 FROM      $mimas.group_exp_privilege
                                                                                                                 WHERE     experiment_id = ?"
                                                                                       }
                                                 },
                       },
    
    User           =>  {
                         Lab                 =>  {
			                           remove_by_dbID                  =>  {
                                                                                         sql                 => "DELETE
                                                                                                                 FROM      $mimas.lab
                                                                                                                 WHERE     lab_id = ?"
                                                                                       }
                                                 },
                        
                         Organization        =>  {
			                           remove_by_dbID                  =>  {
                                                                                         sql                 => "DELETE
                                                                                                                 FROM      $mimas.organization
                                                                                                                 WHERE     organization_id = ?"
                                                                                       }
                                                 },
                        
                         User                =>  {
			                           remove_by_dbID                  =>  {
                                                                                         sql                 => "DELETE
                                                                                                                 FROM      $mimas.mimas_user
                                                                                                                 WHERE     user_id = ?"
                                                                                       }
                                                 },
                        
                         UserToGroup         =>  {
			                           remove_all_by_userID            =>  {
                                                                                         sql                 => "DELETE
                                                                                                                 FROM      $mimas.user_to_group
                                                                                                                 WHERE     user_id = ?"
                                                                                       }
                                                 },
                        
                         UserToFacility      =>  {
			                           remove_all_by_userID            =>  {
                                                                                         sql                 => "DELETE
                                                                                                                 FROM      $mimas.user_to_facility
                                                                                                                 WHERE     user_id = ?"
                                                                                       }
                                                 },
		       },
    
    Web            =>  {
                         Job                 =>  {
			                           remove_by_dbID                  =>  {
                                                                                         sql                => "DELETE
                                                                                                                FROM      mimas_web.job
                                                                                                                WHERE     job_id = ?"
                                                                                       }
                                                 },
                         
                         Alert               =>  {
			                           remove_by_dbID                  =>  {
                                                                                         sql                => "DELETE
                                                                                                                FROM      mimas_web.alert
                                                                                                                WHERE     alert_id = ?"
                                                                                       }
                                                 }
                       }
};


our $Inserts = {
    
    Library        =>  {
                         MgedTerm            =>  {
			                           sql                => "INSERT INTO $mimas.mged_term (mged_name, mged_type, mage_name_mged, mage_name, deprecated, description)
                                                                          VALUES                        (?, ?, ?, ?, ?, ?)"
                                                 },
                         
                         AttrDetail          =>  {
			                           sql                => "INSERT INTO $mimas.attr_detail (attr_detail_id, name, type, default_selection, base_conv_scalar, base_conv_factor, description, link_id, attr_detail_group_id, attribute_id, mage_name)
                                                                          VALUES                        (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
                                                 },
                         
                         Attribute           =>  {
			                           sql                => "INSERT INTO $mimas.attribute (attribute_id, name, is_attribute, is_factor, is_numeric, required, other, none_na, search_form_type, upload_form_type, description, attr_group_id, factor_group_id, mage_category, mged_name)
                                                                          VALUES                      (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
                                                 },

                         Technology          =>  {
			                           sql                => "INSERT INTO $mimas.technology (technology_id, name, display_name, default_manufacturer) VALUES (?, ?, ?, ?)"
                                                 },

                         Array               =>  {
			                           sql                => "INSERT INTO $mimas.array (array_id, design_name, display_name, num_probesets, num_cel_features, technology_id, arrayexpress_accession, manufacturer)
                                                                          VALUES                            (?, ?, ?, ?, ?, ?, ?, ?)",
                                                 },
                       },
    
    Upload         =>  {
                         ExpAttribute        =>  {
			                           sql                => "INSERT INTO $mimas.up_exp_attribute (exp_attribute_id, char_value, numeric_value, attr_detail_id, attribute_id, experiment_id)
                                                                          VALUES                             (?, ?, ?, ?, ?, ?)",
			                           
			                           bind_types         => [undef, { ora_type => ORA_CLOB, ora_field => 'char_value' }, undef, undef, undef, undef]
                                                 },
                         
                         ExpCondition        =>  {
			                           sql                => "INSERT INTO $mimas.up_exp_condition (condition_id, name, display_order, experiment_id, color)
                                                                          VALUES                             (?, ?, ?, ?, ?)"
                                                 },
                         
                         Experiment          =>  {
			                           sql                => "INSERT INTO $mimas.up_experiment (experiment_id, name, num_hybrids, progress, state, owner_id)
                                                                          VALUES                          (?, ?, ?, ?, ?, ?)"
                                                 },
                         
                         ExpFactor           =>  {
			                           sql                => "INSERT INTO $mimas.up_exp_factor (experiment_id, factor_id)
                                                                          VALUES                          (?, ?)"
                                                 },
                         
                         Sample              =>  {
			                           sql                => "INSERT INTO $mimas.up_sample (sample_id, name, array_id, condition_id, experiment_id)
                                                                          VALUES                      (?, ?, ?, ?, ?)"
                                                 },
                         
                         SampleAttribute     =>  {
			                           sql                => "INSERT INTO $mimas.up_sample_attribute (sample_attribute_id, char_value, numeric_value, attr_detail_id, attribute_id, sample_id)
                                                                          VALUES                                (?, ?, ?, ?, ?, ?)",
			                           
			                           bind_types         => [undef, { ora_type => ORA_CLOB, ora_field => 'char_value' }, undef, undef, undef, undef]
                                                 },
                         
                         SampleFile          =>  {
			                           sql                => "INSERT INTO $mimas.up_sample_file (sample_file_id, format, experiment_id, upload_date, hybridization_date, file_name, fingerprint)
                                                                          VALUES                           (?, ?, ?, DEFAULT, ?, ?, ?)",
			                           
                                                 },

                         SampleToFile        =>  {
			                           sql                => "INSERT INTO $mimas.up_sample_to_file (sample_to_file_id, sample_id, sample_file_id, format, is_germonline, hybridization_name)
                                                                          VALUES                           (?, ?, ?, ?, ?, ?)",
			                           
                                                 },

                         SampleFileData      =>  {
			                           sql                => "INSERT INTO $mimas.up_sample_file_data (sample_file_id, chunk_number, contents)
                                                                          VALUES                           (?, ?, ?)",
			                           
			                           bind_types         => [undef, undef, { ora_type => ORA_BLOB, ora_field => 'contents' }, undef, undef, undef, undef]
                                                 },

                         GroupExpPrivilege   =>  {
			                           sql                => "INSERT INTO $mimas.group_exp_privilege (group_id, experiment_id, can_write)
                                                                          VALUES                           (?, ?, ?)",
                                                 },
                       },
    
    User           =>  {
                         Lab                 =>  {
			                           sql                => "INSERT INTO $mimas.lab (lab_id, name, address, postcode, state, city, url, pi_name, pi_email, valid, organization_id)
                                                                          VALUES                (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
                                                 },
                         
                         Organization        =>  {
			                           sql                => "INSERT INTO $mimas.organization (organization_id, name, url, valid, country_id)
                                                                          VALUES                         (?, ?, ?, ?, ?)"
                                                 },
                         
                         User                =>  {
			                           sql                => "INSERT INTO $mimas.mimas_user (user_id, username, password, disabled, first_name, middle_name, last_name, position, email, phone, fax, title_id, lab_id)
                                                                          VALUES                       (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
                                                 },
                         
			 UserToGroup         =>  {
			                           sql                => "INSERT INTO $mimas.user_to_group (user_id, group_id)
                                                                          VALUES                          (?, ?)"
                                                 },
                         
			 UserToFacility      =>  {
			                           sql                => "INSERT INTO $mimas.user_to_facility (user_id, attr_detail_id)
                                                                          VALUES                          (?, ?)"
                                                 },
                       },
    
    Web            =>  {
                         Job                 =>  {
			                           sql                => "INSERT INTO mimas_web.job (job_id, type, data, user_id)
                                                                          VALUES                    (?, ?, ?, ?)",
                                                   
                                                   bind_types         => [undef, undef, { ora_type => ORA_CLOB, ora_field => 'data' }, undef]
                                                 },
                         
                         Alert               =>  {
			                           sql                => "INSERT INTO mimas_web.alert (alert_id, type, data, user_id)
                                                                          VALUES                      (?, ?, ?, ?)",
			                           
			                           bind_types         => [undef, undef, { ora_type => ORA_CLOB, ora_field => 'data' }, undef]
                                                 }
                       }
};


our $Updates = {
    
    Library        =>  {

                         Technology          =>  {
			                           set_fields   => [qw(technology_id name display_name default_manufacturer)],
			                           
			                           qual_fields  => [qw( technology_id )],
			                           
			                           table        => "$mimas.technology"
                                                 },

                         Array               =>  {
			                           set_fields   => [qw( design_name  display_name  num_probesets  num_cel_features  technology_id arrayexpress_accession  manufacturer  )],
			                           
			                           qual_fields  => [qw( array_id )],
			                           
			                           table        => "$mimas.array"
                                                 },
                         
                         AttrDetail          =>  {
			                           set_fields   => [qw( name              deprecated   default_selection  display_order  base_conv_scalar
						                        base_conv_factor  description  link_id            attr_detail_group_id
                                                                        mage_name
                                                                        )],
			                           
			                           qual_fields  => [qw( attr_detail_id )],
			                           
			                           table        => "$mimas.attr_detail"
                                                 },
                         
                         Attribute           =>  {
			                           set_fields   => [qw( name             is_attribute   is_factor    is_numeric        deprecated
						                        required         other          none_na      search_form_type  upload_form_type
						                        upload_web_page  display_order  description  attr_group_id     factor_group_id
                                                                        mage_category    mged_name
                                                )],
			                           
			                           qual_fields  => [qw( attribute_id )],
			                           
			                           table        => "$mimas.attribute"
                                                 }
                       },
    
    Upload         =>  {
                         ExpAttribute        =>  {
			                           set_fields   => [qw( char_value  numeric_value  attr_detail_id )],
			                           
			                           qual_fields  => [qw( exp_attribute_id  experiment_id  attribute_id )],
			                           
			                           table        => "$mimas.up_exp_attribute",
			                           
			                           bind_types   => { char_value => { ora_type => ORA_CLOB, ora_field => "char_value" } }
                                                 },
                         
			 ExpCondition        =>  {
			                           set_fields   => [qw( name  display_order  experiment_id  color )],
			                           
			                           qual_fields  => [qw( condition_id  experiment_id )],
			                           
			                           table        => "$mimas.up_exp_condition"
                                                 },
                         
                         Experiment          =>  {
			                           set_fields   => [qw( name  num_hybrids  progress  state  owner_id  curator_id )],
			                           
			                           qual_fields  => [qw( experiment_id  state  owner_id  curator_id )],
			                           
			                           table        => "$mimas.up_experiment"
                                                 },
                         
                         Sample              =>  {
			                           set_fields   => [qw( name  attrs_complete  attrs_exist  array_id  condition_id  experiment_id )],
			                           
			                           qual_fields  => [qw( sample_id  condition_id  experiment_id )],
			                           
			                           table        => "$mimas.up_sample"
                                                 },
                         
                         SampleAttribute     =>  {
			                           set_fields   => [qw( char_value  numeric_value  attr_detail_id )],
			                           
			                           qual_fields  => [qw( sample_attribute_id  sample_id  attribute_id )],
			                           
			                           table        => "$mimas.up_sample_attribute",
			                           
			                           bind_types   => { char_value => { ora_type => ORA_CLOB, ora_field => "char_value" } }
                                                 },
                         
			 SampleFile          =>  {
			                           set_fields   => [qw( upload_date  hybridization_date  fingerprint  file_name )],
			                           
			                           qual_fields  => [qw( sample_file_id  sample_id )],
			                           
			                           table        => "$mimas.up_sample_file",
                                                 },
                         
			 SampleToFile        =>  {
			                           set_fields   => [qw( format  is_germonline  sample_id )],
			                           
			                           qual_fields  => [qw( sample_to_file_id  sample_id  sample_file_id )],
			                           
			                           table        => "$mimas.up_sample_to_file",
                                                 },
                         
                       },
    
    User           =>  {
                         Lab                 =>  {
			                           set_fields   => [qw( name  address  postcode  state  city
                                                                        url   pi_name  pi_email  valid  organization_id )],
			                           
			                           qual_fields  => [qw( lab_id )],
				                   		 
			                           table        => "$mimas.lab"
                                                 },
                         
                         Organization        =>  {
			                           set_fields   => [qw( name  url  valid  country_id )],
			                           
			                           qual_fields  => [qw( organization_id )],
				                   		 
			                           table        => "$mimas.organization"
                                                 },
                         
                         User                =>  {
			                           set_fields   => [qw( username  password  disabled  first_name    middle_name  last_name  position
                                                                        email     phone     fax       working_data  title_id     lab_id              )],
			                           
			                           qual_fields  => [qw( user_id )],
			                           
			                           table        => "$mimas.mimas_user",
			                           
			                           bind_types   => { working_data => { ora_type => ORA_CLOB, ora_field => "working_data" } }
                                                 }
                       }
};


1;

