#!/bin/bash -ue
echo "Summary files: barcode3_consensus.mosdepth.summary.txt ERR9695747_consensus.mosdepth.summary.txt barcode2_consensus.mosdepth.summary.txt" 
python /Volumes/Seagate/monotrac/nextflow/bin/combineFiles.py barcode3_consensus.mosdepth.summary.txt ERR9695747_consensus.mosdepth.summary.txt barcode2_consensus.mosdepth.summary.txt
