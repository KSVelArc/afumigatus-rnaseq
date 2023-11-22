#!/bin/bash

# Directories
data_dir="$3"
ref_genome="$4"
annotation="$5"
index_prefix="$6"
# SRA IDs
sra_ids="$7"
# Create a list of sample names and gtf file directories. Used to generate DE counts
sample_gtf_list="$8"
# Clear the file if it exists
> "$sample_gtf_list"


map_reads() {
    sra="$1"
    sra_dir="$data_dir/$sra"
    sra_sra="$sra_dir/$sra.sra"
       
    # Map reads to reference genome
    hisat2 -p 8 --dta -x "$index_prefix" -U "$sra_dir/$sra.fastq.gz" -S "$sra_dir/$sra.sam"
    
    # Convert SAM to BAM and sort
    samtools sort -@ 8 "$sra_dir/$sra.sam" -o "$sra_dir/$sra.bam"
    samtools index "$sra_dir/$sra.bam"
    
    # Append sample name and GTF file directory to the list file
    echo "$sra $sra_dir.gtf" >> "$sample_gtf_list"
    
    # Clean up
    #rm "$sra_sra"
    #rm "$sra_dir.sam"
}

# 
for sra_id in "${sra_ids[@]}"; do
    map_reads "$sra_id"
done


# Merge transcripts from all samples
stringtie --merge -p 8 -G "$annotation.gtf" -o "$data_dir/stringtie_merged.gtf" "$data_dir/mergelist.txt"

# Compare the transcripts with the reference annotation
gffcompare -r "$annotation.gtf" -G "$data_dir/stringtie_merged.gtf" -o "$data_dir/merged"

