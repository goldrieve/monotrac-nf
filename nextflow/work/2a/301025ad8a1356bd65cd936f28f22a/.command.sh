#!/bin/bash -ue
python /Volumes/Seagate/monotrac/nextflow/bin/concatenate.py 
mafft --auto reordered_fastas/concatenated_sequences.fasta > aligned.fas
