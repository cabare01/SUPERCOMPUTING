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

#bash scripts/01_download_data.sh
#bash scripts/02_clean_reads.sh
bash scripts/03_map_reads.sh

