#!/bin/bash
set -ueo pipefail

ASSIGNMENT_DIR="$HOME/SUPERCOMPUTING/assignments/assignment_07"
DATA_DIR="$ASSIGNMENT_DIR/data"

METADATA="$DATA_DIR/SraRunTable.csv"

FASTQ_DIR="$DATA_DIR/raw"
DOG_DIR="$DATA_DIR/dog_reference"
TEMP_DIR="$DATA_DIR/fasterq_tmp"

mkdir -p "$TEMP_DIR"

command -v fasterq-dump >/dev/null 2>&1
command -v datasets >/dev/null 2>&1

[[ -f "$METADATA" ]]

tail -n +2 "$METADATA" | cut -d',' -f1 | while IFS= read -r RUN
do
    RUN=$(echo "$RUN" | tr -d '"' | xargs)

    [[ -z "$RUN" ]] && continue

    if [[ -f "$FASTQ_DIR/${RUN}_1.fastq.gz" && -f "$FASTQ_DIR/${RUN}_2.fastq.gz" ]]; then
        continue
    fi

    rm -f "$FASTQ_DIR/${RUN}_1.fastq" \
          "$FASTQ_DIR/${RUN}_2.fastq" \
          "$FASTQ_DIR/${RUN}_1.fastq.gz" \
          "$FASTQ_DIR/${RUN}_2.fastq.gz"

    fasterq-dump "$RUN" \
        --outdir "$FASTQ_DIR" \
        --split-files \
        --threads 6 \
        --temp "$TEMP_DIR"

    gzip "$FASTQ_DIR/${RUN}_1.fastq" "$FASTQ_DIR/${RUN}_2.fastq"
done

cd "$DOG_DIR"

datasets download genome taxon "Canis familiaris" \
    --reference \
    --include genome

unzip -o ncbi_dataset.zip

find ncbi_dataset -type f \( -name "*.fna" -o -name "*.fa" -o -name "*.fasta" \) \
    -exec cp {} "$DOG_DIR" \;

rm -rf ncbi_dataset
rm -f ncbi_dataset.zip
rm -rf "$TEMP_DIR"

