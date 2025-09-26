process LINEPLOT {
    publishDir "${params.outdir}/Plots"

    input:
    path raw_csv

    output:
    path "plot_2.png"

    script:
    """
    python $projectDir/bin/lineplot.py 
    """
}