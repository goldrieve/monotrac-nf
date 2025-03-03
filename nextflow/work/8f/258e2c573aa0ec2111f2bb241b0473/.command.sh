#!/bin/bash -ue
cat barcode3.fas > concatenated.fas
mafft --auto concatenated.fas > aligned.fas
