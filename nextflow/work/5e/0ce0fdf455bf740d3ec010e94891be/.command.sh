#!/bin/bash -ue
echo "Calling variant"
medaka variant targets.fasta early_1_2_consensus/consensus_probs.hdf VCF/early_1_2_consensus_medaka.vcf
