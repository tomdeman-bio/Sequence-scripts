#!/usr/bin/perl

#needs bowtie2, samtools, and bedtools in path
#runs bowtie2 in batch
#converts SAM to sorted BAM
#extracts mapped reads from BAM file and generates two FASTQ files per sample
#Written by Tom de Man

use warnings;
use strict;
use File::Basename;

my @files=@ARGV;

#bowtie2 index
my $DB = "/path/to/mapping-reference-file";
my $SamToFastq = "/path/to/picard-tools-1.96/SamToFastq.jar";
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
	print "mapping - converting - subtracting your mapped read data....\n";
	print "----------------------\n";
	print "$paired_files{$name}[0]"." <--> "."$paired_files{$name}[1]"."\n";
    
	my $re1 = $paired_files{$name}[0];
	my $re2 = $paired_files{$name}[1];
	my $fq1 = "$path$name"."_R1_001.fastq";
	my $fq2 = "$path$name"."_R2_001.fastq";

	system("bowtie2 -x $DB -1 $re1 -2 $re2 -p 12 --end-to-end -D 10 -R 2 -N 0 -L 30 -i S,0,2.50 | samtools view -bS - > $path$name.bam");
	system("samtools view -F 4 $path$name.bam -o $path$name.mappedReads.bam");
	system("samtools sort -n $path$name.mappedReads.bam -o $path$name.mappedReadsSorted.bam");
	system("java -Xmx4g -jar $SamToFastq I=$path$name.mappedReadsSorted.bam F=$fq1 F2=$fq2");
}
