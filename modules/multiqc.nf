process MULTIQC { 
    publishDir "${params.outdir}/MultiQC"

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