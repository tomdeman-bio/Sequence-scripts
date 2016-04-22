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
#refSeq-Viral is the bowtie2 index
my $DB = "/path/to/refSeq-viral";
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
    print "mapping - converting - subtracting your data....\n";
    print "----------------------\n";
    print "$paired_files{$name}[0]"." <--> "."$paired_files{$name}[1]"."\n";

    system("bowtie2 -x $DB -1 $paired_files{$name}[0] -2 $paired_files{$name}[1] -S $path$name.sam -p 16 --end-to-end");
    system("samtools view -bS $path$name.sam > $path$name.bam");
    system("bam2fastq --no-aligned -o $path$name"."_R\#_bacterial.fastq $path$name.bam"); 
}

system("ls $path*_R_1_bacterial.fastq | sed -e 'p;s/_R_1_/_R1_/' | xargs -n2 mv");
system("ls $path*_R_2_bacterial.fastq | sed -e 'p;s/_R_2_/_R2_/' | xargs -n2 mv");
