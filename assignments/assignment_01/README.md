# Commands for Project Structure
These commands are run starting from the root directory of the course repository. First the directory folders were created (mk dir), each with an empty placeholder file (touch).
cd assignments
cd assignment_01
mkdir data
cd data
mk dir raw
mk dir clean
cd ..
mk dir scripts
mk dir results
mk dir docs
mk dir config
mk dir logs
touch data/raw/example.txt
touch data/clean/example.txt
touch scripts/example.sh
touch results/example.txt
touch docs/example.md
touch config/example.conf
touch logs/example.log
touch assignment_01_essay.md
nano assignment_01_essay.md
nano README.md

cd ..
git add assignment_01
git commit -m "Assignment 1: Project structure and class foundations"
git push
