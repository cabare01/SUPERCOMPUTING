#Assignment 4
#Catherine Bare
#260922

# Task 1–3: gh Installation
cd ~/programs
wget https://github.com/cli/cli/releases/download/v2.74.2/gh_2.74.2_linux_amd64.tar.gz
tar -xzvf gh_2.74.2_linux_amd64.tar.gz
~/programs/gh_2.74.2_linux_amd64/bin/gh
nano install_gh.sh

Purposes:
- downloaded gh
- unpacked it
- created install_gh.sh
- cleaned up the downloaded tarball

install_gh.sh:
#!/bin/bash
set -ueo pipefail
wget https://github.com/cli/cli/releases/download/v2.74.2/gh_2.74.2_linux_amd64.tar.gz
tar -xzvf gh_2.74.2_linux_amd64.tar.gz
rm gh_2.74.2_linux_amd64.tar.gz


# Task 4–5: PATH and GitHub
chmod +x install_gh.sh
export PATH=$PATH:$HOME/programs/gh_2.74.2_linux_amd64/bin
echo $PATH
gh --version
gh auth login
gh auth status

Purposes:
- added gh to PATH
- ran gh auth login
- verified gh

# Task 6–7: seqtk
nano install_seqtk.sh
git clone https://github.com/lh3/seqtk.git
cd seqtk
make
source ~/.bashrc
echo $PATH
which seqtk

Purposes:
- created install_seqtk.sh
- installed seqtk
- added seqtk to PATH
- explored seqtk functionality

install_seqtk.sh:
#!/bin/bash
set -ueo pipefail
# download seqtk
cd ~/programs
git clone https://github.com/lh3/seqtk.git
# unpack/build seqtk
cd seqtk
make
# add its directory to ~/.bashrc
echo "export PATH=\$PATH:\$HOME/programs/seqtk" >> ~/.bashrc


# Task 8: summarize_fasta.sh
nano summarize_fasta.sh
chmod +x summarize_fasta.sh
./summarize_fasta.sh data/ecoli.fna  #script test

Purposes:
- accepts FASTA filename as $1
- calculates number of sequences
- calculates total nucleotides
- produces sequence name/length table

summarize_fasta.sh:
#!/bin/bash
set -ueo pipefail

# Store the input FASTA filename
fasta=$1

# Get total number of sequences and total number of nucleotides
totals=$(seqtk size "$fasta")
total_sequences=$(echo "$totals" | awk '{print $1}')
total_nucleotides=$(echo "$totals" | awk '{print $2}')

# Print summary
echo "FASTA file: $fasta"
echo "Total number of sequences: $total_sequences"
echo "Total number of nucleotides: $total_nucleotides"
echo
echo "Sequence names and lengths:"
seqtk comp "$fasta" | awk '{print $1 "\t" $2}'


# Task 9: Loop
for file in data/*.fna; do
    ./summarize_fasta.sh "$file"
done

Purposes:
- used a wildcard to identify all FASTA files
- ran summarize_fasta.sh on each FASTA file

# Reflection
The beginning part of the assignment was pretty straightforward in terms of being almost exactly like what we had done in class when we were learning to write scripts the other day.
Then for tasks 7, 8, and 9, it got more complex in terms of us needing to figure out seqtk on our own and find more FASTA files. I downloaded three FASTA files from NCBI: Escherichia coli, Mycobacterium aichiense, and Mycolicibacterium smegmatis. 
I chose these genomes because they connect directly to my Phage Lab work. M. aichiense and M. smegmatis are the two bacterial hosts we use to culture soil samples in an effort to isolate and characterize unknown bacteriophages, while E. coli is another widely used bacterial model. 
One challenge I encountered was working with command-line programs that I had not used before and figuring out how the output from different seqtk commands could be used to answer the assignment questions. I initially tried to use an option with seqtk size that was not supported by the version installed on the HPC, which produced an error. I also had to troubleshoot file permissions when running my shell script and practiced using chmod +x to make the script executable. 
Through this process, I became more comfortable reading error messages, testing individual commands, and modifying a script based on the behavior of the tools available on the HPC rather than assuming that every option would work as expected.
I also learned more about FASTA files and how genomic sequence data can be explored from the command line. In particular, I practiced finding a program manual in the command line to learn the different command options and how they work. 
For example I used this process to figure out how seqtk size can be used to obtain the total number of sequences and nucleotides, while seqtk comp can provide sequence names and lengths. 
I then used variables, positional arguments, command substitution, awk, and a for loop to turn these commands into a reusable script that could summarize multiple FASTA files automatically. This was especially useful for me because I have not previously worked extensively with genomic or sequencing data.
Another important concept I learned was the purpose of the $PATH environment variable. $PATH is a list of directories that the shell searches when I enter a command without specifying its full path. 
For example, when I type seqtk, Bash searches the directories in $PATH until it finds the executable. This allows programs to be run by name rather than by typing their entire file location. 
Understanding $PATH also helped me understand why some programs can be called from anywhere on the HPC while scripts in my current directory need to be run with ./, unless their directory has been added to $PATH.
Overall, this assignment was a useful introduction to working with scripts and genomic data in a command-line environment. The connection to Phage Lab made the work particularly relevant: the second semester of Phage Lab will focus on annotating phage genomes after phages have been isolated and amplified during the first semester and sent for sequencing. 
Although I have not previously worked much with genomic or sequencing data, this assignment gave me an opportunity to begin developing the command-line and computational skills that I will need to work with those data.
