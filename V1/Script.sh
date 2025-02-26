#!/bin/bash
 fasterq-dump SRR24029999 -O ../Raw_Reads/ -o SRR24029999.fastq
 #download raw read into Raw_Read directory 

 gzip ../Raw_Reads/SRR24029999.fastq
 #gzip the file 

fastqc ../Raw_Reads/SRR24029999.fastq.gz -o ../Fastqc
#perform fastqc on the raw read file and save to the Fastqc directory 

 

minimap2 -x map-ont ../References/targets.fasta ../Raw_Reads/SRR24029999.fastq.gz > ../Mapped/SRR24029999.sam 	
#Align the raw read agaisnt the reference data
#Output this to the mapped directory in sam file. 
