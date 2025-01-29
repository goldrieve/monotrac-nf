echo "Running pipeline"
 
for sample in /Volumes/Seagate/monotrack/Raw_Reads/*.fastq.gz
 
    do
    
    dir="/Volumes/Seagate/monotrack/Raw_Reads"
    base=$(basename "$sample" ".fastq.gz")

    echo "Performing FastQC on ${base}"
 
    # run FastQC
    #fastqc --mem 10000 --nano "${sample}" -o Fastqc

    # count the number of reads using the fasqc files 
    #unzip Fastqc/"${base}"_fastqc.zip -d Fastqc/Fastqc_unzip
    #echo "the number of reads in the file is"
    #grep "Total Sequences" Fastqc/Fastqc_unzip/"${base}"_fastqc/fastqc_data.txt
 
    #echo "Mapping ${base} reads to mono-trac targets"
    # map reads to monotrac targets
    #minimap2 -a -x map-ont References/targets_sequence.fasta "${sample}" | samtools view -Sb -F 4 > "Mapped/${base}.bam"

    # perform fastqc on the bam files and then use the subsequent qc files to count the number of aligned sequences 
    #fastqc --mem 10000 --nano Mapped/${base}.bam -o Fastqc/Fastqc_bam/
    #unzip Fastqc/Fastqc_bam/"${base}"_fastqc.zip -d Fastqc/Fastqc_bam/
    #echo "the number of aligned reads is"
    #grep "Total Sequences" Fastqc/Fastqc_bam/"${base}"_fastqc/fastqc_data.txt

    #samtools sort -o Mapped/Sorted_bam/${base}.sorted.bam Mapped/${base}.bam
    #samtools index Mapped/Sorted_bam/${base}.sorted.bam
    echo "performing mosdepth on ${base}"
    mosdepth Mapped/Mosdepth/${base} Mapped/Sorted_bam/${base}.sorted.bam
    
done