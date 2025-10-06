process MOSDEPTH{
    tag "$sample"
    publishDir "${params.outdir}/mosdepth"

    input:
    tuple val (sample), path (index), path (bam)

    output:
    path ("${sample}.mosdepth.global.dist.txt"), emit: global
    tuple val (sample), path ("${sample}.mosdepth.global.dist.txt"), emit: sample_global
    path ("${sample}.mosdepth.summary.txt"), emit: summary
    
    script:
    """
    mosdepth ${sample} ${bam}
    """
}