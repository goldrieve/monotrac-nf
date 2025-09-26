// mosdepth module - calculates the depth of the reads 

process MOSDEPTH{ 
    publishDir "${params.outdir}/Mosdepth"

    input:
    path bam

    output:
    path "${bam.baseName.replaceAll(/\.fq(\.gz)?$/, "")}.mosdepth.global.dist.txt", emit: global
    path "${bam.baseName.replaceAll(/\.fq(\.gz)?$/, "")}.mosdepth.summary.txt", emit: summary
    
    script:
    """
    mosdepth ${bam} ${bam}/calls_to_draft.bam
    """
}