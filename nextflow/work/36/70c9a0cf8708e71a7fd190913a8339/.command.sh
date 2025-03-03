#!/bin/bash -ue
python /Volumes/Seagate/monotrac/nextflow/bin/concatenate.py 
cp  reordered_fastas/
cat reordered_fastas/*.fas > all_sequences.fasta
mafft --auto all_sequences.fasta > aligned.fas
