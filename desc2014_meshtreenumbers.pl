

#!/usr/bin/perl

# use XML::Simple module
use XML::Simple;

####################################################################################
####################################################################################
# User must set the outpath and the inpath.
# The outpath should point to Data_Replication-->Parsed-->Dates
# The inpath should point to Data_Replication-->ReplicationSample-->ReplicationXML-->MEDLINE

# Set path names
$outpath="B:\\Research\\RAWDATA\\MeSH\\2014\\Parsed";
$inpath="B:\\Research\\RAWDATA\\MeSH\\2014";
####################################################################################


open (OUTFILE, ">:utf8", "$outpath\\desc2014_meshtreenumberss2.txt") or die "Can't open subjects file: desc2014_meshtreenumbers";
print OUTFILE "meshid	mesh	treenumber\n";

print "Reading in file: desc2014.xml\n";
$data = XMLin("$inpath\\desc2014.xml", ForceArray => 1);

print "Reading in file: desc2014.xml\n";
&meshtree;

#TreeNumberList

sub meshtree {

    foreach $i (@{$data->{DescriptorRecord}}) {

            @descriptorui = @{$i->{DescriptorUI}};
            @descriptorname = @{$i->{DescriptorName}};
            @treenumberlist = @{$i->{TreeNumberList}};
            
            $descriptoruisize=@descriptorui;
            $descriptornamesize=@descriptorname;
            $treenumberlistsize=@treenumberlist;
            
            foreach $j (@descriptorname) { @string = @{$j->{String}}; $stringsize=@string; }

            if ($descriptoruisize!=1 | $descriptornamesize!=1 | $stringsize!=1) { die "ERROR!\n"; }
            
            if ($treenumberlistsize==0) { print OUTFILE "$descriptorui[0]	$string[0]	DNE\n"; }
            
            if ($treenumberlistsize>0) {
               foreach $j (@treenumberlist) {
                       @treenumber = @{$j->{TreeNumber}};

                       $treenumbersize=@treenumber;
                       for ($k=0; $k<=$treenumbersize-1; $k++) {
                           print OUTFILE "$descriptorui[0]	$string[0]	$treenumber[$k]\n";
                       }
               }
            }
   }
}


