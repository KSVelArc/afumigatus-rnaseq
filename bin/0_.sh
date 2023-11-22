#!/bin/bash

# Directories
fungidb="https://fungidb.org/common/downloads/release-2.0/Afumigatus_AF293B"
fungidb_genome="$fungidb/fasta/data/FungiDB-CURRENT_Afumigatus_AF293B_Genome.fasta"
fungidb_annotation="$fungidb/gff/data/a_fumigatus%20Af293.gff"
data_dir="../data"
ref_genome="$data_dir/Afumigatus_AF293B_Genome.fasta"
annotation="$data_dir/a_fumigatus_Af293"
index_prefix="$data_dir/af_index"
# SRA IDs
sra_ids=("SRX2000912" "SRX2000913" "SRX2000916" "SRX2000917")
# Create a list of sample names and gtf file directories. Used to generate DE counts
sample_gtf_list="$data_dir/de_samples.txt"
# Clear the file if it exists
> "$sample_gtf_list"
threads="4"
trailing="10"

# Create data directory if it doesn't exist
mkdir -p "$data_dir"

# List of scripts in the pipeline
scripts=("1_get_ref.sh")

# Declare an associative array
declare -A my_dict
my_dict["1_get_ref.sh"]="bash $full_path \"$fungidb_genome\" \"$fungidb_annotation\" \"$data_dir\" \"$ref_genome\" \"$annotation\" \"$index_prefix\" \"$sra_ids\""
my_dict["2"]="bash $full_path \"$data_dir\" \"$threads\" \"$trailing\""
my_dict["3"]="value3"

# Make scripts executable and run
make_executable() {
  full_path="$1"
  if [ -x "$full_path" ]; then
    echo "$script is executable. Running..."
  else
    echo "$script is not executable. Adding execute permission..."
    chmod +x "$full_path"
    echo "Execute permission added to $script."
  fi
}

# Iterate over keys and values
for key in "${!my_dict[@]}"; do
	make_executable "$key"
    eval "bash $key ${my_dict[$key]}"
done

  run_1="bash $full_path \"$fungidb_genome\" \"$fungidb_annotation\" \"$data_dir\" \"$ref_genome\" \"$annotation\" \"$index_prefix\" \"$sra_ids\""

  eval "$run_1"
  
  run_2="bash $full_path \"$data_dir\" \"$threads\" \"$trailing\"
  
  
done
