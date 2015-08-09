Sequence-scripts
================

Trimming raw reads and removing sequencing adapters
---------------------------------------------------
perl run_fastqMcf.pl directory_containing_raw_reads_only/*

Assembling the trimmed reads using SPAdes
-----------------------------------------
perl run_SPAdes.pl directory_containing_trimmed_reads_only/*

Calculating average coverage of SPAdes assembly
-----------------------------------------------
perl Calc_coverage_from_spades_assembly.pl scaffolds.fasta

Running kSNP version 2 using assembled microbial genomes (in fasta format)
--------------------------------------------------------------------------
perl run_kSNP.pl full_path_containing_the_input_files projectname


