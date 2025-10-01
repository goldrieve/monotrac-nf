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
    base=\$(basename "$reads" | cut -f1 -d.)
    mv \${base}_fastqc.html ${sample}_fastqc.html
    mv \${base}_fastqc.zip ${sample}_fastqc.zip
    """
}