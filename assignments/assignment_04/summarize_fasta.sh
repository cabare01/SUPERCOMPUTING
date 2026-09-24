#!/bin/bash
set -ueo pipefail

# Store the input FASTA filename
fasta=$1

# Get total number of sequences and total number of nucleotides
totals=$(seqtk size "$fasta")
total_sequences=$(echo "$totals" | awk '{print $1}')
total_nucleotides=$(echo "$totals" | awk '{print $2}')

# Print summary
echo "FASTA file: $fasta"
echo "Total number of sequences: $total_sequences"
echo "Total number of nucleotides: $total_nucleotides"
echo
echo "Sequence names and lengths:"
seqtk comp "$fasta" | awk '{print $1 "\t" $2}'
