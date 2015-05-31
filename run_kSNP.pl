#! /usr/bin/perl
#convert dashes in FASTA headers to spaces
#merge all the contigs per sample into one long sequence
#run kSNP

#Written by Tom de Man

#kSNP, Jellyfish, FastTree, MUMmer and Parsimonator all need to be in the PATH variable before launching this script
use strict;

#path containing the input files
my $file_path = shift;
#project name
my $project = shift;
my @fastas = &getFile;

foreach my $fasta (@fastas) {
	open FILE, "$fasta";
	my @lines = <FILE>;
	close FILE;
	
	open STDOUT, ">$fasta";
	for (@lines) {
		$_ =~ s/_/ /g;
		print;
	}
	close STDOUT;
}

my @new_fastas = &getFile;
foreach my $file (@new_fastas) {
	system("merge_fasta_contigs.pl $file > $file.merged.fasta");
}

#combine all the fasta files that come from merge_fasta_contigs
system("cat *.fasta > $project.fasta");
#run kSNP using the merged fasta file
`kSNP -f $project.fasta -k 23 -d $project -p $project.finished`;

sub getFile {
        my @file_docs;
        opendir(DIR, $file_path) or die "Cannot open $file_path \n";
        my @file_files = readdir(DIR);
        close DIR;

        foreach my $file (@file_files) {
                next if (!($file =~ /\.fa$/));
                push @file_docs, $file;
        }
        return @file_docs;
}
