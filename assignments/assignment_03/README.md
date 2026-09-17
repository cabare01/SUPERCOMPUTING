
#Assignment 3
#Catherine Bare
#9/15/26

#Assignment Log
bora
*enter password*
cd SUPERCOMPUTING/assignments/assignment_03
cd data
wget https://gzahn.github.io/data/GCF_000001735.4_TAIR10.1_genomic.fna.gz
gunzip GCF_000001735.4_TAIR10.1_genomic.fna.gz
ll (to confirm fasta file presence in right format)

grep '^>' GCF_000001735.4_TAIR10.1_genomic.fna | wc -l 		#7
grep -v '^>' GCF_000001735.4_TAIR10.1_genomic.fna | tr -d '\n' | wc -c   	#119,668,634
wc -l GCF_000001735.4_TAIR10.1_genomic.fna   	#14
grep '^>' GCF_000001735.4_TAIR10.1_genomic.fna | grep 'mitochondrion' | wc -l   	#1
grep '^>' GCF_000001735.4_TAIR10.1_genomic.fna | grep 'chromosome' | wc -l   	#5
head -n 6 GCF_000001735.4_TAIR10.1_genomic.fna
head -n 2 GCF_000001735.4_TAIR10.1_genomic.fna | grep -v '^>' | wc -c   	#30,427,672
head -n 4 GCF_000001735.4_TAIR10.1_genomic.fna | grep -v '^>' | tail -n 1 | wc -c   	#19,698,290
head -n 6 GCF_000001735.4_TAIR10.1_genomic.fna | grep -v '^>' | tail -n 1 | wc -c  	#23,459,831
grep -n '^>' GCF_000001735.4_TAIR10.1_genomic.fna
head -n 10 GCF_000001735.4_TAIR10.1_genomic.fna
head -n 10 GCF_000001735.4_TAIR10.1_genomic.fna | grep -v '^>' | tail -n 1 | tr -d '\n' | wc -c
head -n 10 GCF_000001735.4_TAIR10.1_genomic.fna | grep '^>'
head -n 9 GCF_000001735.4_TAIR10.1_genomic.fna | tail -n 2
head -n 10 GCF_000001735.4_TAIR10.1_genomic.fna | tail -n 1 | wc -c
grep -n 'chromosome 5' GCF_000001735.4_TAIR10.1_genomic.fna
head -n 10 GCF_000001735.4_TAIR10.1_genomic.fna | tail -n 1 | tr -d '\n' | wc -c   	#26,975,503
grep 'AAAAAAAAAAAAAAAA' GCF_000001735.4_TAIR10.1_genomic.fna | grep -v '^>' | wc -l   	#1
grep '^>' GCF_000001735.4_TAIR10.1_genomic.fna
grep '^>' GCF_000001735.4_TAIR10.1_genomic.fna | sort
grep '^>' GCF_000001735.4_TAIR10.1_genomic.fna | sort | head -n 1   	#NC_000932.1 Arabidopsis thaliana chloroplast, complete genome
paste -	- < GCF_000001735.4_TAIR10.1_genomic.fna > GCF_000001735.4_TAIR10.1_genomic.tsv
head GCF_000001735.4_TAIR10.1_genomic.tsv
cd ..
nano README.md

#Assignment Reflection
I tried to do this homework assignment mostly from my memory of simple commands and what we had learned in class to evaluate how much I had taken in and was comfortable working with to direct my practice for the quiz and for operating the HPC in general. 
It was a pretty successful effort for the majority because most of the pipeline building was simple chains of 2-3 commands only, pretty much all of which we had worked with before.
However, while working on Question 7, I initially encountered an off-by-one discrepancy when determining the number of nucleotides in chromosome 5. 
I obtained 26,975,502 in my first approach, while the expected answer was 26,975,503. I figured since such a large number was only off by one, it was not necessarily a computational error in terms of how I was evaluating the quantity or what command I was using, but had to do with back-end processing.  
I realized that the discrepancy came from how the newline character at the end of the sequence was being handled. 
This helped me recognize the importance of distinguishing between characters used to format a text file and the biological sequence itself. 
In this case, the newline is part of the file representation but is not a nucleotide. 
Resolving this small discrepancy reinforced the importance of understanding exactly what a command is counting rather than assuming that a numerical output directly represents the biological quantity I am interested in.
Developing the habit of investigating unexpected results, understanding exactly what a command is measuring, and documenting commands for reproducibility will be important skills for computational research.
These skills are also essential because they support automation and scalability in computational research, not just our classroom projects. 
Seeing the large genome datasets we are working with in these assignments reminds me of the huge files of event detection datasets I work on in my research.
With a couple thousand cells per embryo and approximately 180 embryos in just one of my projects, manually processing or checking these data is neither practical nor scalable.
Once I understand how to navigate files, manipulate data, and use command-line tools, I can combine commands into scripts that perform my repetitive analytical tasks automatically rather than processing each file manually.
