

#!/usr/bin/perl

# use XML::Simple module
use XML::Simple;

####################################################################################
####################################################################################
# User must set the outpath and the inpath.
# The outpath should point to Data_Replication-->Parsed-->PubTypes
# The inpath should point to Data_Replication-->ReplicationSample-->ReplicationXML-->MEDLINE

# Set path names
$outpath="B:\\Research\\RAWDATA\\MEDLINE\\2014\\Parsed\\PubTypes";
$inpath="B:\\Research\\RAWDATA\\MEDLINE\\2014\\XML\\zip";
####################################################################################

# Declare which MEDLINE files to parse
$startfile=700; $endfile=700;
for ($fileindex=$startfile; $fileindex<=$endfile; $fileindex++) {

    open (OUTFILE, ">:utf8", "$outpath\\medline14\_$fileindex\_pubtypes.txt") or die "Can't open subjects file: medline14\_$fileindex\_pubtypes.txt";
    print OUTFILE "filenum	owner	status	versionid	versiondate	pmid	version	pubtype\n";

    print "Reading in file: medline14n0$fileindex.xml\n";
    &importfile;

    print "Parsing file: medline14n0$fileindex.xml\n";
    &pubtype;

    # this "dumps" the XML file out of memory
    $data=0;
}

sub importfile {

     if ($fileindex<10) { $data = XMLin("$inpath\\medline14n000$fileindex.xml", ForceArray => 1);}
     if($fileindex>=10 && $fileindex<=99) { $data = XMLin("$inpath\\medline14n00$fileindex.xml", ForceArray => 1); }
     if($fileindex>=100 && $fileindex<=746) { $data = XMLin("$inpath\\medline14n0$fileindex.xml", ForceArray => 1); }
}


sub pubtype {

    foreach $i (@{$data->{MedlineCitation}}) {
      
            $owner = "$i->{Owner}";
            $status = "$i->{Status}";
            $versionid = "$i->{VersionID}";
            $versiondate = "$i->{VersionDate}";

            if ($owner eq "") { $owner = "null"; }
            if ($status eq "") { $status = "null"; }
            if ($versionid eq "") { $versionid = "null"; }
            if ($versiondate eq "") { $versiondate = "null"; }

            @pmid = @{$i->{PMID}};
            @medlinejournalinfo = @{$i->{MedlineJournalInfo}};
            @article = @{$i->{Article}};

            foreach $j (@pmid) {
                    $pmid = "$j->{content}";
                    $version = "$j->{Version}";
            }

            foreach $j (@article) {
                    @publicationtypelist = @{$j->{PublicationTypeList}};
                    $publicationtypelistsize=@publicationtypelist;

                    if ($publicationtypelistsize==0) {
                       print OUTFILE "$fileindex	$owner	$status	$versionid	$versiondate	$pmid	$version	null\n";
                    }

                    else {
                         foreach $k (@publicationtypelist) {
                                 @publicationtype = @{$k->{PublicationType}};
                                 
                                 $publicationtypesize=@publicationtype;
                                 for ($l=0; $l<=$publicationtypesize-1; $l++) {
                                         print OUTFILE "$fileindex	$owner	$status	$versionid	$versiondate	$pmid	$version	$publicationtype[$l]\n";
                                 }
                         }
                 }
            }
    }
}
