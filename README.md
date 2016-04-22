Sequence-scripts
================

## Trimming raw reads and remove sequencing adapters using [fastq-mcf] (http://ea-utils.googlecode.com/svn/wiki/FastqMcf.wiki)

### Usage
    perl run_fastqMcf.pl directory/containing/raw/reads/only/*
--------------------------------------

## Map trimmed reads to contaminant database and subtract unmapped reads for downstream analysis using [Bowtie2] (http://bowtie-bio.sourceforge.net/bowtie2/index.shtml), [SAMtools] (http://samtools.sourceforge.net) and [bam2fastq] (https://gsl.hudsonalpha.org/information/software/bam2fastq)

### Usage
    perl run_bowtie2_subtract_unmapped_reads.pl directory/containing/trimmed/reads/only/*
--------------------------------------

## Assembling the trimmed and contaminant free reads using [SPAdes] (http://spades.bioinf.spbau.ru)

### Usage
    perl run_SPAdes.pl directory/containing/trimmed/reads/only/*
--------------------------------------

## Perform the previous three steps using one Shell script. It runs fastq-MCF, Bowtie2, SAMtools, bam2fastq and SPAdes assembler in batch

### Usage 
    bash fastqMcf-bowtie2-SPAdes.bash
--------------------------------------

## Calculating average coverage of SPAdes assembly

### Usage
    perl Calc_coverage_from_spades_assembly.pl <scaffolds.fasta>
--------------------------------------

## Running [kSNP] (https://sourceforge.net/projects/ksnp/files/) version 2 using assembled microbial genomes (in fasta format)

### Usage
    perl run_kSNP.pl full/path/containing/the/input/files projectname
--------------------------------------

454 scripts
===========

## Quickly assess binary 454 Standard Flowgram Format (SFF) files from a 454 sequencing run. This simple script counts amount of reads and bases. Script needs SFFinfo

### Usage
    perl BaseCount_sequenceCount_from_sff_file.pl /directory/to/sff/files
--------------------------------------

Eukaryotic part
================

## Generate [EVM] (https://evidencemodeler.github.io) suitable GFF3 files from [MAKER] (http://www.yandell-lab.org/software/maker.html) de novo gene prediction GFF

### Usage
    perl gff3_2_gff3EVM.pl <maker_protein_genes.gff3>
--------------------------------------
