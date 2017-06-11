#! /usr/bin/perl

# Written by Tom de Man
#script needs sorted bam files 
#script also needs samtools, bedtools, and awk in order to operate

use strict;
use warnings;
use Getopt::Long;
use String::ShellQuote qw(shell_quote);
use Array::Utils qw(:all);
use Data::Dumper qw(Dumper);

my $sortbam_path;
my $genome;
my $depth;

my $genome_size;
my $starttime = localtime;
my $version = "1.0";

GetOptions(	"bam=s"		=> \$sortbam_path,
		"genome=s"	=> \$genome,
		"depth=s"	=> \$depth,
		"help|?"	=> sub {Usage()}
		);

if (($sortbam_path) && ($genome) && ($depth)) {
	my @bams = &get_files("bam");
	print STDERR "Hi $ENV{USER}, you are now running $0 version: $version on $starttime \n\n";
	print STDERR "BAM files included in core genome estimate: \n";
	foreach (@bams) {
		print "$_\n";
	}
	$genome_size = &genome_size_calc;
	&estimate_core(@bams);
} else {
	&Usage;
}

sub genome_size_calc {
	print STDERR "\n";
	print STDERR "your mapping reference is $genome \n";
	open FASTA, "$genome" or die "cannot open $genome for reading \n";
	my $total_bases = 0;
	while (<FASTA>) {
		if (!(/^>/)) {
			chomp;
			s/\r//g;
			$total_bases += length;
		}
	}
	return $total_bases;
close FASTA;
}

sub estimate_core {
	#create fasta index
	print STDERR "running samtools..... generating a contig list file\n";
	system("samtools faidx $genome");
	open INDEX, "$genome.fai" or die "cannot open $genome.fai for reading \n";
	open (my $fh, '>', "$genome.contig");
	while (<INDEX>) {
		chomp;
		my @split = split ("\t", $_);
		print $fh "$split[0]\t$split[1]\n";
	}
	close $fh;
	close INDEX;

	my $cnt = 0;
	#calculate genome wide coverage for each nucleotide position, for each sorted BAM file
	foreach my $file (@_) {
		$cnt += 1;
		my $bam = "$sortbam_path/$file";
		my $con_len = "$genome.contig";
		my $out = "$sortbam_path/$file.$depth.cov";
		print STDERR "running bedtools for sample $cnt..... generating genome coverage data \n";
		system("bedtools genomecov -ibam ".shell_quote($bam)." -g ".shell_quote($con_len)." -d | awk '{if(\$3>=$depth){ print \$0}}' > ".shell_quote($out)."");
	}
	
	#get the .cov files	
	my @covs = &get_files("cov");
	my @cov2d;
	foreach (@covs) {
		my @n;
		my $c = "$sortbam_path/$_";
		open COV, $c or die "cannot open $c for reading \n";
		while (<COV>) {
			chomp;
			my @split = split ("\t", $_);
			my $contig_position = $split[0]."_".$split[1];
			push @n, $contig_position;
		}
		close COV;
		push @cov2d, \@n;
 
	}
	my $rows = scalar @cov2d;
	print STDERR "You are going to estimate a core genome for $rows isolates ..... how exciting!!! \n";	

	my $start_ref = shift @cov2d;
	my @overlap = @$start_ref;
	my $remainder = $rows - 1;
	#pairwise comparison via intersect
	for (my $i=0; $i < $remainder; $i++) {
		my $comparison = shift @cov2d;
		my $size = @$comparison;
		@overlap = intersect(@$comparison, @overlap);
	}
	my $core = scalar @overlap;
	my $percentage = ($core/$genome_size)* 100;
	my $rounded = sprintf "%.2f", $percentage;
	print STDERR "Core genome size for $rows genomes is: $core base pairs, which equals $rounded% of the mapping reference genome\n";

}

sub get_files {
	my $ext = qr/$_[0]/;
	my @bamfiles;
	opendir(DIR, $sortbam_path) or die "cannot open $sortbam_path \n";
	my @files = readdir(DIR);
	close DIR;

	foreach my $file (@files){
		next if (!($file =~ /\.$ext$/));
		push @bamfiles, $file;
	}
	return @bamfiles;
}

sub Usage {
	print STDERR "\n Please provide input files!!!\n\n";
	print STDERR "\n Usage:  perl $0 -bam <BAM file path> -genome <genome FASTA file> -depth <minimum depth of coverage to include in output>\n\n";
	exit;
}
