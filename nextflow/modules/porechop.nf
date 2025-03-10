process PORECHOP {
    conda "/opt/anaconda3/envs/medaka"
    publishDir "${params.outdir}/Trimmed"

    input:
    path (raw_reads)

    output:
    path "${raw_reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}.fq.gz"

    script:
    """
    porechop --format fastq.gz -i ${raw_reads} -o ${raw_reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}.fq.gz
    """
}