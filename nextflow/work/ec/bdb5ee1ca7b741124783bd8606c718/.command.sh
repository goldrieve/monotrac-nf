#!/bin/bash -ue
echo "Generating a consensus sequence for ${reads}"
medaka_consensus -i early_1_1.fq.gz -d targets.fasta -o Consensus/${reads}
