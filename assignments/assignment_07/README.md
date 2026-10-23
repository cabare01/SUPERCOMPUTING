#Catherine Bare
#Assignment_07
#261018

##Script 01_download_data.sh
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


chmod +x 01_download_data.sh 	#run from terminal (not part of script)

##Script 02_clean_reads.sh
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


chmod +x 02_clean_reads.sh 	#run from terminal (not part of script)

##Script 03_map_reads.sh
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

mkdir -p output "$INDEX_DIR"

READS=("$CLEAN_DIR"/*_1.fastq.gz)
((${#READS[@]})) || { echo "No cleaned R1 reads found" >&2; exit 1; }

if [[ ! -d "$INDEX_DIR/ref/genome/1" || ! -d "$INDEX_DIR/ref/index/1" ]]; then
    bbmap.sh -Xmx20g ref="$REF" path="$INDEX_DIR" build=1
fi

for R1 in "${READS[@]}"; do
    R2="${R1%_1.fastq.gz}_2.fastq.gz"
    SAMPLE=$(basename "$R1" _1.fastq.gz)

    [[ -f "$R2" ]] || { printf 'Missing R2 file: %s\n' "$R2" >&2; exit 1; }

    SAM="output/${SAMPLE}.sam"
    MATCHES="output/${SAMPLE}_dog-matches.sam"

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


chmod +x 03_map_reads.sh 	#run from terminal (not part of script)

##Script assignment_07_pipeline.slurm
#!/bin/bash
#SBATCH --job-name=assignment_07
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00
#SBATCH --output=/sciclone/home/cabare01/SUPERCOMPUTING/assignments/assignment_07/output/assignment_07_%j.out
#SBATCH --error=/sciclone/home/cabare01/SUPERCOMPUTING/assignments/assignment_07/output/assignment_07_%j.err
#SBATCH --mail-type=FAIL,BEGIN,END # when to email you
#SBATCH --mail-user=cabare01@wm.edu

set -euo pipefail

cd "$HOME/SUPERCOMPUTING/assignments/assignment_07"

bash scripts/01_download_data.sh
bash scripts/02_clean_reads.sh
bash scripts/03_map_reads.sh



## Read summary

| Sample ID | QC reads | Reads mapped to dog genome |
| SRR19064337 | 24,113,492 | 255 |
| SRR19064458 | 24,811,506 | 349 |
| SRR19064509 | 23,733,892 | 230 |
| SRR19064692 | 23,212,792 | 470 |
| SRR19064699 | 26,237,988 | 1,218 |
| SRR19064761 | 24,455,828 | 672 |
| SRR19064769 | 24,637,800 | 589 |
| SRR19064771 | 25,317,334 | 661 |
| SRR19064776 | 24,731,416 | 574 |
| SRR19064996 | 21,765,268 | 413 |

#Reflection:
One of the biggest challenges in this assignment was troubleshooting the pipeline across multiple SLURM job submissions, since many of the issues I encountered were different from those in previous assignments. I had to work through disk quota limitations multiple times, determine which files and intermediate outputs could be removed to free up space, and redirect files and computational outputs like the raw and clean FASTQ and large SAM files (basically all data files besides the dog match ones) to `scr10` to manage storage more effectively. I also had to troubleshoot software environments, reference-index locations, and mapping failures that prevented the pipeline from completing on earlier attempts. 
These challenges taught me that running a bioinformatics pipeline on an HPC cluster involves more than writing scripts, especially now that we have tools like Positron at our disposal for that piece: it also requires understanding storage limits, file organization, software dependencies, resource allocation, and how to interpret job logs to identify where a process failed. 
Although resolving these issues required multiple submissions and repeated testing, I gained significant practical experience debugging a multi-step computational workflow and learned how to make more informed decisions about managing files and computational resources on Bora, including getting comfortable interacting with the SLURM system.
It was also great to work with a dataset that I could choose! Even though I currently focus on neurodevelopment research for my graduate thesis, I want to move back to neurodegenerative diseases like Parkinson's for my PhD and future career. So much of the research is rooted in bioinformatics now that almost anywhere I end up I know I will be utilizing computational pipelines to analyze my patient data.
