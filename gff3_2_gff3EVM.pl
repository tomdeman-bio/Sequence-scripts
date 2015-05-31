#!/usr/bin/perl
use strict;

#create EVM suitable GFF3 files from MAKER de novo gene prediction GFF
#Written by Tom de Man

my @pre_name;
my @last_col_split_name;
my @pre_name_extra;
my @pre_name_plus;

my $exon_count = 0;

open(my $gene => ">gene_predictions.EVM.gff3")|| die $!;

while(<>) {
	chomp;
    my @row = split(/\t/,$_);
    my $last_col = pop(@row); 
    my @last_col_split = split(";",$last_col);
	if ($row[1] eq "genemark" && $row[2] eq "gene") {
		@pre_name = split("-", $last_col_split[1]);
		@pre_name_plus = split("=", $last_col_split[1]);
		print $gene join ("\t", @row), "\t$last_col_split[0];$pre_name[0] model $pre_name_plus[1]\n";
	}elsif ($row[1] eq "genemark" && $row[2] eq "mRNA") {
		@last_col_split_name = split("=",$last_col_split[0]);
		print $gene join ("\t", @row), "\tID=$pre_name_plus[1];Parent=$last_col_split_name[1]\n";
	}
	elsif ($row[1] eq "genemark" && $row[2] eq "CDS") {
		$exon_count+=1;
		print $gene "$row[0]\t$row[1]\texon\t$row[3]\t$row[4]\t$row[5]\t$row[6]\t$row[7]\tID=e$exon_count;Parent=$pre_name_plus[1]\n";
		print $gene join ("\t", @row), "\tID=cds_of_$pre_name_plus[1];Parent=$pre_name_plus[1]\n";
	}elsif ($row[1] eq "augustus" && $row[2] eq "gene") {
		@pre_name = split("_", $last_col_split[1]);
		print $gene join ("\t", @row), "\t$last_col_split[0];$pre_name[0] model $pre_name[1]\n";
	}elsif ($row[1] eq "augustus" && $row[2] eq "mRNA") {
		@last_col_split_name = split("=",$last_col_split[0]);
		print $gene join ("\t", @row), "\tID=$pre_name[1];Parent=$last_col_split_name[1]\n";
	}elsif ($row[1] eq "augustus" && $row[2] eq "CDS") {
		$exon_count+=1;
		print $gene "$row[0]\t$row[1]\texon\t$row[3]\t$row[4]\t$row[5]\t$row[6]\t$row[7]\tID=e$exon_count;Parent=$pre_name[1]\n";
		print $gene join ("\t", @row), "\tID=cds_of_$pre_name[1];Parent=$pre_name[1]\n";
	}elsif ($row[1] eq "snap" && $row[2] eq "gene") {
		@pre_name = split ("_", $last_col_split[1]);
		print $gene join ("\t", @row), "\t$last_col_split[0];$pre_name[0] model $pre_name[1]\n";
	}elsif ($row[1] eq "snap" && $row[2] eq "mRNA") {
		@last_col_split_name = split("=",$last_col_split[0]);
		print $gene join ("\t", @row), "\tID=$pre_name[1];Parent=$last_col_split_name[1]\n";
	}elsif ($row[1] eq "snap" && $row[2] eq "CDS") {
		$exon_count+=1;
		print $gene "$row[0]\t$row[1]\texon\t$row[3]\t$row[4]\t$row[5]\t$row[6]\t$row[7]\tID=e$exon_count;Parent=$pre_name[1]\n";
		print $gene join ("\t", @row), "\tID=cds_of_$pre_name[1];Parent=$pre_name[1]\n";
	}
}