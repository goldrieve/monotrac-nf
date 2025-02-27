#!/bin/bash -ue
minimap2 -a -x map-ont targets_sequence.fasta early_1_2.fq.gz | samtools view -Sb -F 4 | samtools fastq - | gzip > early_1_2.fq.gz.bam
