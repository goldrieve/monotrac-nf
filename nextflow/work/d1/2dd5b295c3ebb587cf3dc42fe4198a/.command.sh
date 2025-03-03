#!/bin/bash -ue
cat ERR9695747.fas > concatenated.fas
mafft --auto concatenated.fas > aligned.fas
