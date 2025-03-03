process BOXPLOT{
    conda "/opt/anaconda3/envs/medaka"
    publishDir "${params.outdir}/Plots"

    input:
    path summary

    output:
    path "plot_1.png"

    script:
    """
    python $projectDir/bin/boxplot.py ${summary}
    """
}