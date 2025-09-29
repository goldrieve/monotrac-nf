process BOXPLOT{
    tag "Creating boxplot"
    publishDir "${params.outdir}/Plots"

    input:
    path (combined_csv)

    output:
    path "boxplot.png"

    script:
    """
    python boxplot.py 
    """
}