process MINIMAP{
    conda "/opt/anaconda3/envs/monotrac"
    publishDir "${params.outdir}/Mapped"
    
    input:
    path reads
    path reference

    output:
    path "${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}.fastq.gz"

    script:
    """
    minimap2 -a -x map-ont ${reference} ${reads} | samtools view -Sb -F 4 | samtools fastq - | gzip > ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}.fastq.gz
    """
}
