#!/bin/bash
set -euo pipefail

# Run from the assignment_06 directory
cd ~/SUPERCOMPUTING/assignments/assignment_06

tail -n 10 assemblies/assembly_conda/conda_flye.log
tail -n 10 assemblies/assembly_module/module_flye.log
tail -n 10 assemblies/assembly_local/local_flye.log
