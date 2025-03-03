#!/bin/bash -ue
medaka_consensus -i barcode3.fq.gz -d targets.fasta -o barcode3_consensus
echo "Calling variant"
medaka variant targets.fasta barcode3_consensus/consensus_probs.hdf barcode3_consensus/medaka.vcf
medaka tools annotate --dpsp barcode3_consensus/medaka.vcf targets.fasta barcode3_consensus/calls_to_draft.bam barcode3_consensus/medaka.annotated.unfiltered.vcf 

bcftools reheader barcode3_consensus/medaka.annotated.unfiltered.vcf -s <(echo 'barcode3')     | bcftools filter         -e 'INFO/DP < 10'         -s LOW_DEPTH         -Oz -o barcode3_consensus/medaka.annotated.vcf.gz


bcftools index barcode3_consensus/medaka.annotated.vcf.gz
bcftools consensus -f targets.fasta barcode3_consensus/medaka.annotated.vcf.gz         -i 'FILTER="PASS"'         -o barcode3_consensus/medaka.consensus.fasta
