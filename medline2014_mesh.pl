

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

# Declare which MEDLINE files to parse
$startfile=700; $endfile=700;
for ($fileindex=$startfile; $fileindex<=$endfile; $fileindex++) {

    # Create the output file, and print the variable names
    open (OUTFILE, ">:utf8", "$outpath\\medline14\_$fileindex\_mesh.txt") or die "Can't open subjects file: medline14\_$fileindex\_mesh.txt";
    print OUTFILE "filenum	owner	status	versionid	versiondate	pmid	version	";
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

            # Access the four elements of <MedlineCitation>: <Owner>, <Status>, <VersionID>, and <VersionDate>
            $owner = "$i->{Owner}";
            $status = "$i->{Status}";
            $versionid = "$i->{VersionID}";
            $versiondate = "$i->{VersionDate}";

            # Assign the value "null" to any missing element
            if ($owner eq "") { $owner = "null"; }
            if ($status eq "") { $status = "null"; }
            if ($versionid eq "") { $versionid = "null"; }
            if ($versiondate eq "") { $versiondate = "null"; }

            @pmid = @{$i->{PMID}};
            @medlinejournalinfo = @{$i->{MedlineJournalInfo}};
            @meshheadinglist = @{$i->{MeshHeadingList}};

            foreach $j (@pmid) {
                    $pmid = "$j->{content}";
                    $version = "$j->{Version}";
            }

            $meshheadinglistsize=@meshheadinglist;

            if ($meshheadinglistsize==0) {
               print OUTFILE "$fileindex	$owner	$status	$versionid	$versiondate	$pmid	$version	";
               print OUTFILE "null	null	null	\n";
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

                                    print OUTFILE "$fileindex	$owner	$status	$versionid	$versiondate	$pmid	$version	";
                                    print OUTFILE "$mesh	$majortopic	$type	$meshgroup\n";
                            }
                            
                            foreach $l (@qualifiername) {
                                    $mesh="$l->{content}";
                                    $majortopic="$l->{MajorTopicYN}";
                                    $type="Qualifier";
                                    
                                    print OUTFILE "$fileindex	$owner	$status	$versionid	$versiondate	$pmid	$version	";
                                    print OUTFILE "$mesh	$majortopic	$type	$meshgroup\n";
                            }
                    }
            }
    }
}
