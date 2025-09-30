process FASTQC {
    tag "$sample"
    publishDir "${params.outdir}/fastqc"
    
    input:
    tuple val (sample), path (reads)

    output:
    path ("${sample}_fastqc.html")
    path ("${sample}_fastqc.zip"), emit: zip

    script:
    """
    fastqc --mem 10000 --nano $reads
    """
}