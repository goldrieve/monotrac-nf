#!/bin/bash -ue
cat barcode2.fas > concatenated.fas
mafft --auto concatenated.fas > aligned.fas
