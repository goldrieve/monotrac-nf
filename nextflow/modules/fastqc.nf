process FASTQC {
    conda "/opt/anaconda3/envs/monotrac"
    publishDir "${params.outdir}/Fastqc"
    
    input:
    path reads

    output:
    path "${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_fastqc.html"
    path "${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_fastqc.zip", emit: zip

    script:
    """
    fastqc --mem 10000 --nano ${reads}
    """
}