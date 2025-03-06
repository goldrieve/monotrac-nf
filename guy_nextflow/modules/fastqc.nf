process FASTQC {
    conda "/opt/anaconda3/envs/monotrac"
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