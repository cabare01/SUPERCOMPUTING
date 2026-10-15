#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

# Load the cluster-provided Flye installation
module load Flye/gcc-11.4.1/2.9.6

outdir="./assemblies/assembly_module"
mkdir -p "$outdir"

# Run the same assembly command
flye --nano-hq ./data/SRR33939694.fastq.gz \
     --threads 6 \
     --meta \
     --out-dir "$outdir"

# Verify the outputs before deleting anything
test -f "$outdir/assembly.fasta"
test -f "$outdir/flye.log"

# Retain only the assembly and log
find "$outdir" -mindepth 1 -maxdepth 1 \
    ! -name "assembly.fasta" \
    ! -name "flye.log" \
    -exec rm -rf -- {} +

mv "$outdir/assembly.fasta" "$outdir/module_assembly.fasta"
mv "$outdir/flye.log" "$outdir/module_flye.log"

echo "Module Flye run complete."
