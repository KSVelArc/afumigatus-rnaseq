#!/bin/bash

# Directories
# Path to the input data
input_dir="$1"    # $(pwd)
# CPU threads
threads="$2"    # -threads 4
# Trailing
trail="$3"    # TRAILING:10


# Run fastqc and Trimmomatic
qc() {
	file="${input_dir}"/"$1"/"$1".fastq.gz
	fastqc "${file}"
	
    # Extract filename without extension
    filename=$(basename "${file}" .fastq.gz)

    java -jar /Applications/Trimmomatic/trimmomatic.jar SE -threads "${threads}" "${file}" "${filename}"_trimmed.fastq TRAILING:"${trail}" -phred33 
}

for sra_id in "${sra_ids[@]}"; do
    qc "$sra_id"
done
