#! /usr/bin/perl

# Written by Tom de Man

use strict; 

my $fasta = shift;
my $contig_count = 0;
my $sum_coverage_contigs = 0;

open FA, "$fasta" || die "cannot open $fasta for reading";

while (<FA>) {
	chomp;
	if ((/^>/)) { 
		chomp;
		$contig_count += 1;
		my @split_header = split ("_", $_);
		$sum_coverage_contigs += $split_header[5];
	} else {
		print OUT "$_\n";
	}
}

my $coverage = $sum_coverage_contigs / $contig_count;

print "Amount of contigs: $contig_count\n";
print "--------------------------------\n";
print "coverage on average: $coverage\n";