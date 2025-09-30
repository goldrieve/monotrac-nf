 process PLOTTING{
    tag "Generating depth plots"
    publishDir "${params.outdir}/plots/depth_plots/*png"

    input:
    tuple val (sample), path (global)
    path (summary)

    output:
    path "${sample}.mosdepth.global.dist.png"
    path "combined_data.csv"
    path "boxplot.png"
    path "combined_raw.csv"
    path "depth_line.png"

    script:
    """
    depth_plots.py ${global}
    combineFiles.py ${summary.join(' ')}
    boxplot.py
    rawCombine.py ${global.join(' ')}
    lineplot.py 
    """
}