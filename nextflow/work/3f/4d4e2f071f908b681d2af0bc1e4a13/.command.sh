#!/bin/bash -ue
medaka_consensus -i ERR9695747.fq.gz -d targets.fasta -o ERR9695747_consensus
echo "Calling variant"
medaka variant targets.fasta ERR9695747_consensus/consensus_probs.hdf ERR9695747_consensus/medaka.vcf
medaka tools annotate --dpsp ERR9695747_consensus/medaka.vcf targets.fasta ERR9695747_consensus/calls_to_draft.bam ERR9695747_consensus/medaka.annotated.unfiltered.vcf 

bcftools reheader ERR9695747_consensus/medaka.annotated.unfiltered.vcf -s <(echo 'ERR9695747')     | bcftools filter         -e 'INFO/DP < 10'         -s LOW_DEPTH         -Oz -o ERR9695747_consensus/medaka.annotated.vcf.gz


bcftools index ERR9695747_consensus/medaka.annotated.vcf.gz
bcftools consensus -f targets.fasta ERR9695747_consensus/medaka.annotated.vcf.gz         -i 'FILTER="PASS"'         -o ERR9695747_consensus/ERR9695747.fas
