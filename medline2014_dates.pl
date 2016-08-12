#!/usr/bin/perl

# use XML::Simple module
use XML::Simple;

####################################################################################
####################################################################################
# User must set the outpath and the inpath.
# The outpath should point to Data_Replication-->Parsed-->Dates
# The inpath should point to Data_Replication-->ReplicationSample-->ReplicationXML-->MEDLINE

# Set path names
$outpath="B:\\Research\\HITS\\HITS1\\TextReplication\\TextReplication2\\Data_Replication\\Parsed\\Dates";
$inpath="B:\\Research\\HITS\\HITS1\\TextReplication\\TextReplication2\\Data_Replication\\ReplicationSample\\ReplicationXML\\MEDLINE";
####################################################################################


$startfile=1; $endfile=746;
for ($fileindex=$startfile; $fileindex<=$endfile; $fileindex++) {

    open (OUTFILE, ">:utf8", "$outpath\\medline14\_$fileindex\_dates.txt") or die "Can't open subjects file: medline14\_$fileindex\_dates.txt";
    print OUTFILE "filenum	owner	status	versionid	versiondate	pmid	version	";
    print OUTFILE "pubyear	articyear	pubmonth	articmonth	pubday	articday	medlinedate\n";

    print "Reading in file: medline14n0$fileindex.xml\n";
    &importfile;

    print "Parsing file: medline14n0$fileindex.xml\n";
    &date;

    # this "dumps" the XML file out of memory
    $data=0;
}

sub importfile {

     if ($fileindex<10) { $data = XMLin("$inpath\\medline14n000$fileindex.xml");}
     if($fileindex>=10 && $fileindex<=99) { $data = XMLin("$inpath\\medline14n00$fileindex.xml"); }
     if($fileindex>=100 && $fileindex<=746) { $data = XMLin("$inpath\\medline14n0$fileindex.xml"); }
}

sub date {

    # access <MedlineCitation> array
    foreach $e (@{$data->{MedlineCitation}}) {

            $owner = $e->{Owner};
            $status = $e->{Status};
            $versionid = $e->{VersionID};
            $versiondate = $e->{VersionDate};

            $pmid = $e->{PMID}->{content};
            $version = $e->{PMID}->{Version};

            $pubyear = $e->{Article}->{Journal}->{JournalIssue}->{PubDate}->{Year};
            $pubmonth = $e->{Article}->{Journal}->{JournalIssue}->{PubDate}->{Month};
            $pubday = $e->{Article}->{Journal}->{JournalIssue}->{PubDate}->{Day};

            $articyear = $e->{Article}->{ArticleDate}->{Year};
            $articmonth = $e->{Article}->{ArticleDate}->{Month};
            $articday = $e->{Article}->{ArticleDate}->{Day};
            
            $medlinedate = $e->{Article}->{Journal}->{JournalIssue}->{PubDate}->{MedlineDate};

            if ($owner eq "") { $owner="null"; }
            if ($status eq "") { $status="null"; }
            if ($versionid eq "") { $versionid="null"; }
            if ($versiondate eq "") { $versiondate="null"; }

            if ($pmid eq "") { $pmid="null"; }
            if ($version eq "") { $version="null"; }

            if ($pubyear eq "") { $pubyear="null"; }
            if ($pubmonth eq "") { $pubmonth="null"; }
            if ($pubday eq "") { $pubday="null"; }
            
            if ( $articyear eq "") { $articyear="null"; }
            if ( $articmonth eq "") { $articmonth="null"; }
            if ( $articday eq "") { $articday="null"; }

            if ($medlinedate eq "") { $medlinedate="null"; }

            print OUTFILE "$fileindex	$owner	$status	$versionid	$versiondate	$pmid	$version	";
            print OUTFILE "$pubyear	$articyear	$pubmonth	$articmonth	$pubday	$articday	$medlinedate\n";
    }
}
