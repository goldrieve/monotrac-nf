#!/bin/bash -ue
cat /Volumes/Seagate/monotrac/nextflow/work/d5/e12079b04ca6989713cf1493d4e5d1/barcode3_consensus/barcode3.fas > concatenated.fas
mafft --auto concatenated.fas > aligned.fas
