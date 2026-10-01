#!/bin/bash
set -ueo pipefail

# Download the FASTQ tarball
wget https://gzahn.github.io/data/fastq_examples.tar

# Extract the tarball
tar -xf fastq_examples.tar

# Move FASTQ files into data/raw/
mv *.fastq.gz data/raw/

# Remove the tarball
rm fastq_examples.tar
