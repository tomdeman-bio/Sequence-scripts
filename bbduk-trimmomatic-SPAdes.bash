#!/bin/sh

mkdir PhiX_free_reads
mkdir trimmed_PhiX_free_reads

perl run_bbduk.pl raw_reads/*

mv raw_reads/*_noPhiX PhiX_free_reads

perl run_trimmomatic.pl PhiX_free_reads/*

mv PhiX_free_reads/*paired_trimmed* trimmed_PhiX_free_reads

perl run_SPAdes.pl trimmed_PhiX_free_reads/*


