process MULTIQC { 
    conda "/opt/anaconda3/envs/mafft"
    publishDir "${params.outdir}/MultiQC"

    input:
    path (kraken)
    path (fastqc)
    path (mosdepth_global) 

    output:
    path "multiqc_report.html"

    script:
    """
    multiqc ${kraken} ${fastqc} ${mosdepth_global} 
    """
}