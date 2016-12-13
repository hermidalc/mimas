# Root.pm
# Library Base (Root) Class
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package Root;

use strict;
use warnings;

our $VERSION = 1.00;

my $VERBOSITY = 0;


sub new {
    my $invocant = shift;
    
    my $class = ref($invocant) || $invocant;
    my $self  = { };
    bless $self, $class;
    
    return $self;
}


sub rearrange_params {
    my $self = shift;
    
    # Arguments
    my ($order, @params) = @_;
    
    # If no params return nothing
    return unless @params;
    
    # Check for appropriate list of name/value pairs
    $self->throw('Incomplete name/value pairs!') if scalar @params % 2 != 0;
    for (my $i = 0; $i < $#params; $i += 2) {
        return @params unless defined $params[$i] and substr($params[$i], 0, 1) eq '-';
    }
    
    # Cleanup
    for (my $i = 0; $i < $#params; $i += 2) {
        $params[$i] =~ s/^-//;
	$params[$i] =~ tr/a-z/A-Z/;
    }
    
    my %params = @params;
    undef @params;
    
    # Reorder
    my (@arranged_params, @missing);
    for my $key (@{$order}) {
	$key =~ tr/a-z/A-Z/;
        if (exists $params{$key}) {
	    push @arranged_params, $params{$key};
	    delete $params{$key};
	} else {
	    push @missing, $key;
	}
    }
    
    $self->throw('Missing required named parameter(s): ' . join(', ', @missing))          if @missing;
    $self->throw('Bad named parameter(s): '              . join(', ', sort keys %params)) if %params;
    
    return @arranged_params;
}


# only called internally
sub _stack_trace {
    my $self = shift;
    
    my $i = 0;
    my ($prev, @stacks);
    while (my @call = caller($i++)) {
        # Element w/ i=3 is the subroutine name of the call
        $prev->[3] = $call[3];
	push @stacks, $prev;
	$prev = \@call;
    }
    $prev->[3] = 'TopLevel';
    push @stacks, $prev;
    
    return @stacks;
}


# only called internally
sub _stack_trace_dump {
    my $self = shift;
    
    my @stacks = $self->_stack_trace();
    
    # remove unnecessary throw, stack_trace_dump, & stack_trace calls
    shift @stacks for 1 .. 3;
    
    my $dump_str;
    for my $stack (@stacks) {
        my ($package, $filename, $line, $subroutine) = @{$stack};
        $dump_str .= "STACK --> [$subroutine]  $filename: $line\n";
    }

    return $dump_str;
}


sub throw {
    my $self = shift;
    
    # Arguments
    my $err_message = shift;
    
    my $stack_dump = $self->_stack_trace_dump();
    
    my $error = "\n---------------------------------------- EXCEPTION ----------------------------------------\n" . 
                  "MSG: ${err_message}\n${stack_dump}" . 
		  "-------------------------------------------------------------------------------------------\n";
    
    # for some weird reason "die $error;" doesn't print the error message properly so I do it like this
    print STDERR $error;
    die 'MIMAS exception!';
}


sub verbosity {
    my $self = shift;
    
    # Verbosity levels
    # -1 = No warning
    #  0 = Standard warning
    #  1 = Warning with stack trace
    #  2 = Warning becomes throw
    
    $self->{verbosity} = shift if @_;
    return defined $self->{verbosity} ? $self->{verbosity} : $VERBOSITY;
}


sub warn {
    my $self = shift;
    
    # Arguments
    my $warn_message = shift;
    
    if ($self->verbosity == 2) {
        $self->throw($warn_message);
    } elsif ($self->verbosity == 1) {
        my $stack_dump = $self->_stack_trace_dump();
	$warn_message .= "\n${stack_dump}";
    } elsif ($self->verbosity == -1) {
        return;
    }
    
    my $warning = "\n------------------------------------------ WARNING -----------------------------------------\n" . 
                    "MSG: ${warn_message}\n" . 
		    "--------------------------------------------------------------------------------------------\n";
    
    print STDERR $warning;
}


1;

