// mosdepth module - calculates the depth of the reads 

process MOSDEPTH{
    tag "$sample"
    publishDir "${params.outdir}/Mosdepth"

    input:
    tuple val (sample), path (bam)

    output:
    tuple val (sample), path ("${sample}.mosdepth.global.dist.txt"), emit: global
    tuple val (sample), path ("${sample}.mosdepth.summary.txt"), emit: summary
    
    script:
    """
    mosdepth ${bam} ${bam}/calls_to_draft.bam
    """
}