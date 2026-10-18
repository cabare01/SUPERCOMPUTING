#!/bin/bash
#SBATCH --job-name=06_flye_pipeline
#SBATCH --output=/sciclone/home/cabare01/SUPERCOMPUTING/assignments/assignment_06/logs/flye_pipeline_%j.out
#SBATCH --error=/sciclone/home/cabare01/SUPERCOMPUTING/assignments/assignment_06/logs/flye_pipeline_%j.err
#SBATCH --time=03:00:00
#SBATCH --cpus-per-task=6
#SBATCH --mem=32G
#SBATCH --mail-type=FAIL,BEGIN,END # when to email you
#SBATCH --mail-user=cabare01@wm.edu # who to email

set -ueo pipefail

# Always run from the assignment_06 directory
cd $HOME/SUPERCOMPUTING/assignments/assignment_06

# 2. Build Flye locally bash scripts/02_flye_2.9.6_manual_build.sh

# 3. Install Flye in the conda environment bash scripts/flye_2.9.6_conda_install.sh

# 4. Run Flye using conda bash scripts/03_run_flye_conda.sh

# 5. Run Flye using the module
bash scripts/03_run_flye_module.sh

# 6. Run Flye using the local build bash scripts/03_run_flye_local.sh

# 7. Compare the three log files
bash scripts/04_compare_flye_logs.sh

echo "Flye assignment pipeline completed"
