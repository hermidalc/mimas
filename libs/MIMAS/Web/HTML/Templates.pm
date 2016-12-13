# Templates.pm
# MIMAS HTML Templates
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::Web::HTML::Templates;

use strict;
use warnings;
require Exporter;

our @ISA       = qw(Exporter);
our @EXPORT    = qw(TEMPLATE_01);
our $VERSION   = 1.00;


# Templates

use constant TEMPLATE_01 => <<'HTML';
<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td width="200" height="51"><img width="200" height="51" alt="MIMAS" src="/images/mimas_logo_03.png"></td>
    <td width="10"><img width="10" height="1" alt="" src="/images/spacer.gif"></td>
    <td width="100%"><img width="590" height="1" alt="" src="/images/spacer.gif"></td>
  </tr>
  <tr>
    <td width="100%" colspan="3"><img width="750" height="10" alt="" src="/images/spacer.gif"></td>
  </tr>
  <tr>
    <td valign="top" width="150">
      <table class="menus" cellpadding="0" cellspacing="0" border="0">
        <tr><td class="topbar"><img width="1" height="20" alt="" src="/images/spacer.gif"></td></tr>
        <tr><td><img width="1" height="50" alt="" src="/images/spacer.gif"></td></tr>
        <tr>
          <td>
            <!-- main menu -->
            <table class="mainmenu" cellpadding="0" cellspacing="0" border="0">
              ##MAIN_MENU##
            </table>
            <!-- end -->
          </td>
        </tr>
        <tr><td><img width="1" height="50" alt="" src="/images/spacer.gif"></td></tr>
        <tr>
          <td>
            <!-- detail menu -->
            <table class="detailmenu" cellpadding="0" cellspacing="0" border="0">
              ##DETAIL_MENU##
            </table>
            <!-- end -->
          </td>
        </tr>
        <tr><td><img width="1" height="50" alt="" src="/images/spacer.gif"></td></tr>
      </table>
    </td>
    <td valign="top" width="10"><img width="10" height="1" alt="" src="/images/spacer.gif"></td>
    <td valign="top" width="100%">
      <table class="main" cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td class="topbar" colspan="3" align="right">
            <!-- navigation bar -->
            <table cellpadding="0" cellspacing="0" border="0">
              <tr>
                <td><img width="1" height="20" alt="" src="/images/spacer.gif"></td>
                ##NAVBAR##
              </tr>
            </table>
            <!-- end -->
          </td>
        </tr>
        <tr><td colspan="3"><img width="1" height="20" alt="" src="/images/spacer.gif"></td></tr>
        <tr>
	  <td width="10"><img width="10" height="1" alt="" src="/images/spacer.gif"></td>
          <td>
            <table class="maindisplay" align="center" cellpadding="0" cellspacing="0" border="0">
              <!-- main display area -->
	      ##BODY##
              <!-- end -->
            </table>
          </td>
	  <td width="10"><img width="10" height="1" alt="" src="/images/spacer.gif"></td>
        </tr>
        <tr><td colspan="3"><img width="1" height="20" alt="" src="/images/spacer.gif"></td></tr>
      </table>
    </td>
  </tr>
</table>
HTML


1;

