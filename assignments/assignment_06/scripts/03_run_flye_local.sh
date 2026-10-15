#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

# Add the local Flye executable directory to PATH
export PATH="$HOME/programs/Flye/bin:$PATH"

# Confirm the executable being used
command -v flye
flye --version

outdir="./assemblies/assembly_local"
mkdir -p "$outdir"

# Run the same assembly command
flye --nano-hq ./data/SRR33939694.fastq.gz \
     --threads 6 \
     --meta \
     --out-dir "$outdir"

# Verify the expected outputs
test -f "$outdir/assembly.fasta"
test -f "$outdir/flye.log"

# Remove intermediate files
find "$outdir" -mindepth 1 -maxdepth 1 \
    ! -name "assembly.fasta" \
    ! -name "flye.log" \
    -exec rm -rf -- {} +

mv "$outdir/assembly.fasta" "$outdir/local_assembly.fasta"
mv "$outdir/flye.log" "$outdir/local_flye.log"

echo "Local Flye run complete."
