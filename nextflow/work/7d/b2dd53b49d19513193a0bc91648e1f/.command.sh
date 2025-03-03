#!/bin/bash -ue
cat /Volumes/Seagate/monotrac/nextflow/work/76/86b14db0f11b8dd605a18d66cadeee/ERR9695747_consensus/ERR9695747.fas > concatenated.fas
mafft --auto concatenated.fas > aligned.fas
