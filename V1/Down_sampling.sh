# down sampling the raw read files from ncbi to the aligned target reads 
#!/bin/bash


for raw_read in /Volumes/Seagate/monotrack/SRA_Reads/*.fastq.gz

    do 
    base=$(basename "$raw_read" ".fastq.gz")

    echo "downsampling ${base}"

    minimap2 -a -x map-ont workdir/References/targets_sequence.fasta "${raw_read}" | samtools view -Sb -F 4 | samtools fastq - | gzip > Down_sampled/${base}.fastq.gz

done