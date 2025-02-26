# script to download all the sra files from ncbi, gzip, then align them to reference genes 


for sample in $(cat Raw_Reads/SraAccList.csv)
    do
    echo "downloading $sample"
    fasterq-dump $sample -e 4 -O ./SRA_Reads
    gzip SRA_Reads/${sample}.fastq 
    #minimap2 -a -x map-ont References/targets_sequence.fasta "${sample}" | samtools view -Sb -F 4 | samtools fastq | gzip > SRA_Reads/${sample}.fastq.gz


done