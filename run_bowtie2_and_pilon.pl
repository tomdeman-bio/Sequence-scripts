#!/usr/bin/perl

#needs bowtie2, samtools and pilon in path
#runs bowtie2 in batch
#converts SAM to sorted BAM
#indexing the sorted BAM
#running pilon 
#Written by Tom de Man

use warnings;
use strict;
use File::Basename;

my $DB = shift;
my @files=@ARGV;
my $path;
my $DB_index;

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
    print "mapping to $DB - converting - running pilon\n";
    print "----------------------\n";
    print "$paired_files{$name}[0]"." <--> "."$paired_files{$name}[1]"."\n";
	
    system("bowtie2-build $DB $DB.index");
    system("bowtie2 -x $DB.index -1 $paired_files{$name}[0] -2 $paired_files{$name}[1] -S $path$name.sam --end-to-end -p 12");
    system("samtools view -bS $path$name.sam | samtools sort - $path$name.sort");
    system("samtools index $path$name.sort.bam $path$name.sort.bai");
    system("pilon --genome $DB --frags $path$name.sort.bam --mindepth 0.6 --minqual 30 --minmq 30 --fix all --changes --vcf --output $path$name.$DB.pilon");
}
