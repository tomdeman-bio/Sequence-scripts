#!/usr/bin/perl

#needs bowtie2, samtools and bam2fastq in path
#runs bowtie2 in batch
#converts SAM to BAM
#extracts unmapped reads from BAM file and generates FASTQ files
#Written by Tom de Man

use warnings;
use strict;
use File::Basename;

my @files=@ARGV;
#for now hard coded, will change later
my $DB = "/scicomp/home/xku6/Kraken_DB/viral_refSeq/refSeq-viral";

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
    print "mapping - converting - subtracting your data....\n";
    print "----------------------\n";
    print "$paired_files{$name}[0]"." <--> "."$paired_files{$name}[1]"."\n";
    my @basename = split(/\./, $paired_files{$name}[0]);
    my $base = $basename[0]; 

    system("bowtie2 -x $DB -1 $paired_files{$name}[0] -2 $paired_files{$name}[1] -S $paired_files{$name}[0].sam -p 4 --end-to-end");
    system("samtools view -bS $paired_files{$name}[0].sam > $paired_files{$name}[0].bam");
    system("bam2fastq --no-aligned -o $base.bacterial\#.fastq $paired_files{$name}[0].bam");
}
