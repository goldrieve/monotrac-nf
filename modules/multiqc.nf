process MULTIQC {
    tag "Running multiQC"
    publishDir "${params.outdir}/multiqc"

    input:
    tuple val (sample), path (fastqc)
    tuple val (samples), path (mosdepth_global) 

    output:
    path "multiqc_report.html"

    script:
    """
    multiqc ${fastqc} ${mosdepth_global} 
    """
}