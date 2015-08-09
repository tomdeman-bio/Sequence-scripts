#!/usr/bin/perl

#Runs fastq-mcf in batch
#Make sure to put fastqMcf in your PATH variable
#Written by Tom de Man

use warnings;
use strict;
use File::Basename;

#hard coded
my $adaptors = "/path/to/univec_DB/UniVec.fasta"; 
my @files=@ARGV;

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
    print "trimming your data....\n";
    print "----------------------\n";
    print "$paired_files{$name}[0]"." <--> "."$paired_files{$name}[1]"."\n";

    my $cmd="fastq-mcf $adaptors $paired_files{$name}[0] $paired_files{$name}[1] -o $paired_files{$name}[0].trimmed.fq -o $paired_files{$name}[1].trimmed.fq -C 1000000 -q 20 -p 10 -u -x 0.01";
    print $cmd,"\n";
    die if system($cmd);
}
