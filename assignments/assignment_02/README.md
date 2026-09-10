#Assignment 2
#Catherine Bare
#September 8, 2026


#Notes
I ran into some major problems during the second task as the 'ftp' commands were just not working for me and at first I kept getting timed out of the connection before I could get to the right directory. 
I finally understood the Windows command-line FTP client could connect to NCBI and navigate the directory but could not establish the required FTP data connection for the file transfer.
I resolved this by using curl with passive FTP mode, which I know was not exactly the right pipeline but successfully downloaded both required files.
The SFTP transfer and permission changes on the HPC then worked as expected, and the matching MD5 hashes confirmed that the files were transferred without corruption.
Although parts of the assignment were frustrating and very out of my comfort zone trying to understand each new message returned, especially with my problems in the NCBI system, I can tell I have gotten super comfortable with the basic navigation commands with all the repetition which is a great bonus.

#Command History
Directory Structure
1. Local machine: ~/SUPERCOMPUTING/assignments/assignment_02/
The two NCBI files were downloaded into this directory.

2. HPC: ~/SUPERCOMPUTING/assignments/assignment_02/data/
The final HPC directory contains:
GCF_000005845.2_ASM584v2_genomic.fna.gz
GCF_000005845.2_ASM584v2_genomic.gff.gz
README.md

HPC Connection: VPN portal
gp.wm.edu
bora
cd ~/SUPERCOMPUTING/assignments/assignment_02/data/
- to verify the directory exists
cd ..
ftp.ncbi.nlm.nih.gov
- log in anonymously
genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/
get GCF_000005845.2_ASM584v2_genomic.fna.gz
get GCF_000005845.2_ASM584v2_genomic.gff.gz
- This is where I got stopped so many times so I did some digging and decided to switch up some of my commands.
ftp.ncbi.nlm.nih.gov
- log in anonymously
passive
binary
cd genomes
cd all
cd GCF
cd 000
cd 005
cd 845
cd GCF_000005845.2_ASM584v2
ls
get GCF_000005845.2_ASM584v2_genomic.fna.gz
get GCF_000005845.2_ASM584v2_genomic.gff.gz
- STILL not working, so tried something else:
ftp -a ftp.ncbi.nlm.nih.gov
binary
cd genomes 
cd all 
cd GCF 
cd 000 
cd 005 
cd 845 
cd GCF_000005845.2_ASM584v2
ls
- This is where the error messages above came in because the Windows FTP client returned: 425 Unable to build data connection: Connection refused. Attempting the transfer with get also failed because the FTP data connection could not be established.
- A second FTP attempt using: ftp -a ftp.ncbi.nlm.nih.gov and the same directory navigation resulted in: 501 Illegal PORT command
- From there, I decided to go in a different direction then and exited NCBI: 
curl -O --ftp-pasv ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz
curl -O --ftp-pasv ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.gff.gz
ls -lh
- verify files downloaded: 
md5sum GCF_000005845.2_ASM584v2_genomic.fna.gz
md5sum GCF_000005845.2_ASM584v2_genomic.gff.gz
- Results:
c13d459b5caa702ff7e1f26fe44b8ad7  GCF_000005845.2_ASM584v2_genomic.fna.gz
0f52ffc94af5ddf544ff89cc6f546b0c  GCF_000005845.2_ASM584v2_genomic.gff.gz
- file transfer was accomplished via WinSCP
- same verification was repeated in the HPC (accessed via 'bora')
md5sum GCF_000005845.2_ASM584v2_genomic.fna.gz
md5sum GCF_000005845.2_ASM584v2_genomic.gff.gz
Results:
c13d459b5caa702ff7e1f26fe44b8ad7  GCF_000005845.2_ASM584v2_genomic.fna.gz
0f52ffc94af5ddf544ff89cc6f546b0c  GCF_000005845.2_ASM584v2_genomic.gff.gz
- hashes match exactly, confirms the files were transferred exactly without changing contents
nano ~/.bashrc
alias u='cd ..;clear;pwd;ls -alFh --group-directories-first' 
alias d='cd -;clear;pwd;ls -alFh --group-directories-first' 
alias ll='ls -alFh --group-directories-first'
- replaced my aliases from Thursday class with these more in-depth definitions
source ~/.bashrc
alias u 
alias d 
alias ll
- testing aliases, which returned exactly their correct description
Changes were added, committed, and pushed to my repository.
