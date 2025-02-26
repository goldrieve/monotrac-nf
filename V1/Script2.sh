#!/bin/bash

#Aim of this script is to perform the same task as 'script.sh' but for all .gz files in the Raw_Reads directory

echo "Performinng qc on the raw read files ending in .gz"

for sample in ls /Users/archiehogan/Desktop/monotrack/Raw_Reads/*.fastq.gz
do
dir="/Users/archiehogan/Desktop/monotrack/Raw_Reads"
base=$(basename $sample "*.fastq.gz") 
fastqc ${dir}/${base} -o ../Fastqc 
#code above performs fastqc on all .gz files in the raw reads dirctory and saves the output to the Fastqc directory


minimap2 -x map-ont ../References/targets.fasta ${dir}/${base}.fastq.gz > ../Mapped/${base}.sam
done 