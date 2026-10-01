#Catherine Bare
#Assignment_05
#260930

##**01_download_data.sh**
- download & prep data for future use
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

- chmod +x run after script creation for execution permissions.

##**02_run_fastp.sh**
- process a single sample's forward and reverse reads using the fastp software
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

- chmod +x run after script creation for execution permissions.

##**pipeline.sh**
- run the file download/prep and trimming scripts together so it loops over and automatically processes each fastq file
#!/bin/bash
set -ueo pipefail

#download/install files first
./scripts/01_download_data.sh

#for-loop for trimming all files
for FWD_IN in data/raw/*_R1_*.fastq.gz
do
    ./scripts/02_run_fastp.sh "$FWD_IN"
done

- chmod +x run after script creation for execution permissions.


#REFLECTION
One of the biggest challenges I had with this assignment was getting comfortable with how Bash scripts interact with file paths and with each other.
I had to troubleshoot where files were being downloaded and extracted, as well as make sure that my scripts were using the correct paths for the raw and trimmed data.
I also had to figure out how to install `fastp` and add it to my `$PATH` so that I could call it from the command line. 
This was helpful because it made me think more about how Bash finds and runs programs, especially continuing to put into practice my knowledge of standard inputs and outputs as well as variables and other syntax.
I practiced several relatively new concepts for writing Bash scripts during this assignment. In particular, I practiced how to use variables and command-line arguments to make a script work with different files instead of writing a separate command for every sample like how the `02_run_fastp.sh` script uses the name of a forward-read file to determine the corresponding reverse-read file and the names of the trimmed output files. 
I also learned more about shell patterns, such as using `*.fastq.gz` to work with all of the FASTQ files without having to list them individually. 
This showed me how scripting can make working with large numbers of files much more efficient.
I also have a better understanding of why the assignment separates the workflow into two scripts and then uses a third pipeline script to run them. 
The first script is responsible for downloading and organizing the data, while the second script is responsible for running `fastp` on an individual sample. 
The `pipeline.sh` script connects these steps by downloading the data first and then looping through the raw files and running the trimming script on each sample. 
Splitting the workflow this way makes each script easier to understand, test, and troubleshoot. 
For example, I could easily test the `fastp` script on one sample so I could see and understand the script's actions right away without having to run the entire workflow.
There are some disadvantages to this approach because there are more files to keep track of, and an error in one script, especially if that script is close to the beginning of the workflow, can affect the entire pipeline. However, I think the advantages definitely outweight those for the larger datasets I am preparing to work with for my class project and when I apply this to my research datasets, and tools like the 'set -ueo pipefail' line help make errors more transparent. The scripts can be reused, individual steps can be changed without rewriting the entire workflow, and the pipeline makes the process reproducible. Overall, this assignment helped me understand how Bash can be used to automate a series of data-processing steps instead of manually running the same commands over and over because, as mentioned in Task 4 of the assigment, that definitely seems sociopathic.

