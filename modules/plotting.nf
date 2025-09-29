 
process PLOTTING{
    tag "$sample"
    publishDir "${params.outdir}/Plots/Depth_plots"

    input:
    tuple val (sample), path (global)

    output:
    path "${sample}.png"

    script:
    """
    python depth_plots.py ${global}
    """
}