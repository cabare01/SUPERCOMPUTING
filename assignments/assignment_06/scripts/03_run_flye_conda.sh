#!/bin/bash
set -euo pipefail

# Run relative to the assignment_06 directory
cd "$(dirname "$0")/.."

# Load Miniforge and initialize conda
module load miniforge3
source "$(conda info --base)/etc/profile.d/conda.sh"

# Activate the existing Flye environment
conda activate flye-env

# Create the output directory
outdir="./assemblies/assembly_conda"
mkdir -p "$outdir"

# Run Flye
flye --nano-hq ./data/SRR33939694.fastq.gz \
     --threads 6 \
     --meta \
     --out-dir "$outdir"

# Confirm the expected output files exist
test -f "$outdir/assembly.fasta"
test -f "$outdir/flye.log"

# Remove all generated files except the assembly and log
find "$outdir" -mindepth 1 -maxdepth 1 \
    ! -name "assembly.fasta" \
    ! -name "flye.log" \
    -exec rm -rf -- {} +

# Rename the two retained files
mv "$outdir/assembly.fasta" "$outdir/conda_assembly.fasta"
mv "$outdir/flye.log" "$outdir/conda_flye.log"

# Deactivate only after cleanup is complete
conda deactivate

echo "Conda Flye run complete."
