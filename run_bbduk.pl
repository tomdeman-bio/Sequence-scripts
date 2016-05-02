#!/usr/bin/perl

#Needs bbmap in path
#Runs bbduk in batch
#Written by Tom de Man

use warnings;
use strict;
use File::Basename;

my @files=@ARGV;
#for now hard coded, will change later
my $DB = "/path/to/phiX174.fasta";
my $path;

my %paired_files;
foreach my $file (@files){
    my ($file_name,$dir)=fileparse($file);
    $path = $dir;
    if($file_name =~ /(.+)_R([1|2])_/){
		$paired_files{$1}[$2-1]=$file;
    	#attempt different naming scheme
    }elsif($file_name =~ /(.+)_([1|2])/){
		$paired_files{$1}[$2-1]=$file;
    }else{
		warn "Input file does not contain '_R1_' or '_R2_' in name: $file";
    }
}

foreach my $name (sort keys %paired_files){
    unless(defined($paired_files{$name}[0]) && defined($paired_files{$name}[1])){
		warn "Couldn't find matching paired end files for file starting with: $name";
		next;
    }
    print "remove phiX174 from your data....\n";
    print "----------------------\n";
    print "$paired_files{$name}[0]"." <--> "."$paired_files{$name}[1]"."\n";

    system("bbduk.sh -Xmx20g threads=12 in=$paired_files{$name}[0] in2=$paired_files{$name}[1] out=$path$name"."_R1_noPhiX out2=$path$name"."_R2_noPhiX ref=$DB k=31 hdist=1");
}
