 
process PLOTTING{
    tag "$sample"
    publishDir "${params.outdir}/plots/depth_plots"

    input:
    tuple val (sample), path (global)

    output:
    path "${sample}.mosdepth.global.dist.png"

    script:
    """
    depth_plots.py ${global}
    """
}