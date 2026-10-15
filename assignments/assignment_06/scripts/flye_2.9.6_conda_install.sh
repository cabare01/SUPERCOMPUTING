#!/bin/bash
set -ueo pipefail

# Load Miniforge
module load miniforge3

# Initialize Conda without running conda init
source "$(conda info --base)/etc/profile.d/conda.sh"

# Create a Conda environment with Flye v2.9.6
mamba create -n flye-env \
    -c conda-forge \
    -c bioconda \
    flye=2.9.6 \
    -y

# Activate the environment
conda activate flye-env

# Test the installed Flye version
flye -v

# Export the environment and its dependencies
conda env export --no-builds > ./flye-env.yml

# Deactivate the environment
conda deactivate
