process LINEPLOT {
    tag "Plotting depth"
    publishDir "${params.outdir}/Plots"

    input:
    path (raw_csv)

    output:
    path "depth.png"

    script:
    """
    python lineplot.py 
    """
}