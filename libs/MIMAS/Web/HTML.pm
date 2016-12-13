# HTML.pm
# MIMAS HTML Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::Web::HTML;

use strict;
use warnings;
use MIMAS::Consts;
use MIMAS::Web::HTML::Templates;
use base qw(MIMAS::Web::Base);

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    
    # Arguments
    my $web = shift;
    
    my $self = $class->SUPER::new($web);
    
    return $self;
}


sub web_page {
    my $self = shift;
    
    my $order = [qw( TEMPLATE
                     USER
                     MAIN_MENU
                     DETAIL_MENU
		     NAVBAR
		     BODY        )];
    
    # Arguments
    my ($template, $user, $main_menu, $detail_menu, $navbar, $body) = $self->rearrange_params($order, @_);
    
    my $session_id = defined $self->web->session ? $self->web->session->{_session_id} : '';
    
    #
    ## Navigation Bar
    #
    my $nav_js  = q/onMouseOver="this.className='navbarover'" onMouseOut="this.className='navbar'"/;
    my $back_js = q/onMouseOver="this.className='backover'"   onMouseOut="this.className='back'"/;
    
    my %nav_html_opts = (
        home      => qq!<td class="navbar"><a class="navbar" title="Go to MIMAS Home"            $nav_js href="main?page=home">home</a></td>!,
	user_home => qq!<td class="navbar"><a class="navbar" title="Go to User Home"             $nav_js href="user?page=home&session_id=${session_id}">home</a></td>!,
	search    => qq!<td class="navbar"><a class="navbar" title="Search the MIMAS Repository" $nav_js href="search?page=search_rep&session_id=${session_id}">search</a></td>!,
	register  => qq!<td class="navbar"><a class="navbar" title="Register as a MIMAS User"    $nav_js href="main?page=register">register</a></td>!,
	
	login     => qq!<td class="login"><a class="login" title="Log in to MIMAS"  href="main?page=login">login</a></td>!,
	logout    => qq!<td class="login"><a class="login" title="Log out of MIMAS" href="main?page=login&session_id=${session_id}&logout=1">logout</a></td>!,
	
	back      => qq!<td class="back" title="Go back to previous page" $back_js onClick="history.back()">back</td>!
    );
    
    my $nav_html = $navbar eq 'LOGIN'  ? join "\n", @nav_html_opts{qw( home       register  login )} :
                   $navbar eq 'LOGOUT' ? join "\n", @nav_html_opts{qw( user_home  logout          )} :
		   $navbar eq 'ERROR'  ? join "\n", @nav_html_opts{qw( back                       )} : '';
    
    
    #
    ## Main Menu
    #
    my $main_menus = {
        about        => {
	                  title       => 'About the MIMAS project',
			  script_name => 'main',
			  web_page    => 'about',
			  display     => 'About MIMAS',
			  detail_menu => 'ABOUT'
			},
	
	analysis     => {
			  title       => 'MIMAS Analysis Toolkit',
			  script_name => 'analysis',
			  display     => 'Analysis Toolkit',
			  detail_menu => 'ANALYSIS'
		        },
	
	uploads      => {
			  title       => 'Uploads to the MIMAS Repository',
			  script_name => 'upload',
			  display     => 'Experiment Uploads',
			  detail_menu => 'UPLOADS'
		        },
	
	repository   => {
			  title       => 'Search & Browse the MIMAS Repository',
			  script_name => 'search',
			  display     => 'Search Repository',
			  detail_menu => 'REPOSITORY'
		        },
	
        user_home    => {
			  title       => 'Go to User Home',
			  script_name => 'user',
			  display     => 'User Home',
			  detail_menu => 'USER'
		        },
	
        admin    => {
			  title       => 'Administration',
			  script_name => 'admin',
			  display     => 'Administration',
			  icon        => '<img src="images/icon_key.gif" width=16 height=16>&nbsp;',
			  detail_menu => 'ADMIN'
		        },
	
        
    };
    
    my @main_menu_list = $main_menu eq 'DEFAULT'  ? qw( user_home            uploads  repository ) : 
                         $main_menu eq 'EXTERNAL' ? qw( about                                    ) : ();

	push @main_menu_list, qw(admin) if defined $user and ($user->is_admin or $user->is_curator);
    
    my $main_menu_html = '';
    for my $menu (@main_menu_list) {
        my $selected = $self->web->cgi->url(-relative => 1) eq $main_menus->{$menu}->{script_name}
	                   ? defined $main_menus->{$menu}->{web_page}
		               ? (defined $self->web->cgi->url_param('page') and $self->web->cgi->url_param('page') eq $main_menus->{$menu}->{web_page})
	                           ? 1
		                   : 0
		               : 1
		           : $main_menus->{$menu}->{detail_menu} eq $detail_menu
		               ? 1
		               : 0;
	
	my $href = $main_menus->{$menu}->{script_name} . 
	               (defined $main_menus->{$menu}->{web_page}
		           ? $session_id
		               ? "?page=$main_menus->{$menu}->{web_page}&session_id=${session_id}"
			       : "?page=$main_menus->{$menu}->{web_page}"
		           : $session_id
		               ? "?session_id=${session_id}"
			       : "");
	
	my ($class, $js);
	if ($selected) {
	    $class = q/mainmenuover/;
            $js    = q//;
	} else {
	    $class = q/mainmenu/;
            $js    = qq/onMouseOver="this.className = 'mainmenuover'" onMouseOut="this.className = 'mainmenu'" onClick="location.href='$href'"/;
	}
	
	# Temporary shutoff of link to analysis toolkit pages
        $js = qq/onMouseOver="this.className = 'mainmenuover'" onMouseOut="this.className = 'mainmenu'"/ if $menu eq 'analysis';
        
        my $title_html   = $self->web->cgi->escapeHTML($main_menus->{$menu}->{title});
        my $icon_html    = $main_menus->{$menu}->{icon} || "";
        my $display_html = $self->web->cgi->escapeHTML($main_menus->{$menu}->{display});
        
        $main_menu_html .= <<"        HTML";
        <tr><td class="$class" title="$title_html" $js>$icon_html$display_html</td></tr>
        HTML
    }
    
    
    #
    ## Detail Menu
    #
    my $detail_menus = {
        # UPLOADS
	manage_uploads     => {
			        title       => 'Create & Manage Uploads',
				script_name => 'upload',
			        web_page    => 'manage_uploads',
			        display     => 'Manage Uploads'
		              },
        
	file_upload        => {
			        title       => 'Upload Sample Data Files',
			        script_name => 'upload',
				web_page    => 'file_upload',
			        display     => 'File Upload',
				progress    => 1
		              },
        
	sample_relations   => {
			        title       => 'Determine Experimental Conditions and Sample Relationships',
			        script_name => 'upload',
				web_page    => 'sample_relations',
			        display     => 'Sample Relationships',
				progress    => 2
		              },
        
	exp_info           => {
			        title       => 'Experiment Information',
			        script_name => 'upload',
				web_page    => 'exp_info',
			        display     => 'Experiment Information',
				progress    => 3
		              },
        
	exp_permissions    => {
			        title       => 'Experiment Permissions',
			        script_name => 'upload',
				web_page    => 'exp_permissions',
			        display     => 'Experiment Permissions',
				progress    => 4
		              },
        
	sample_attrs       => {
			        title       => 'Sample Attributes',
			        script_name => 'upload',
				web_page    => 'sample_attrs',
			        display     => 'Sample Attributes',
				progress    => 4
		              },
        
	upload_summary     => {
			        title       => 'Upload Summary',
			        script_name => 'upload',
				web_page    => 'upload_summary',
			        display     => 'Upload Summary',
				progress    => 5
		              },
        
	# REPOSITORY
	search_rep         => {
			        title       => 'Build a Search Against the MIMAS Repository',
			        script_name => 'search',
				web_page    => 'search_rep',
			        display     => 'Build Search'
		              },
        
	search_results     => {
			        title       => 'View MIMAS Repository Search Results',
			        script_name => 'search',
				web_page    => 'search_results',
			        display     => 'View Results'
		              },
        
	# USER
	alerts             => {
			        title       => 'MIMAS Alerts and Messages',
			        script_name => 'user',
				web_page    => 'home',
			        display     => 'Alerts & Messages'
		              },
        
	user_info          => {
			        title       => 'Update Personal Infomation',
			        script_name => 'user',
				web_page    => 'info',
			        display     => 'Personal Information'
		              },
        
	
	# ADMIN
	users             => {
			        title       => 'Manage Users',
			        script_name => 'admin',
				web_page    => 'users',
			        display     => 'Manage Users',
			        icon        => '<img src="images/icon_users.png" width=16 height=15>&nbsp;',
		              },
        
	arrays             => {
			        title       => 'Array Collection',
			        script_name => 'admin',
				web_page    => 'arrays',
			        display     => 'Array Collection',
			        icon        => '<img src="images/icon_array.gif" width=16 height=16>&nbsp;',
		              },
        
	curation           => {
			        title       => 'Experiment Curation',
			        script_name => 'admin',
				web_page    => 'curation',
			        display     => 'Experiment Curation',
			        icon        => '<img src="images/icon_stamp.gif" width=16 height=16>&nbsp;',
		              },
        
    };
    
    my @detail_menu_list = $detail_menu eq 'UPLOADS'    ? qw( manage_uploads  file_upload     sample_relations  exp_info  exp_permissions sample_attrs  upload_summary ) :
                           $detail_menu eq 'REPOSITORY' ? qw( search_rep      search_results                                                           ) : 
                           $detail_menu eq 'ADMIN'      ? qw(                                                                                          ) :
			   $detail_menu eq 'USER'       ? qw( alerts                                                                                   ) : ();
    if ($detail_menu eq 'ADMIN') {
        push @detail_menu_list, qw(users    ) if defined $user and $user->is_admin;
        push @detail_menu_list, qw(arrays   ) if defined $user and $user->is_admin || $user->is_curator;
        push @detail_menu_list, qw(curation ) if defined $user and $user->is_curator;
    }
    if ($detail_menu eq 'USER') {
        push @detail_menu_list, qw(user_info) if defined $user and $user->username ne 'guest';
    }
    
    my $detail_menu_html = '';
    for my $menu (@detail_menu_list) {
        my $selected = ( $self->web->cgi->url(-relative => 1) eq $detail_menus->{$menu}->{script_name} and
	                 $self->web->cgi->url_param('page')   eq $detail_menus->{$menu}->{web_page}        ) ? 1 : 0;
	
	my $href = "$detail_menus->{$menu}->{script_name}?page=$detail_menus->{$menu}->{web_page}&session_id=${session_id}";
	
	my ($class, $js);
	if ($selected) {
	    $class = q/detailmenuover/;
	    $js    = q//;
	} elsif (defined $detail_menus->{$menu}->{progress}        and 
	         defined $self->web->session->{upload}             and 
	         defined $self->web->session->{upload}->{progress} and 
		         $self->web->session->{upload}->{progress} < $detail_menus->{$menu}->{progress}) {
	    $class = q/detailmenudisabled/;
	    $js    = q//;
        } elsif ($menu eq 'search_results' and 
	        (!defined $self->web->session->{search} or 
		( defined $self->web->session->{search} and !defined $self->web->session->{search}->{result_sample_ids}))) {
	    $class = q/detailmenudisabled/;
	    $js    = q//;
	} else {
	    $class = q/detailmenu/;
	    $js    = qq/onMouseOver="this.className = 'detailmenuover'" onMouseOut="this.className = 'detailmenu'" onClick="location.href='$href'"/;
	}
	
	my $title_html   = $self->web->cgi->escapeHTML($detail_menus->{$menu}->{title});
	my $display_html = $self->web->cgi->escapeHTML($detail_menus->{$menu}->{display});
        my $icon_html    = $detail_menus->{$menu}->{icon} || "";
	
	$detail_menu_html .= <<"        HTML";
	<tr><td class="$class" title="$title_html" $js>$icon_html$display_html</td></tr>
        HTML
	
	# for UPLOADS: only show "manage_uploads", not other menus if we are on that page
	my $page = $self->web->cgi->url_param('page');
	last if defined $page and $page eq $detail_menus->{manage_uploads}->{web_page};
    }
    
    
    #
    ## Now construct web page using a template
    #
    my $web_page = $template eq 'TEMPLATE_01' ? TEMPLATE_01 :
                   $template eq 'TEMPLATE_02' ? ''          : '';
    
    for ($web_page) {
        s/##MAIN_MENU##/$main_menu_html/;
	s/##DETAIL_MENU##/$detail_menu_html/;
	s/##NAVBAR##/$nav_html/;
	s/##BODY##/$body/;
    }
    
    return $web_page;
}


1;

