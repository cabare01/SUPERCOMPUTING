#!/bin/bash
set -euo pipefail

# Always run from the assignment_06 directory
cd ~SUPERCOMPUTING/assignments/assignment_06

# 1. Download the input data
bash scripts/01_download_data.sh

# 2. Build Flye locally
bash scripts/02_flye_2.9.6_manual_build.sh

# 3. Install Flye in the conda environment
bash scripts/flye_2.9.6_conda_install.sh

# 4. Run Flye using conda
bash scripts/03_run_flye_conda.sh

# 5. Run Flye using the modulebash scripts/03_run_flye_module.sh

# 6. Run Flye using the local build
bash scripts/03_run_flye_local.sh

# 7. Compare the three log files
bash scripts/04_compare_flye_logs.sh

echo "Flye assignment pipeline completed"
