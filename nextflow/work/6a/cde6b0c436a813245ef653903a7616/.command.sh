#!/bin/bash -ue
mkdir -p reordered_fastas
python /Volumes/Seagate/monotrac/nextflow/bin/concatenate.py barcode3.fas barcode2.fas ERR9695747.fas MCAM-ET-2013-MU-17.fas reordered_fastas
mafft --auto reordered_fastas/concatenated_sequences.fasta > aligned.fas
