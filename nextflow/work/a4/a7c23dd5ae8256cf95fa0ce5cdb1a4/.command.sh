#!/bin/bash -ue
medaka_consensus -i barcode1.fq.gz -d targets.fasta -o barcode1_consensus
echo "Calling variant"
medaka variant targets.fasta barcode1_consensus/consensus_probs.hdf barcode1_consensus/medaka.vcf
medaka tools annotate --dpsp barcode1_consensus/medaka.vcf targets.fasta barcode1_consensus/calls_to_draft.bam barcode1_consensus/medaka.annotated.unfiltered.vcf 

bcftools reheader barcode1_consensus/medaka.annotated.unfiltered.vcf -s <(echo 'barcode1')     | bcftools filter         -e 'INFO/DP < 10'         -s LOW_DEPTH         -Oz -o barcode1_consensus/medaka.annotated.vcf.gz


bcftools index barcode1_consensus/medaka.annotated.vcf.gz
bcftools consensus -f targets.fasta barcode1_consensus/medaka.annotated.vcf.gz         -i 'FILTER="PASS"'         -o barcode1_consensus/medaka.consensus.fasta
