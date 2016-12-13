# Web.pm
# MIMAS Web Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::Web;

use strict;
use warnings;
use Apache ();
use CGI qw(-private_tempfiles -oldstyle_urls);
use MIMAS::Consts;
use File::Spec;
use IO::File;
use base qw(Root);
use Encode;

our $VERSION = 1.00;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    my $self  = { };
    bless $self, $class;
    
    $self->apache(Apache->request);
    $self->cgi(new CGI);
    
    # CGI.pm in a mod_perl environment does a reset of the global variables during each new CGI object construction
    # so the pragmas I apply above in the "use CGI" statement set the appropriate CGI globals only once when the apache
    # child (and thus persistent perl interpreter) execute the use() statement during the first load of MIMAS::Web.
    # Any subsequent calls to create new CGI objects don't apply the pragmas again -- so in order
    # to fix this I set the CGI.pm necessary globals manually every time I create a new CGI object
    $CGI::PRIVATE_TEMPFILES    = 1;
    $CGI::USE_PARAM_SEMICOLONS = 0;
    $CGI::DISABLE_UPLOADS      = 1;
    
    return $self;
}


sub apache {
    my $self = shift;
    $self->{apache} = shift if @_;
    return $self->{apache};
}


sub cgi {
    my $self = shift;
    $self->{cgi} = shift if @_;
    return $self->{cgi};
}

sub cgi_Vars {
    my $self = shift;
    my $cgi = $self->cgi or die;
    my @par_names  = $cgi->param;
    my $form_input = {};

    #After http://ahinea.com/en/tech/perl-unicode-struggle.html
    #We send HTML in UTF-8.  We expect the HTML form input to be UTF-8 as well.
    #To manipulate it, we need to tell perl about the encoding.
    #(this allows Unicode characters to be input as user-defined values,
    # e.g. greek letters in drug compound names)
    foreach my $name ( @par_names ) {
        my @val = $cgi->param( $name );

        foreach ( @val ) {
            $_ = Encode::decode_utf8( $_ );
        }
        $name = Encode::decode_utf8( $name );

        if ( scalar @val == 1 ) {
            $form_input->{$name} = $val[0];
        } else {
            $form_input->{$name} = join "\0", @val;
        }
    }
    return $form_input;
}


sub http_referer {
    my $self = shift;
    
    # Wrapper for cgi->referer (HTTP_REFERER environment variable) if we are routing a through a proxy server that is 
    # using the HTTP/1.0 protocol. Proxies using the older protocol do not contain all the necessary HTTP headers
    # so CGI.pm's url method ($cgi->url) does not give the correct hostname and does not match the referer hostname.
    
    my $referer = $self->cgi->referer;
    $referer =~ s!^http://.+?(/|$)!http://@{[$self->cgi->server_name]}/! if MIMAS_HTTP10_PROXY and $self->cgi->referer;
    
    return $referer;
}


sub session {
    my $self = shift;
    $self->{session} = shift if @_;
    return $self->{session};
}

sub mimas_path {
    my $self = shift;
    if ($self->apache) {
        my $script_filename = $self->apache->filename;

        my ($volume,$directories,$file) = File::Spec->splitpath( $script_filename );

        my @dirs = File::Spec->splitdir( $directories );
        pop @dirs;
        pop @dirs;
        my $path = File::Spec->catdir( @dirs );

        my $mimas_dir = File::Spec->catpath( $volume, $path );

        return $mimas_dir;
    }
}

sub mimas_ssi {
    my $self = shift;
    my $filename = shift;
    my $mimas_path = $self->mimas_path;
    my $filepath = "$mimas_path/htdocs/ssi/$filename";
    my $news_html;
    use IO::File;
    if (my $fh = new IO::File $filepath) {
        local $/ = undef;
        return <$fh>;
    }
    else {
        return "Cannot open $filepath";
    }

}

sub error {
    my $self = shift;
    
    # Arguments
    my (@errors) = @_;
    
    my $errors_html;
    for my $i (0 .. $#errors) {
        my $td_class   = ($i != $#errors) ? 'cell02' : 'cell04';
	my $error_html = $self->cgi->escapeHTML($errors[$i]) || '??undefined??';
        $errors_html  .= "<tr><td class='$td_class'>$error_html</td></tr>";
    }
    
    $errors_html =~ s/\n/<br>/g;
    
    my $body = <<"    HTML";
    <tr><td class="header01">MIMAS Error</td></tr>
    <tr><td><img width="1" height="20" alt="" src="/images/spacer.gif"></td></tr>
    <tr>
      <td>
        <table class="submain01" cellpadding="0" cellspacing="0" border="0">
	  <tr><td class="tableheader01">The following error(s) were generated</td></tr>
	  $errors_html
	  <tr><td class="submit"><input class="button01w100" type="button" onClick="history.back()"value="GO BACK"></td></tr>
	</table>
      </td>
    </tr>
    HTML
    
    print $self->cgi->header(-type          => 'text/html',
                             -charset       => 'utf-8',
			     -encoding      => 'utf-8',
                             -cache_control => 'no-store'),
          
          $self->cgi->start_html(-title     => 'MIMAS -- Error',
	                         -encoding  => 'utf-8',
                                 -style     => {-src => '/styles/mimas_01.css'},
		                 -script    => {-src => '/js/mimas.js'}),
          
          $self->html->web_page(-template    => 'TEMPLATE_01',
                                -main_menu   => 'NONE',
			        -detail_menu => 'NONE',
			        -navbar      => 'ERROR',
			        -body        => $body,
					-user        => undef,
					),
          
          $self->cgi->end_html;
    
    exit;
}


# only used internally
sub _get_object {
    my $self = shift;
    
    # Arguments
    my ($module, @args) = @_;
    
    eval "require $module";
    $self->throw("Web module [$module] load error: $@") if $@;
    
    my $web_object = $module->new($self, @args);
    
    return $web_object;
}


sub html {
    my $self = shift;
    $self->{objects}->{html} = $self->_get_object('MIMAS::Web::HTML') unless defined $self->{objects}->{html};
    return $self->{objects}->{html};
}


1;

