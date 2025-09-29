process BOXPLOT{
    tag "Creating boxplot"
    publishDir "${params.outdir}/plots/depth_plots"

    input:
    path (combined_csv)

    output:
    path "boxplot.png"

    script:
    """
    boxplot.py 
    """
}