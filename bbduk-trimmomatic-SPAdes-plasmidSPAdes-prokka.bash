#!/bin/sh

mkdir PhiX_free_reads
mkdir trimmed_PhiX_free_reads
mkdir assemblies
mkdir Plasmid_assemblies
mkdir Prokka_stats

perl run_bbduk.pl raw_reads/*

mv raw_reads/*_noPhiX PhiX_free_reads

perl run_trimmomatic.pl PhiX_free_reads/*

mv PhiX_free_reads/*paired_trimmed* trimmed_PhiX_free_reads

perl run_SPAdes.pl trimmed_PhiX_free_reads/*
perl run_plasmidSPAdes.pl trimmed_PhiX_free_reads/*

for file in *_assembly/scaffolds.fasta; do new="$(echo "$file" | cut -d '_' -f 1)".scaffolds.fasta; cp "$file" "assemblies/$new"; done
for file in *_PLASMID_contigs/scaffolds.fasta; do new="$(echo "$file" | cut -d '_' -f 1)".scaffolds.fasta; cp "$file" "Plasmid_assemblies/$new"; done

for i in assemblies/*.fasta

do
        location="$(echo "$i" | cut -d '.' -f 1)"
		name="$(echo "$location" | cut -d '/' -f 2)"
        prokka --kingdom Bacteria --outdir prokkaDIR_$name --locustag $name $i
done

for file in prokkaDIR_*/*.txt; do cp $file Prokka_stats; done
