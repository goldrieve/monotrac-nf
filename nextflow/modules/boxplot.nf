process BOXPLOT{
    conda "/opt/anaconda3/envs/medaka"
    publishDir "${params.outdir}/Plots"

    input:
    path combined_csv

    output:
    path "plot_1.png"

    script:
    """
    python $projectDir/bin/boxplot.py 
    """
}