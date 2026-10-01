#!/bin/bash
set -ueo pipefail

#download/install files first
./scripts/01_download_data.sh

#for-loop for trimming all files
for FWD_IN in data/raw/*_R1_*.fastq.gz
do
    ./scripts/02_run_fastp.sh "$FWD_IN"
done
