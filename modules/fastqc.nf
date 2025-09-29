process FASTQC {
    tag "$sample"
    publishDir "${params.outdir}/fastqc"
    
    input:
    tuple val (sample), path (reads)

    output:
    tuple val (sample), path ("${sample}_fastqc.html")
    tuple val (sample), path ("${sample}_fastqc.zip"), emit: zip

    script:
    """
    fastqc --mem 10000 --nano $reads
    """
}