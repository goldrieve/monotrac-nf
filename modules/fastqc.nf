process FASTQC {
    tag "$sample"
    publishDir "${params.outdir}/fastqc"
    
    input:
    tuple val (sample), path (reads)

    output:
    path ("${sample}_fastqc.html")
    path ("${sample}_fastqc"), emit: dir
    path ("${sample}_fastqc/summary.txt"), emit: stats

    script:
    """
    fastqc --mem 10000 --nano $reads
    base=\$(basename "$reads" | cut -f1 -d.)
    mv \${base}_fastqc.html ${sample}_fastqc.html
    unzip \${base}_fastqc.zip
    mv \${base}_fastqc ${sample}_fastqc
    """
}