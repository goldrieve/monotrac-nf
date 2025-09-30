process MULTIQC {
    tag "Running multiQC"
    publishDir "${params.outdir}/multiqc"

    input:
    path (fastqc)
    path (mosdepth_global) 

    output:
    path "multiqc_report.html"

    script:
    """
    multiqc ${fastqc} ${mosdepth_global} 
    """
}