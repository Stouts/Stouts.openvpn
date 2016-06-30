#! /usr/bin/perl -w
#
# check_openvpn_clients.pl - nagios plugin 
# 
#
# Copyright (C) 2004 Gerd Mueller / Netways GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#
# Source: http://stackoverflow.com/questions/15014763/readline-on-closed-filehandle

use POSIX;
use strict;
use lib "/usr/local/nagios/libexec"  ;

my %ERRORS = ('UNKNOWN'  => '-1',
	      'OK'       => '0',
	      'WARNING'  => '1',
	      'CRITICAL' => '2');


use Getopt::Long;
Getopt::Long::Configure('bundling');

my $opt_c=2;
my $opt_w=1;
my $opt_h;
my $opt_n;
my $opt_V;

my $statusfile="/var/log/openvpn-status.log";

my $status;

my $PROGNAME = "check_hopcount";


$status = GetOptions(
		"h"   => \$opt_h, "help"       => \$opt_h,
		"V"   => \$opt_V, "version"    => \$opt_V,
		"c=s" =>\$opt_c,
		"w=s" =>\$opt_w,
		"n"   =>\$opt_n,
		"S=s" => \$statusfile, "statusfile=s" => \$statusfile);		

if ($opt_V) {
	print "0.1\n";
	exit 0;
}

if(!$opt_c || !$opt_w || $opt_h || $status==0) {
	print_usage() ;
}

my $count_file=0;
my $count=0;

my $errorcode = $ERRORS{'OK'};
my $output;
my $names="";
my $user;
my $dummy;

if(-e $statusfile) {
	open(LOGFILE,"< ".$statusfile);
	
	while(<LOGFILE>) {
		chomp();
		if(m/^Common Name,Real Address,Bytes Received,Bytes Sent,Connected Since$/) {
			$count_file=1; 
		} elsif(m/^ROUTING TABLE$/) {
			last;
		} elsif ($count_file) {
			$count++;
			($user,$dummy)=split(/,/);
			$names.="," if($names ne "");
			$names.=$user;
		}
	}
	close(LOGFILE);

    $output=$count." OpenVPN Client Connection";
    $output.="s" if($count!=1);
    $output.="<br>User: ".$names if($opt_n && $names ne "");
    if($count>=$opt_c) {
    	$errorcode = $ERRORS{'CRITICAL'};
    } elsif($count>=$opt_w) {
    	$errorcode = $ERRORS{'WARNING'};
    } 
    $output.= " | 'OpenVPN Client Connections'=".$count.";".$opt_w.";".$opt_c."\n";
} else {
	$output =' Status is unknown because $statusfile was not found! \n ';
	$errorcode = $ERRORS{'UNKNOWN'};
}

print $output;
exit $errorcode;


sub print_usage {
					printf "\n";
					printf "check_openvpn_clients.pl -S <STATUSFILE> -w n -c n \n";
					printf "Copyright (C) 2004 Gerd Mueller / Netways GmbH\n";
					printf "\n\n";
					exit $ERRORS{"UNKNOWN"};
				}
				
