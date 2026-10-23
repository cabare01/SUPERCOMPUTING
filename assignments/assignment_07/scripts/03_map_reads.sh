#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

module load miniforge3
source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh
conda activate bbmap-env

CLEAN_DIR="/sciclone/home/cabare01/scr10/assignment_07/data"
INDEX_DIR="/sciclone/home/cabare01/scr10/assignment_07/bbmap_index"
SAM_DIR="/sciclone/home/cabare01/scr10/assignment_07"

command -v bbmap.sh >/dev/null 2>&1 || { echo "bbmap.sh not found" >&2; exit 1; }
command -v samtools >/dev/null 2>&1 || { echo "samtools not found" >&2; exit 1; }

shopt -s nullglob

REFS=(data/dog_reference/*.fna \
      data/dog_reference/*.fa \
      data/dog_reference/*.fasta)

((${#REFS[@]} == 1)) || {
    printf 'Expected exactly one dog reference FASTA; found %s\n' "${#REFS[@]}" >&2
    printf '%s\n' "${REFS[@]}" >&2
    exit 1
}

REF="${REFS[0]}"

mkdir -p output "$INDEX_DIR" "$SAM_DIR"

READS=("$CLEAN_DIR"/*_1.fastq.gz)
((${#READS[@]})) || { echo "No cleaned R1 reads found" >&2; exit 1; }

if [[ ! -d "$INDEX_DIR/ref/genome/1" || ! -d "$INDEX_DIR/ref/index/1" ]]; then
    bbmap.sh -Xmx20g ref="$REF" path="$INDEX_DIR" build=1
fi

for R1 in "${READS[@]}"; do
    R2="${R1%_1.fastq.gz}_2.fastq.gz"
    SAMPLE=$(basename "$R1" _1.fastq.gz)

    [[ -f "$R2" ]] || { printf 'Missing R2 file: %s\n' "$R2" >&2; exit 1; }

    SAM="$SAM_DIR/${SAMPLE}.sam"
    MATCHES="output/${SAMPLE}_dog-matches.sam"

    [[ -s "$MATCHES" ]] && continue

    bbmap.sh \
        -Xmx20g \
        path="$INDEX_DIR" \
        build=1 \
        in1="$R1" \
        in2="$R2" \
        out="$SAM" \
        minid=0.95 \
        idfilter=0.95 \
        threads=8 \
        overwrite=t

    samtools view -h -F 4 -o "$MATCHES" "$SAM"
done
