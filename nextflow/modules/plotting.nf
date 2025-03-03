 
process PLOTTING{
    conda "/opt/anaconda3/envs/medaka"
    publishDir "${params.outdir}/Plots/Depth_plots"

    input:
    path global

    output:
    path "${global.baseName.replaceAll(/\.mosdepth\.global\.dist\.txt$/, '')}.png"

    script:
    """
    python $projectDir/bin/depth_plots.py ${global}
    """
}