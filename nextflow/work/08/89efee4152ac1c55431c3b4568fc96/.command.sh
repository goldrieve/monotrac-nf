#!/bin/bash -ue
echo "Calling variant"
medaka variant targets.fasta early_1_1_consensus/consensus_probs.hdf medaka.vcf
