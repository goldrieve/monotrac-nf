#!/bin/bash
source /opt/anaconda3/etc/profile.d/conda.sh

mkdir workdir
mkdir workdir/References
mkdir workdir/Fastqc
mkdir workdir/Fastqc/Fastq_unzip
mkdir workdir/Fastqc/Fastqc_fc
mkdir workdir/Raw_Reads
mkdir workdir/Mapped 
mkdir workdir/Mapped/Mapped_fastq
mkdir workdir/monotrac
mkdir workdir/isolate_fasta 
mkdir workdir/Consensus 
mkdir workdir/C.fasta
mkdir workdir/temp
mkdir workdir/Mosdepth 
mkdir workdir/Plots
mkdir workdir/Depth_plots

cp isolate_fasta/*.fas workdir/C.fasta

cd workdir

echo "Running pipeline"
 
for sample in /Volumes/Seagate/monotrack/fastq/*.fastq.gz
 
    do
    
    dir="/Volumes/Seagate/monotrack/fastq"
    base=$(basename "$sample" ".fastq.gz")

    conda activate monotrac
     #run FastQC
    echo "Performing FastQC on ${base}"
    fastqc --mem 10000 --nano "${sample}" -o Fastqc

     #count the number of reads using the fasqc files 
    unzip Fastqc/"${base}"_fastqc.zip -d Fastqc/Fastq_unzip
    echo "the number of reads in the file is"
    grep "Total Sequences" Fastqc/Fastq_unzip/"${base}"_fastqc/fastqc_data.txt
 
    echo "Mapping ${base} reads to mono-trac targets"
     #map reads to monotrac targets
    minimap2 -a -x map-ont ../monotrac/References/targets_sequence.fasta "${sample}" | samtools view -Sb -F 4 | samtools fastq - | gzip > Mapped/Mapped_fastq/${base}.fastq.gz

     #perform fastqc on the fastq files and then use the subsequent qc files to count the number of aligned sequences 
    echo "Performing fastqc on the aligned reads of ${base}"
    fastqc --mem 10000 --nano Mapped/Mapped_fastq/${base}.fastq.gz -o Fastqc/Fastqc_fc/
    unzip Fastqc/Fastqc_fc/"${base}"_fastqc.zip -d Fastqc/Fastqc_fc/
    echo "the number of aligned reads is"
    grep "Total Sequences" Fastqc/Fastqc_fc/"${base}"_fastqc/fastqc_data.txt

    conda activate medaka

     #Generating consensus sequences for the raw reads
    echo "Generating a consensus sequence for ${base}"
    medaka_consensus -i Mapped/Mapped_fastq/${base}.fastq.gz -d ../monotrac/References/targets.fasta -o Consensus/${base}
    echo "Calling variant in ${base}"
    medaka variant ../monotrac/References/targets.fasta Consensus/${base}/consensus_probs.hdf Consensus/${base}/medaka.vcf
    cp Consensus/${base}/consensus.fasta C.fasta/${base}.fas

    conda activate monotrac

    echo "Calculating the depth of reads for ${base}"
    mosdepth Mosdepth/${base} Consensus/${base}/calls_to_draft.bam

    
     #This plots coverage for each gene on seperate line plots for each isolate. It uses facet grid to create figures for each isolate
    /opt/anaconda3/envs/medaka/bin/python ../monotrac/depth_plots.py Mosdepth/${base}.mosdepth.global.dist.txt

done

 #Python script to plot the boxplot of average coverage across all genes and to plot average coverage for each gene across all isolates
/opt/anaconda3/envs/medaka/bin/python ../monotrac/plotting.py

 #Concatenates the fasta files together, so that the genes are all in the same order and the drug resistance gene is removed for better alignment
/opt/anaconda3/envs/medaka/bin/python ../monotrac/concatenate_2.py

conda activate mafft

 #mafft aligns the genes of each isolate agaisnt one another  
mafft --auto reordered_fastas/concatenated_sequences.fasta > reordered_fastas/aligned_genomes.fasta

 #This plots a phylogenetic tree from the aligned fasta sequence genreated by mafft 
FastTree -nt -gtr -gamma reordered_fastas/aligned_genomes.fasta > Plots/tree11.nwk

