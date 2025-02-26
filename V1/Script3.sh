echo "Performing QC on the raw read files ending in .gz"
 
for sample in /Users/archiehogan/Desktop/monotrack/Raw_Reads/*.fastq.gz
 
    do
    
    dir="/Users/archiehogan/Desktop/monotrack/Raw_Reads"
    base=$(basename "$sample" ".fastq.gz")
 
    echo "Performing FastQC on ${base}"
 
    # run FastQC
    fastqc --mem 10000 --nano "${sample}" -o Fastqc
 
    echo "Mapping ${base} reads to mono-trac targets"
 
    # map reads to monotrac targets
    minimap2 -a -x map-ont References/targets_sequence.fasta "${sample}" > "Mapped/${base}.sam"
 
done