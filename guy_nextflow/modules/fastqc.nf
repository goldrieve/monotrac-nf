process FASTQC {
    conda "/usr/local/anaconda3/envs/fastqc"
    publishDir "${params.outdir}"
    
    input:
    path reads

    output:
    path "${reads[0].baseName.replaceAll(/\.fq(\.gz)?$/, "")}_fastqc.html"

    script:
    """
    fastqc ${reads}
    """
}