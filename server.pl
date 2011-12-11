#!/usr/bin/perl -w

use strict;
use CGI qw/:standard/;
use JSON;

my $directions_file = 'directions.txt';

sub get_direction{
    open D_FILE, '<', $directions_file or return;
    my $direction;
    while(<D_FILE>){
	$direction = $_;
	last;
    }
    close D_FILE;
    return $direction;
}

MAIN:{
    

    my $direction;
    if (param('ask_direction')) {
        print header('application/json');
        my $read_direction = get_direction();
        my $dref = {'read_direction' => $read_direction};
        my $json_text = to_json($dref);
        print STDERR $json_text;
        print $json_text;
        exit;
    }else { 
	print header;
    }
    print start_html(-title => 'NXT Remote Control',
		     -script => [
		      {-type => 'text/javascript',
		       -src => 'js/functions.js',
		      },
		     ],
		    );
    
    if (param()){
	if (param('direction')){
	    $direction = param('direction');
	    open D_FILE, '>', $directions_file or die "Cannot open file $!";
	    print D_FILE $direction;
	    close D_FILE;
	    sleep 1;
	    open D_FILE, '>', $directions_file or die "Cannot open file $!";
	    print D_FILE "idle";
	    close D_FILE; 
	}
	if (param('ask_direction')){
	    my $read_direction = get_direction();
	    print hidden(-name=>'read_direction',
		 -value=>$read_direction,
		 -id=>'read_direction',
		); 
#	    exit;
	}
    }
    
    print h5($direction) if ($direction);
    print h4('select the direction');
    print start_form(-id => 'form1');
    $direction = get_direction();
    print radio_group(-name=>'direction',
		      -values=>['inainte', 
		    		'dreapta', 
		    		'stanga', 
		    		'inapoi', 
		    		'stop'
		    		],
		      -labels=>{'inainte'=>'FW', 
		    		'inapoi'=>'BW', 
		    		'dreapta'=>'R', 
		    		'stanga'=>'L', 
		    		'stop'=>'STOP'
		    		},
		      -linebreak=>'true',
		      -default=>$direction,
		      -onClick=>'submit_form()',
		     );
    print "<br>";
#    print hidden(-name=>'ask_direction',
#		 -value=>$direction,
#		 -id=>'ask_direction',
#		); 
    print submit;
    print end_form;
    print end_html;
    
    
}