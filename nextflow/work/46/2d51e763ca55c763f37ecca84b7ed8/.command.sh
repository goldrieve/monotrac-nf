#!/bin/bash -ue
medaka_consensus -i barcode2 -d targets.fasta -o barcode2_consensus
echo "Calling variant"
medaka variant targets.fasta barcode2_consensus/consensus_probs.hdf barcode2_consensus/medaka.vcf
medaka tools annotate --dpsp barcode2_consensus/medaka.vcf targets.fasta barcode2_consensus/calls_to_draft.bam barcode2_consensus/medaka.annotated.unfiltered.vcf 

bcftools reheader barcode2_consensus/medaka.annotated.unfiltered.vcf -s <(echo 'barcode2')     | bcftools filter         -e 'INFO/DP < 10'         -s LOW_DEPTH         -Oz -o barcode2_consensus/medaka.annotated.vcf.gz


bcftools index barcode2_consensus/medaka.annotated.vcf.gz
bcftools consensus -f targets.fasta barcode2_consensus/medaka.annotated.vcf.gz         -i 'FILTER="PASS"'         -o barcode2_consensus/medaka.consensus.fasta
