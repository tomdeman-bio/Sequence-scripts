#!/bin/bash

kraken_db="/path/to/custom/Kraken-RefSeq/database/"

for file in *_R1_001.fastq

do
	b=$(basename $file _R1_001.fastq)
	rev=${b}_R2_001.fastq

	echo "[:] Analyzing $file and $rev"

	kraken --version

	echo "[:] Running kraken.  Output: $file.kraken / $file.classified"

	kraken --fastq-input --paired --db $kraken_db --preload --threads 12 --output $file.kraken --classified-out $file.classified $file $rev

	echo "[:] Generating metaphlan compatible report."

	kraken-mpa-report --db $kraken_db $file.kraken >> $file.mpa

	echo "[:] Generating krona output for $file."

	python metaphlan2krona.py -p $file.mpa -k $file.krona

done
ktImportText -o all_output.html *.krona