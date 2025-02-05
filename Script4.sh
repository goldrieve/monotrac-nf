#!/bin/bash
conda activate archie 

mkdir workdir
mkdir workdir/References
mkdir workdir/Fastqc
mkdir workdir/Fastqc/Fastq_unzip
mkdir workdir/Fastqc/Fastqc_fc
mkdir workdir/Raw_Reads
mkdir workdir/Mapped 
mkdir workdir/Mapped/Mapped_fastq
#mkdir workdir/Mapped/Sorted_bam # potentially do not need 
#mkdir workdir/Mapped/Mosdepth # potentially do not need 
mkdir workdir/monotrac
mkdir workdir/isolate_fasta 
mkdir workdir/Consensus 
mkdir workdir/C.fasta
mkdir workdir/temp
mkdir workdir/Mosdepth 
mkdir workdir/Plots
cd workdir

echo "Running pipeline"
 
for sample in /Volumes/Seagate/monotrack/workdir/Raw_Reads/*.fastq.gz
 
    do
    
    dir="/Volumes/Seagate/monotrack/workdir/Raw_Reads"
    base=$(basename "$sample" ".fastq.gz")


    # run FastQC
    echo "Performing FastQC on ${base}"
    fastqc --mem 10000 --nano "${sample}" -o Fastqc

    # count the number of reads using the fasqc files 
    unzip Fastqc/"${base}"_fastqc.zip -d Fastqc/Fastq_unzip
    #echo "the number of reads in the file is"
    grep "Total Sequences" Fastqc/Fastq_unzip/"${base}"_fastqc/fastqc_data.txt
 
    echo "Mapping ${base} reads to mono-trac targets"
    # map reads to monotrac targets
    minimap2 -a -x map-ont References/targets_sequence.fasta "${sample}" | samtools view -Sb -F 4 | samtools fastq - | gzip > Mapped/Mapped_fastq/${base}.fastq.gz

    # perform fastqc on the fastq files and then use the subsequent qc files to count the number of aligned sequences 
    echo "Performing fastqc on the aligned reads of ${base}"
    fastqc --mem 10000 --nano Mapped/Mapped_fastq/${base}.fastq.gz -o Fastqc/Fastqc_fc/
    unzip Fastqc/Fastqc_fc/"${base}"_fastqc.zip -d Fastqc/Fastqc_fc/
    echo "the number of aligned reads is"
    grep "Total Sequences" Fastqc/Fastqc_fc/"${base}"_fastqc/fastqc_data.txt

    # Generating consensus sequences for the raw reads
    echo "Generating a consensus sequence for ${base}"
    medaka_consensus -i Mapped/Mapped_fastq/${base}.fastq.gz -d References/targets_sequence2.fasta -o Consensus/${base}
    echo "Calling variant in ${base}"
    medaka variant References/targets_sequence2.fasta Consensus/${base}/consensus_probs.hdf Consensus/${base}/medaka.vcf
    cp Consensus/${base}/consensus.fasta C.fasta/${base}.fas

    echo "Calculating the depth of reads for ${base}"
    mosdepth Mosdepth/${base} Consensus/${base}/calls_to_draft.bam

    # create a new directory called temp, copy all fasta files from isolat_fasta and c.fasta into 
    # create fasta files for each gene that contains all the different isolate genes specifc (switch it)
    # align all of the different sequences - using mafft
    # create a phylogenetic tree using fasttree 

    #cp C.fasta/${base}.fas temp/${base}.fas
    #cp isolate_fasta/*.fas temp/

    # mafft is in its own conda env named mafft

    #cat temp/*.fas > combined.fas 

done

/opt/anaconda3/envs/medaka/bin/python Plots/plotting.py
