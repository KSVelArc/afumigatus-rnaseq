#!/bin/bash

# Directories
fungidb_genome="$1"
fungidb_annotation="$2"
data_dir="$3"
ref_genome="$4"
annotation="$5"
index_prefix="$6"
# SRA IDs
sra_ids="$7"

# Create data directory if it doesn't exist
#mkdir -p "$data_dir"

download_reference() {
    # Download reference genome and annotation
    echo "Downloading the reference genome..."
    wget -q "$fungidb_genome" -O "$ref_genome"
    echo "Done."
    echo "Downloading the gnome annotation..."
    wget -q "$fungidb_annotation" -O "$annotation.0.gff"
    echo "Done."
    
    # Format ids similar to the ids in the reference genome
    sed 's/apidb/JVCI/g' "$annotation.0.gff" > "$annotation.gff"
    
    # Convert from gff to gtf
    agat_convert_sp_gff2gtf.pl --gff "$annotation.gff" -O "$annotation.gtf"
    
    # Index the reference genome
    echo "Indexing the reference genome"
    hisat2-build -p 8 "$ref_genome" "$index_prefix"
    echo "Done."
}


download_reads() {
    sra="$1"
    sra_dir="$data_dir/$sra"
    sra_sra="$sra_dir/$sra.sra"
    echo "Downloading $sra..."
    # Download SRA data
    prefetch "$sra" --output-file "$sra_sra"
    echo "Converting $sra to FASTQ..."
    # Convert SRA to FASTQ
    fastq-dump "$sra_sra" --outdir "$sra_dir"
    gzip "$sra_dir/$sra.fastq"
        
    # Clean up
    #rm "$sra_sra"
    #rm "$sra_dir.sam"
}

# Download A. fumigatus genome reference and annotations
download_reference

# Download reads files
for sra_id in "${sra_ids[@]}"; do
    download_reads "$sra_id"
done

