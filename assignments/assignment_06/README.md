#Catherine Bare
#Assignment_06
#261006

#Task 2: File Download
##Script: 01_download_data.sh
	#!/bin/bash
	set -ueo pipefail
	wget -P /sciclone/home/cabare01/SUPERCOMPUTING/assignments/assignment_06/data https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz?download=1

#Task 3:
##Script: 02_flye_2.9.6_manual_build.sh
	#!/bin/bash
	set -ueo pipefail
	cd /sciclone/home/cabare01/programs/
	git clone https://github.com/fenderglass/Flye
	cd Flye
	make

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


	chmod +x 03_run_flye_conda.sh

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


	chmod +x 03_run_flye_module.sh

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


	chmod +x 03_run_flye_local.sh

#Task 7:
##Script: 04_compare_flye_logs.sh
	#!/bin/bash
	set -euo pipefail
	tail -n 10 assemblies/assembly_conda/conda_flye.log
	tail -n 10 assemblies/assembly_module/module_flye.log
	tail -n 10 assemblies/assembly_local/local_flye.log
chmod +x 04_compare_flye_logs.sh

#Task 8:
##Script: pipeline.sh

#!/bin/bash
set -euo pipefail

# Always run from the assignment_06 directory
cd ~SUPERCOMPUTING/assignments/assignment_06

# 1. Download the input data
echo "[1/7] Downloading data..."
bash scripts/01_download_data.sh

# 2. Build Flye locally
echo "[2/7] Building local Flye..."
bash scripts/02_flye_2.9.6_manual_build.sh

# 3. Install Flye in the conda environment
echo "[3/7] Setting up the conda environment..."
bash scripts/flye_2.9.6_conda_install.sh

# 4. Run Flye using conda
echo "[4/7] Running Flye with conda..."
bash scripts/03_run_flye_conda.sh

# 5. Run Flye using the module
echo "[5/7] Running Flye with the module..."
bash scripts/03_run_flye_module.sh

# 6. Run Flye using the local build
echo "[6/7] Running Flye with the local build..."
bash scripts/03_run_flye_local.sh

# 7. Compare the three log files
echo "[7/7] Comparing Flye logs..."
bash scripts/04_compare_flye_logs.sh

echo "Flye assignment pipeline completed.


#REFLECTION:
One of the biggest challenges I encountered during this assignment was getting the Flye installation and assembly pipeline to work reliably on Bora. 
I initially had trouble with the Miniforge/Conda portion of the workflow because my remote connection to Bora would repeatedly drop when I reached that step. 
This made it difficult to determine whether the problem was related to the installation process, the environment configuration, or the connection itself. 
I also encountered Conda package-cache lock warnings during installation, which added another layer of troubleshooting. 
Although the installation eventually completed and Flye reported version 2.9.6, the repeated disconnections made it difficult to run and verify the entire workflow consistently.
Working through these issues helped me better understand the differences between installing software in a Conda environment, loading software through an HPC module, and compiling software locally.
Ideally for the future, any modules I would want to work with are pre-loaded on already since this avoids some of the setup required for a separate Conda environment or local build, but I do appreciate the range provided by being able to use different methods. 
Overall, this assignment gave me more experience managing software and dependencies on a shared computing cluster, troubleshooting remote execution issues, and designing reproducible workflows.
