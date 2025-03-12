#!/bin/bash

echo "converting nucleotide sequences to amino acid sequences"

for sample in ./*.fas

    do 
    base=$(basename "$sample" ".fas")

    transeq -sequence ${sample} -outseq protein/${sample}

done
