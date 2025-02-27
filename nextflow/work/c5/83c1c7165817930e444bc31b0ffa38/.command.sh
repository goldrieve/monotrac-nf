#!/bin/bash -ue
echo "Generating a consensus sequence for early_1_1.fq.gz"
medaka_consensus -i early_1_1.fq.gz -d targets.fasta -o early_1_1.fq.gz
