#!/bin/bash
set -euo pipefail

FWD_IN=$1
REV_IN=${FWD_IN/_R1_/_R2_}
FWD_OUT=${FWD_IN/.fastq.gz/.trimmed.fastq.gz}
REV_OUT=${REV_IN/.fastq.gz/.trimmed.fasta.gz}

fastp \
    --in1 "$FWD_IN" \
    --in2 "$REV_IN" \
    --out1 "$FWD_OUT" \
    --out2 "$REV_OUT" \
    --json /dev/null \
    --html /dev/null \
    --trim_front1 8 \
    --trim_front2 8 \
    --trim_tail1 20 \
    --trim_tail2 20 \
    --n_base_limit 0 \
    --length_required 100 \
    --average_qual 20
