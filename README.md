Sequence-scripts
================

## Determine the core genome size of a given dataset. The script is assessing sorted BAM files, and the mapping reference in order to estimate the core genome size for a certain depth of coverage. The script needs [samtools](https://github.com/samtools/), [bedtools](http://bedtools.readthedocs.io/en/latest/), and awk.

### Usage
    perl estimate_core_genome_from_bam.pl -bam /path/to/bam/files -genome mapping/reference/fasta/file -depth 10
----------------------------------------------------------------------------------------------------------------

## Calculate simple genome assembly stats including N50, number of contigs, total bases, and G+C content

### Usage
    perl calc_N50_GC_genomesize.pl -i genomeAssembly.fasta -o output.stats
--------------------------------------------------------------------------

## Screen raw reads for contamination and get an impression of the bacterial composition of your sample(s). Script is using [Kraken](https://ccb.jhu.edu/software/kraken/) for determining species composition, [KronaTools](https://github.com/marbl/Krona/wiki/KronaTools) for generating multi-layered pie charts, and conversion script [metaphlan2krona.py](https://bitbucket.org/nsegata/metaphlan/src/2f1b17a1f4e9775fe1ce42c8481279a5e69f291f/conversion_scripts/metaphlan2krona.py?at=default)

### Usage
    bash Kraken_krona_fastq.bash
--------------------------------

## Trimming raw reads and remove sequencing adapters using [fastq-mcf](http://ea-utils.googlecode.com/svn/wiki/FastqMcf.wiki)

### Usage
    perl run_fastqMcf.pl directory/containing/raw/reads/only/*
--------------------------------------------------------------

## Map trimmed reads to contaminant (e.g. PhiX) database and subtract unmapped reads for downstream analysis using [Bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml), [SAMtools](http://samtools.sourceforge.net) and [bam2fastq](https://gsl.hudsonalpha.org/information/software/bam2fastq)

### Usage
    perl run_bowtie2_subtract_unmapped_reads.pl directory/containing/trimmed/reads/only/*
-----------------------------------------------------------------------------------------

## Assembling the trimmed and contaminant free reads using [SPAdes](http://spades.bioinf.spbau.ru)

### Usage
    perl run_SPAdes.pl directory/containing/trimmed/and/virus/free/reads/only/*
-------------------------------------------------------------------------------

## Perform the previous three steps using one Shell script. It runs fastq-MCF, Bowtie2, SAMtools, bam2fastq and SPAdes assembler in batch

### Usage 
    bash fastqMcf-bowtie2-SPAdes.bash
--------------------------------------

## Calculating average K-mer coverage of SPAdes assembly, from your highest K value (usually k=127)

### Usage
    perl Calc_coverage_from_spades_assembly.pl <scaffolds.fasta>
----------------------------------------------------------------

## Correcting PacBio data with Illumina reads by means of [Bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml) and [Pilon](https://github.com/broadinstitute/pilon/wiki) 

### Usage
    perl run_bowtie2_and_pilon.pl <PacBio-unitigs.fasta> path/to/trimmed/Illumina/reads/*
-----------------------------------------------------------------------------------------

## Running [kSNP](https://sourceforge.net/projects/ksnp/files/) version 2 using assembled microbial genomes (in fasta format)

### Usage
    perl run_kSNP.pl full/path/containing/the/input/files projectname
---------------------------------------------------------------------

IonTorrent scripts
==================

## Assemble Single-End (SE) IonTorrent reads with [SPAdes](http://spades.bioinf.spbau.ru)

### Usage
    perl run_IonT_SPAdes.pl directory/containing/trimmed/SE-reads/only/*
--------------------------------------------------------------------------

## Bash workflow script for trimming SE IonTorrent reads, assembling trimmed reads, and quality check contigs using [BUSCO 2.0](http://busco.ezlab.org)

### Usage
    bash IonTorrent_SE_run.bash
-------------------------------

454 scripts
===========

## Quickly assess binary 454 Standard Flowgram Format (SFF) files from a 454 sequencing run. This simple script counts amount of reads and bases. Script needs SFFinfo

### Usage
    perl BaseCount_sequenceCount_from_sff_file.pl /directory/to/sff/files
--------------------------------------

Eukaryotic part
================

## Generate [EVM](https://evidencemodeler.github.io) suitable GFF3 files from [MAKER](http://www.yandell-lab.org/software/maker.html) de novo gene prediction GFF

### Usage
    perl gff3_2_gff3EVM.pl <maker_protein_genes.gff3>
--------------------------------------

## Make EVM data compatible with [Gbrowse](http://gbrowse.org/index.html)

### Usage
    perl fix_evm_for_gbrowse.pl < inputfile.gff3
--------------------------------------
