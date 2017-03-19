#!/bin/sh

mkdir assemblies
mkdir assemblies_500
mkdir BUSCO_stats

perl run_IonT_SPAdes.pl raw_reads/*

#move assemblies to different folder 
for file in *_assembly/scaffolds.fasta; do new="$(echo "$file" | cut -d '_' -f 2)".scaffolds.fasta; cp "$file" "assemblies/$new"; done

#filter contigs on length
for i in assemblies/*.fasta; do perl contig_size_select.pl -low 500 $i > $i.500.fna; done
mv assemblies/*.fna assemblies_500

#Check if genomes are complete gene content wise. Make sure to add the right lineage db to -l
for i in assemblies_500/*.fna

do
	isolate="$(echo "$i" | cut -d '/' -f 2)"
	BUSCO.py -i $i -o BUSCO_$isolate -l /path/to/BUSCO/lineage_data/species_odb9 -m geno
done

#take all summaries
for file in run_BUSCO_*/*.txt; do cp $file BUSCO_stats; done
BUSCO_plot.py -wd BUSCO_stats
