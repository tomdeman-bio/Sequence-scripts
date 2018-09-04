#!/usr/bin/perl

#runs KneadData in batch. Only for human DNA removal, no quality trimming 
#Written by Tom de Man

use warnings;
use strict;
use File::Basename;

my @files=@ARGV;
my $database = "/path/to/database/Homo_sapiens_Bowtie2_v0.1/";

my %paired_files;
foreach my $file (@files){
    my ($file_name,$dir)=fileparse($file);
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
    print "processing your data....\n";
    print "----------------------\n";
    print "$paired_files{$name}[0]"." <--> "."$paired_files{$name}[1]"."\n";

    my $cmd="kneaddata -i $paired_files{$name}[0] -i $paired_files{$name}[1] -o kneaddata_nohuman -db $database --bypass-trim --bowtie2-options \"--very-sensitive --dovetail\" --remove-intermediate-output";
    print $cmd,"\n";
    die if system($cmd);
}
