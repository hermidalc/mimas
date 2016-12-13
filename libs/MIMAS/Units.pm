# Units.pm
# MIMAS Units
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$

package MIMAS::Units;

use strict;
use warnings;
require Exporter;

our @ISA      = qw(Exporter);
our @EXPORT   = qw(MIMAS_UNITS);
our $VERSION  = 1.00;


use constant MIMAS_UNITS => {
    
    1   => {
             ID        => 1,
	     name      => 'Concentration (Mass/Vol)',
	     units     => {
	                    1   => {
			             ID               => 1,
				     name             => 'g/L',
			             base_conv_scalar => 0,
			             base_conv_factor => 1
			           },
                            
                            2   => {
			             ID               => 2,
				     name             => 'mg/mL',
			             base_conv_scalar => 0,
			             base_conv_factor => 1,
				     default          => 1
			           },
                        
                            3   => {
			             ID               => 3,
				     name             => 'ug/ul',
			             base_conv_scalar => 0,
			             base_conv_factor => 1
			           },
                            
                            
		          }
	   },
    
    2   => {
             ID        => 2,
	     name      => 'Concentration (Molarity)',
	     units     => {
	                    1   => {
			             ID               => 1,
				     name             => 'M',
			             base_conv_scalar => 0,
			             base_conv_factor => 1,
			             default          => 1
			           },
                            
                            2   => {
			             ID               => 2,
				     name             => 'fM',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E-15
			           },
                            
                            3   => {
			             ID               => 3,
				     name             => 'mM',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E-03
			           },
                            
                            4   => {
			             ID               => 4,
				     name             => 'nM',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E-09
			           },
                            
                            5   => {
			             ID               => 5,
				     name             => 'pM',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E-12
			           },
                            
                            6   => {
			             ID               => 6,
				     name             => 'uM',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E-06
			           },
                            
                            
		          }
	   },
    
    3   => {
             ID        => 3,
	     name      => 'Distance',
	     units     => {
                            1   => {
			             ID               => 1,
				     name             => 'A',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E-10
			           },
                            
                            2   => {
			             ID               => 2,
				     name             => 'cm',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E-02,
				     default          => 1
			           },
                            
                            3   => {
			             ID               => 3,
				     name             => 'm',
			             base_conv_scalar => 0,
			             base_conv_factor => 1
			           },
                            
                            4   => {
			             ID               => 4,
				     name             => 'mm',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E-03
			           },
                            
                            5   => {
			             ID               => 5,
				     name             => 'nm',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E-09
			           },
                            
                            6   => {
			             ID               => 6,
				     name             => 'um',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E-06
			           },
                            
                            
		          }
	   },
    
    4   => {
             ID        => 4,
	     name      => 'Light (Luminous Flux)',
	     units     => {
                            1   => {
			             ID               => 1,
				     name             => 'lumen',
			             base_conv_scalar => 0,
			             base_conv_factor => 1,
				     default          => 1
			           },
                            
                            
		          }
	   },
    
    5   => {
             ID        => 5,
	     name      => 'Light (Luminous Intensity)',
	     units     => {
                            1   => {
			             ID               => 1,
				     name             => 'candela',
			             base_conv_scalar => 0,
			             base_conv_factor => 1,
				     default          => 1
			           },
                            
                            
		          }
	   },
    
    6   => {
             ID        => 6,
	     name      => 'Light (Illuminance)',
	     units     => {
                            1   => {
			             ID               => 1,
				     name             => 'lux (lumen/m2)',
			             base_conv_scalar => 0,
			             base_conv_factor => 1,
				     default          => 1
			           },
                            
                            
		          }
	   },
    
    7   => {
             ID        => 7,
	     name      => 'Light (Luminance)',
	     units     => {
                            1   => {
			             ID               => 1,
				     name             => 'candela/m2',
			             base_conv_scalar => 0,
			             base_conv_factor => 1,
				     default          => 1
			           },
                            
                            
		          }
	   },
    
    8   => {
             ID        => 8,
	     name      => 'Mass',
	     units     => {
                            1   => {
			             ID               => 1,
				     name             => 'fg',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E-15
			           },
                            
                            2   => {
			             ID               => 2,
				     name             => 'g',
			             base_conv_scalar => 0,
			             base_conv_factor => 1
			           },
                            
                            3   => {
			             ID               => 3,
				     name             => 'kg',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E03
			           },
                            
                            4   => {
			             ID               => 4,
				     name             => 'mg',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E-03,
				     default          => 1
			           },
                            
                            5   => {
			             ID               => 5,
				     name             => 'ng',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E-09
			           },
                            
                            6   => {
			             ID               => 6,
				     name             => 'pg',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E-12
			           },
                            
                            7   => {
			             ID               => 7,
				     name             => 'ug',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E-06
			           },
                            
                            
		          }
	   },
    
    9   => {
             ID        => 9,
	     name      => 'Quantity',
	     units     => {
                            1   => {
			             ID               => 1,
				     name             => 'amol',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E-18
			           },
                            
                            2   => {
			             ID               => 2,
				     name             => 'fmol',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E-15
			           },
                            
                            3   => {
			             ID               => 3,
				     name             => 'mol',
			             base_conv_scalar => 0,
			             base_conv_factor => 1,
				     default          => 1
			           },
                            
                            4   => {
			             ID               => 4,
				     name             => 'molecules',
			             base_conv_scalar => 0,
			             base_conv_factor => 6.022E-23
			           },
                            
                            5   => {
			             ID               => 5,
				     name             => 'nmol',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E-09
			           },
                            
                            6   => {
			             ID               => 6,
				     name             => 'pmol',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E-12
			           },
                            
                            7   => {
			             ID               => 7,
				     name             => 'umol',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E-06
			           },
                            
                            
		          }
	   },
    
    10  => {
             ID        => 10,
	     name      => 'Radiation (Exposure)',
	     units     => {
                            1   => {
			             ID               => 1,
				     name             => 'C/kg',
			             base_conv_scalar => 0,
			             base_conv_factor => 1,
				     default          => 1
			           },
                            
                            2   => {
			             ID               => 2,
				     name             => 'R',
			             base_conv_scalar => 0,
			             base_conv_factor => 2.58E-04
			           },
                            
                            
		          }
	   },
    
    11  => {
             ID        => 11,
	     name      => 'Radiation (Absorbed Dose)',
	     units     => {
                            1   => {
			             ID               => 1,
				     name             => 'Rad',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E-02,
			           },
                            
                            2   => {
			             ID               => 2,
				     name             => 'Gy',
			             base_conv_scalar => 0,
			             base_conv_factor => 1,
		                     default          => 1
			           },
                            
                            
		          }
	   },
    
    12  => {
             ID        => 12,
	     name      => 'Radiation (Equivalent Dose)',
	     units     => {
                            1   => {
			             ID               => 1,
				     name             => 'Rem',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E-02
			           },
                            
                            2   => {
			             ID               => 2,
				     name             => 'Sv',
			             base_conv_scalar => 0,
			             base_conv_factor => 1,
				     default          => 1
			           },
                            
                            
		          }
	   },
    
    13  => {
             ID        => 13,
	     name      => 'Radiation (Activity)',
	     units     => {
                            1   => {
			             ID               => 1,
				     name             => 'Ci',
			             base_conv_scalar => 0,
			             base_conv_factor => 3.7E10
			           },
                            
                            2   => {
			             ID               => 2,
				     name             => 'Bq',
			             base_conv_scalar => 0,
			             base_conv_factor => 1,
				     default          => 1
			           },
                            
                            
		          }
	   },
    
    14  => {
             ID        => 14,
	     name      => 'Temperature',
	     units     => {
                            1   => {
			             ID               => 1,
				     name             => 'deg C',
			             base_conv_scalar => 0,
			             base_conv_factor => 1,
				     default          => 1
			           },
                            
                            2   => {
			             ID               => 2,
				     name             => 'deg F',
			             base_conv_scalar => -32,
			             base_conv_factor => 0.555555555555555
			           },
                            
                            3   => {
			             ID               => 3,
				     name             => 'K',
			             base_conv_scalar => -273.15,
			             base_conv_factor => 1
			           },
                            
                            
		          }
	   },
    
    15  => {
             ID        => 15,
	     name      => 'Time',
	     units     => {
                            1   => {
			             ID               => 1,
				     name             => 'weeks',
			             base_conv_scalar => 0,
			             base_conv_factor => 604800
			           },
                            
                            2   => {
			             ID               => 2,
				     name             => 'days',
			             base_conv_scalar => 0,
			             base_conv_factor => 86400
			           },
                            
                            3   => {
			             ID               => 3,
				     name             => 'hours',
			             base_conv_scalar => 0,
			             base_conv_factor => 3600
			           },
                            
                            4   => {
			             ID               => 4,
				     name             => 'minutes',
			             base_conv_scalar => 0,
			             base_conv_factor => 60
			           },
                            
                            5   => {
			             ID               => 5,
				     name             => 'months',
			             base_conv_scalar => 0,
			             base_conv_factor => 2629743.83333333333
			           },
                            
                            6   => {
			             ID               => 6,
				     name             => 'ms',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E-03
			           },
                            
                            7   => {
			             ID               => 7,
				     name             => 'seconds',
			             base_conv_scalar => 0,
			             base_conv_factor => 1
			           },
                            
                            8   => {
			             ID               => 8,
				     name             => 'us',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E-06
			           },
                            
                            9   => {
			             ID               => 9,
				     name             => 'years',
			             base_conv_scalar => 0,
			             base_conv_factor => 31556926
			           },
                            
                            
		          }
	   },
    
    16  => {
             ID        => 16,
	     name      => 'Volume',
	     units     => {
                            1   => {
			             ID               => 1,
				     name             => 'cc',
			             base_conv_scalar => 0,
			             base_conv_factor => 1
			           },
                            
                            2   => {
			             ID               => 2,
				     name             => 'dl',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E02
			           },
                            
                            3   => {
			             ID               => 3,
				     name             => 'fl',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E-12
			           },
                            
                            4   => {
			             ID               => 4,
				     name             => 'L',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E03
			           },
                            
                            5   => {
			             ID               => 5,
				     name             => 'ml',
			             base_conv_scalar => 0,
			             base_conv_factor => 1,
				     default          => 1
			           },
                            
                            6   => {
			             ID               => 6,
				     name             => 'nl',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E-06
			           },
                            
                            7   => {
			             ID               => 7,
				     name             => 'pl',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E-09
			           },
                            
                            8   => {
			             ID               => 8,
				     name             => 'ul',
			             base_conv_scalar => 0,
			             base_conv_factor => 1E-03
			           },
                            
                            
		          }
	   },
    
    
};


1;

