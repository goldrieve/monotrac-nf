#!/bin/bash -ue
base=$(basename early_1_1.fq.gz .fastq.gz)

echo "Generating a consensus sequence for ${base}"
medaka_consensus -i early_1_1.fq.gz -d targets.fasta -o Consensus/${base}

echo "Calling variant in ${base}"
medaka variant targets.fasta Consensus/${base}/consensus_probs.hdf Consensus/${base}/medaka.vcf

mkdir -p C.fasta
cp Consensus/${base}/consensus.fasta C.fasta/${base}.fas
