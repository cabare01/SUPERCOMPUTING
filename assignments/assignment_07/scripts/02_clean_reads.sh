#!/bin/bash
set -ueo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

READS=(data/raw/*_1.fastq.gz)

((${#READS[@]})) || { printf 'No R1 FASTQ files found\n' >&2; exit 1; }

for R1 in "${READS[@]}"; do
    R2="${R1%_1.fastq.gz}_2.fastq.gz"
    SAMPLE=$(basename "$R1" _1.fastq.gz)

    [[ -f "$R2" ]] || { printf 'Missing R2 file: %s\n' "$R2" >&2; exit 1; }

    fastp \
        --in1 "$R1" \
        --in2 "$R2" \
        --out1 "data/clean/${SAMPLE}_1.fastq.gz" \
        --out2 "data/clean/${SAMPLE}_2.fastq.gz" \
        --html /dev/null \
        --json /dev/null
done
