#!/bin/bash -ue
echo "Generating a consensus sequence for ${base}"
medaka_consensus -i early_1_1.fq.gz -d targets.fasta -o Consensus/${reads}

echo "Calling variant in ${base}"
medaka variant targets.fasta Consensus/${reads}/consensus_probs.hdf Consensus/${reads}/medaka.vcf
