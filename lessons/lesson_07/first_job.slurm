#!/bin/bash
#SBATCH --job-name=myfirstjob
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=1
#SBATCH --mem=1G
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=cabare01@wm.edu             
#SBATCH -o /sciclone/home/cabare01/logs/firstjob_%j.out 
#SBATCH -e /sciclone/home/cabare01/logs/firstjob_%j.err 

sleep 30 
echo "Hello world!"
