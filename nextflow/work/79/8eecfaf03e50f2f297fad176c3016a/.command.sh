#!/bin/bash -ue
cat [/Volumes/Seagate/monotrac/nextflow/work/76/86b14db0f11b8dd605a18d66cadeee/ERR9695747_consensus/ERR9695747.fas, /Volumes/Seagate/monotrac/nextflow/work/9d/9f2a03c2fce3643c6f9517583610c4/barcode2_consensus/barcode2.fas, /Volumes/Seagate/monotrac/nextflow/work/d5/e12079b04ca6989713cf1493d4e5d1/barcode3_consensus/barcode3.fas] > concatenated.fas
mafft --auto concatenated.fas > aligned.fas
