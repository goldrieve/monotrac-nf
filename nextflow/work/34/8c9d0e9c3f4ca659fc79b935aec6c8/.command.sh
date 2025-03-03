#!/bin/bash -ue
mkdir -p reordered_fastas
python /Volumes/Seagate/monotrac/nextflow/bin/concatenate.py barcode3.fas barcode2.fas ERR9695747.fas AGAL-CI-78-TCH312.fas reordered_fastas
mafft --auto reordered_fastas/concatenated_sequences.fasta > aligned.fas
