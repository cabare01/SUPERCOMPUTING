#Catherine Bare
#Assignment_06
#261017

#Task 2: File Download
##Script: 01_download_data.sh
#!/bin/bash
set -ueo pipefail
wget -P /sciclone/home/cabare01/SUPERCOMPUTING/assignments/assignment_06/data https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz?download=1


chmod +x 01_download_data.sh  #in terminal after saving script


#Task 3:
##Script: 02_flye_2.9.6_manual_build.sh
#!/bin/bash
set -ueo pipefail
cd /sciclone/home/cabare01/programs/
git clone https://github.com/fenderglass/Flye
cd Flye
make


chmod +x 02_flye_2.9.6_manual_build.sh #in terminal after saving script


#Add to path (in .bashrc):
export PATH="$HOME/programs/Flye/bin:$PATH"

flye --version  #test flye command


#Task 4: 
##Script: flye_2.9.6_conda_install.sh
#!/bin/bash
set -eo pipefail
	
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


chmod +x flye_2.9.6_conda_install.sh #in terminal after saving script


#Task 5: 
##Commands: 
flye \
    --nano-hq ./data/SRR33939694.fastq \
    --out-dir ./assemblies/assembly_conda \
    --threads 6 \
    --meta

#Task 6:
##Script: 03_run_flye_conda.sh
#!/bin/bash
set -euo pipefail

# Run relative to the assignment_06 directory
cd "$(dirname "$0")/.."

# Load Miniforge and initialize conda
module load miniforge3
source "$(conda info --base)/etc/profile.d/conda.sh"

# Activate the existing Flye environment
conda activate flye-env

# Create the output directory
outdir="./assemblies/assembly_conda"
mkdir -p "$outdir"

# Run Flye
flye --nano-hq ./data/SRR33939694.fastq.gz \
     --threads 6 \
     --meta \
     --out-dir "$outdir"

# Confirm the expected output files exist
test -f "$outdir/assembly.fasta"
test -f "$outdir/flye.log"

# Remove all generated files except the assembly and log
find "$outdir" -mindepth 1 -maxdepth 1 \
    ! -name "assembly.fasta" \
    ! -name "flye.log" \
    -exec rm -rf -- {} +

# Rename the two retained files
mv "$outdir/assembly.fasta" "$outdir/conda_assembly.fasta"
mv "$outdir/flye.log" "$outdir/conda_flye.log"

# Deactivate only after cleanup is complete
conda deactivate
echo "Conda Flye run complete."


chmod +x 03_run_flye_conda.sh  #in terminal after saving script


##Script: 03_run_flye_module.sh
#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

# Load the cluster-provided Flye installation
module load Flye/gcc-11.4.1/2.9.6
outdir="./assemblies/assembly_module"
mkdir -p "$outdir"

# Run the same assembly command
flye --nano-hq ./data/SRR33939694.fastq.gz \
     --threads 6 \
     --meta \
     --out-dir "$outdir"

# Verify the outputs before deleting anything
test -f "$outdir/assembly.fasta"
test -f "$outdir/flye.log"

# Retain only the assembly and log
find "$outdir" -mindepth 1 -maxdepth 1 \
    ! -name "assembly.fasta" \
    ! -name "flye.log" \
    -exec rm -rf -- {} +
mv "$outdir/assembly.fasta" "$outdir/module_assembly.fasta"
mv "$outdir/flye.log" "$outdir/module_flye.log"
echo "Module Flye run complete."


chmod +x 03_run_flye_module.sh  #in terminal after saving script


module load Flye/gcc-11.4.1/2.9.6
flye --version
module unload Flye/gcc-11.4.1/2.9.6

##Script: 03_run_flye_local.sh
#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

# Add the local Flye executable directory to PATH
export PATH="$HOME/programs/Flye/bin:$PATH"

# Confirm the executable being used
command -v flye
flye --version
outdir="./assemblies/assembly_local"
mkdir -p "$outdir"

# Run the same assembly command
flye --nano-hq ./data/SRR33939694.fastq.gz \
     --threads 6 \
     --meta \
     --out-dir "$outdir"

# Verify the expected outputs
test -f "$outdir/assembly.fasta"
test -f "$outdir/flye.log"

# Remove intermediate files
find "$outdir" -mindepth 1 -maxdepth 1 \
    ! -name "assembly.fasta" \
    ! -name "flye.log" \
    -exec rm -rf -- {} +
mv "$outdir/assembly.fasta" "$outdir/local_assembly.fasta"
mv "$outdir/flye.log" "$outdir/local_flye.log"
echo "Local Flye run complete."


chmod +x 03_run_flye_local.sh  #in terminal after saving script


#Task 7:
##Script: 04_compare_flye_logs.sh
#!/bin/bash
set -euo pipefail
tail -n 10 assemblies/assembly_conda/conda_flye.log
tail -n 10 assemblies/assembly_module/module_flye.log
tail -n 10 assemblies/assembly_local/local_flye.log


chmod +x 04_compare_flye_logs.sh #in terminal after saving script


#Task 8:
##Script: pipeline.sh

#!/bin/bash
#SBATCH --job-name=06_flye_pipeline
#SBATCH --output=/sciclone/home/cabare01/SUPERCOMPUTING/assignments/assignment_06/logs/flye_pipeline_%j.out
#SBATCH --error=/sciclone/home/cabare01/SUPERCOMPUTING/assignments/assignment_06/logs/flye_pipeline_%j.err
#SBATCH --time=06:00:00
#SBATCH --cpus-per-task=6
#SBATCH --mem=32G
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=cabare01@wm.edu 

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

# 5. Run Flye using the module
bash scripts/03_run_flye_module.sh

# 6. Run Flye using the local build
bash scripts/03_run_flye_local.sh

# 7. Compare the three log files
bash scripts/04_compare_flye_logs.sh

echo "Flye assignment pipeline completed."


chmod +x pipeline.sh #in terminal after saving script

#REFLECTION:
One of the biggest challenges I encountered during this assignment was getting the Flye installation and assembly pipeline to work reliably on Bora. 
I encountered the same issue across all three Flye methods (Conda, module, and local installations), even with attempting to run my 3 individual scripts multiple times each both on the W&M network and through the W&M VPN from home. 
In every case, the pipeline consistently stopped at the consensus stage immediately after `INFO: Running Minimap2`, followed by the SSH connection to Bora being closed by the remote host.
This made it difficult to determine whether the problem was related to the installation process, the environment configuration, or the connection itself. 
I also encountered Conda package-cache lock warnings during installation before I even got to running Flye in the different ways, which added another layer of troubleshooting. 
I finally submitted the pipeline script as a SLURM job. 
All three methods completed successfully and produced identical assembly statistics: a total assembly length of 91,713 bp, two fragments, an N50 of 47,428 bp, a largest fragment of 47,428 bp, and a mean coverage of 422×. 
The SLURM output file logs/flye_pipeline_560546.out confirms that all three assembly runs finished.
Working through these issues helped me better understand the differences between installing software in a Conda environment, loading software through an HPC module, and compiling software locally as well as in general practice on sorting through error messages and SLURM job outputs to determine job status.
Ideally for the future, any modules I would want to work with are pre-loaded on already since this avoids some of the setup required for a separate Conda environment or local build, but I do appreciate the range provided by being able to use different methods. 
Overall, this assignment gave me more experience managing software and dependencies on a shared computing cluster, submitting jobs to SLURM, troubleshooting remote execution issues, and designing reproducible workflows.
