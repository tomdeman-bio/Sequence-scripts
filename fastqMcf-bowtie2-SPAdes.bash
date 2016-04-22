#!/bin/sh

mkdir trimmed_reads
mkdir trimmed_viral_free_reads

perl run_fastqMcf.pl raw_reads/*

mv raw_reads/*trimmed* trimmed_reads

perl run_bowtie2_subtract_unmapped_reads.pl trimmed_reads/*

mv trimmed_reads/*bacterial* trimmed_viral_free_reads

perl run_SPAdes.pl trimmed_viral_free_reads/*


