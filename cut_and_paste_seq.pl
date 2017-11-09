#!/usr/bin/perl

# Written by Tom de Man
# Cut DNA sequence at a user defined position, and paste it at the end of that same sequence
# Useful when generating plasmid DNA sequence comparison plots with Easyfig or Geneious
# Needs BioPerl 

use strict;
use warnings;
use Bio::SeqIO;
use Getopt::Long;

my $end_pos;
my $fasta;
my $strand;

GetOptions(	"cut=s"			=> \$end_pos,
			"seq=s"			=> \$fasta,
			"strand=s"		=> \$strand,
			"help|?"		=> sub {Usage()}
);

if (($end_pos) && ($fasta) && ($strand)) {
	&subseq($end_pos, $fasta, $strand);
} else {
	&Usage;
}

sub subseq {
	my ($end, $input_seq, $direction) = @_;
	my $seqin  = Bio::SeqIO->new(-file => "$input_seq", -format => "fasta");
	while (my $seq = $seqin->next_seq) {
		my $acc = $seq->display_id;
		my $sequence = $seq->seq;
		
		print ">$acc\n";
		if ($strand eq "forward") {
			my $first = substr($sequence, 0, $end);
			my $last = substr($sequence, $end);
			print "$last"."$first"."\n";
		} elsif ($strand eq "reverse") {
			my $revcomp = reverse($sequence);
			$revcomp =~ tr/ABCDGHMNRSTUVWXYabcdghmnrstuvwxy/TVGHCDKNYSAABWXRtvghcdknysaabwxr/;
			my $len = length $revcomp;
			my $rev_pos = $len - $end;
			
			my $first = substr($revcomp, 0, $rev_pos);
			my $last = substr($revcomp, $rev_pos);
			my $out = "$last"."$first";
			print "$out \n";
		}
	}		
}

sub Usage {
	print STDERR "\n Please provide input sequence file, cutting position, and strand direction\n\n";
	print STDERR "\n Usage:  perl $0 -cut <cut position> -strand <either \"forward\" or \"reverse\" strand> -seq <input FASTA file> \n\n";
	exit;
}