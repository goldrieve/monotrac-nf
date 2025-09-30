process LINE_PLOT {
    tag "Plotting depth"
    publishDir "${params.outdir}/plots/depth"

    input:
    path (raw_csv)

    output:
    path "depth.png"

    script:
    """
    lineplot.py 
    """
}