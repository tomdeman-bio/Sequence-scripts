#!/usr/bin/perl

# Written by Tom de Man

use strict;

my $usage = qq(
        USAGE: perl BaseCount_sequenceCount_from_sff_file.pl /path/to/sff/files
        *************************************************
        Arguments is the path to all sff files of a particular library
\n);

die($usage) if (@ARGV == 0);

my $sff_path = $ARGV[0];

my @sffs = &getSff;
my ($base_amount2, $contig_amount2) = &main(@sffs); #put two references into variables


my $count = scalar @$base_amount2;
print "bases: @$base_amount2 \n"; #print dereferenced array
print "reads: @$contig_amount2 \n";#print dereferenced array

my $total_amount_bp = 0;
my $total_amount_contig = 0;
for (my $i = 0; $i < $count; $i++) {
        my $element = pop(@$base_amount2);
	my $element2 = pop(@$contig_amount2);
        $total_amount_bp = $element + $total_amount_bp;
	$total_amount_contig = $element2 + $total_amount_contig;
}
print "The total amount of bases is: $total_amount_bp \n";
print "The total amount of reads is: $total_amount_contig \n";

sub main {
        my @base_amount;
	my @contig_amount;
        foreach my $line (@_) {
                system("sffinfo -s $sff_path$line > $line.fasta");
                my $bases = &count_base("$line");
		my $contigs = &count_read("$line");
		#my $contigs = `grep -c '>' $line.fasta`;
		#print "blaat: $contigs \n";
		chomp($contigs);
                system("rm $line.fasta");
                unshift (@base_amount, $bases);
		unshift (@contig_amount, $contigs);
        }
        return (\@base_amount, \@contig_amount);#make references of the two arrays
}

sub getSff {
        my @sff_docs;
        opendir(DIR, $sff_path) or die "Cannot open $sff_path \n";
        my @sff_files = readdir(DIR);
        close DIR;

        foreach my $sff_file (@sff_files) {
                next if (!($sff_file =~ /\.sff$/));
                push @sff_docs, $sff_file;
        }
        return @sff_docs;
}

sub count_base {
        open FASTA, "<@_[0].fasta";
        my $total_bases = 0;
        while (<FASTA>) {
                if (!(/^>/)) {
                        chomp;
                        s/\r//g;
                        $total_bases += length;
                }
        }
        return $total_bases;
close(FASTA);
}

sub count_read {
	my $counter = 0;
	open FASTA, "<@_[0].fasta";
	while (<FASTA>) {
		$counter++ if tr/>//;
	}	
	return $counter;
}
