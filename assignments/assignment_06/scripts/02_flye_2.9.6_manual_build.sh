#!/bin/bash
set -ueo pipefail

cd /sciclone/home/cabare01/programs/
git clone https://github.com/fenderglass/Flye
cd Flye
make
