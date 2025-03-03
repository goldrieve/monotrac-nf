#!/bin/bash -ue
cat barcode2.fas ERR9695747.fas barcode3.fas > concatenated.fas
mafft --auto concatenated.fas > aligned.fas
