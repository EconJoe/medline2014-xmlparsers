

#!/usr/bin/perl

# use XML::Simple module
use XML::Simple;

####################################################################################
####################################################################################
# User must set the outpath and the inpath.
# The outpath should point to Data_Replication-->Parsed-->MeSH
# The inpath should point to Data_Replication-->ReplicationSample-->ReplicationXML-->MEDLINE

# Set path names
$outpath="B:\\Research\\RAWDATA\\MEDLINE\\2014\\Parsed\\MeSH";
$inpath="B:\\Research\\RAWDATA\\MEDLINE\\2014\\XML\\zip";
####################################################################################

####################################################################################
# Create the output file, and print the variable names
open (OUTFILE_ALL, ">:utf8", "$outpath\\medline14_mesh.txt") or die "Can't open subjects file: medline14_mesh.txt";
print OUTFILE_ALL "filenum	pmid	version	";
print OUTFILE_ALL "mesh	majortopic	type	meshgroup\n";
####################################################################################

# Declare which MEDLINE files to parse
$startfile=1; $endfile=746;
for ($fileindex=$startfile; $fileindex<=$endfile; $fileindex++) {
  
    # Create the output file, and print the variable names
    open (OUTFILE, ">:utf8", "$outpath\\medline14\_$fileindex\_mesh.txt") or die "Can't open subjects file: medline14\_$fileindex\_mesh.txt";
    print OUTFILE "filenum	pmid	version	";
    print OUTFILE "mesh	majortopic	type	meshgroup\n";

    # Read in XML file
    print "Reading in file: medline14n0$fileindex.xml\n";
    &importfile;

    # Parse MEDLINE XML file
    print "Parsing file: medline14n0$fileindex.xml\n";
    &mesh;

    # "Dump" the XML file out of memory
    $data=0;
}

sub importfile {

    # Read in MELDINE XML files based on the number of leading zeros in the file name
    if ($fileindex<10) { $data = XMLin("$inpath\\medline14n000$fileindex.xml", ForceArray => 1);}
    if($fileindex>=10 && $fileindex<=99) { $data = XMLin("$inpath\\medline14n00$fileindex.xml", ForceArray => 1); }
    if($fileindex>=100 && $fileindex<=746) { $data = XMLin("$inpath\\medline14n0$fileindex.xml", ForceArray => 1); }
}

sub mesh {
    
    # <MedlineCitation> is the top level element in MedlineCitationSet and contains one entire record
    # Access <MedlineCitation> array
    foreach $i (@{$data->{MedlineCitation}}) {

            @pmid = @{$i->{PMID}};
            @medlinejournalinfo = @{$i->{MedlineJournalInfo}};
            @meshheadinglist = @{$i->{MeshHeadingList}};

            foreach $j (@pmid) {
                    $pmid = "$j->{content}";
                    $version = "$j->{Version}";
            }

            $meshheadinglistsize=@meshheadinglist;

            if ($meshheadinglistsize==0) {
               print OUTFILE "$fileindex	$pmid	$version	";
               print OUTFILE "null	null	null	\n";
               
               print OUTFILE_ALL "$fileindex	$pmid	$version	";
               print OUTFILE_ALL "null	null	null	\n";
            }

            foreach $j (@meshheadinglist) {
                    @meshheading = @{$j->{MeshHeading}};

                    $meshgroup=0;
                    foreach $k (@meshheading) {
                            @descriptorname=@{$k->{DescriptorName}};
                            @qualifiername=@{$k->{QualifierName}};

                            $meshgroup++;

                            foreach $l (@descriptorname) {
                                    $mesh="$l->{content}";
                                    $majortopic="$l->{MajorTopicYN}";
                                    $type="Descriptor";

                                    print OUTFILE "$fileindex	$pmid	$version	";
                                    print OUTFILE "$mesh	$majortopic	$type	$meshgroup\n";
                                    
                                    print OUTFILE_ALL "$fileindex	$pmid	$version	";
                                    print OUTFILE_ALL "$mesh	$majortopic	$type	$meshgroup\n";
                            }
                            
                            foreach $l (@qualifiername) {
                                    $mesh="$l->{content}";
                                    $majortopic="$l->{MajorTopicYN}";
                                    $type="Qualifier";
                                    
                                    print OUTFILE "$fileindex	$pmid	$version	";
                                    print OUTFILE "$mesh	$majortopic	$type	$meshgroup\n";
                                    
                                    print OUTFILE_ALL "$fileindex	$pmid	$version	";
                                    print OUTFILE_ALL "$mesh	$majortopic	$type	$meshgroup\n";
                            }
                    }
            }
    }
}
