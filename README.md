Sequence-scripts
================

Trimming raw reads and removing sequencing adapters
---------------------------------------------------
perl run_fastqMcf.pl directory/containing/raw/reads/only/*

Assembling the trimmed reads using SPAdes
-----------------------------------------
perl run_SPAdes.pl directory/containing/trimmed/reads/only/*

Calculating average coverage of SPAdes assembly
-----------------------------------------------
perl Calc_coverage_from_spades_assembly.pl scaffolds.fasta

Running kSNP version 2 using assembled microbial genomes (in fasta format)
--------------------------------------------------------------------------
perl run_kSNP.pl full/path/containing/the/input/files projectname

Map trimmed reads to contaminant database (hard coded for now) and subtract unmapped reads for downstream analysis
------------------------------------------------------------------------------------------------------------------
perl run_bowtie2_subtract_unmapped_reads.pl directory/containing/trimmed/reads/only/*

Eukaryotic part
================

Generate EVM (EvidenceModeler) suitable GFF3 files from MAKER de novo gene prediction GFF
-----------------------------------------------------------------------------------------
perl gff3_2_gff3EVM.pl maker_protein_genes.gff3
