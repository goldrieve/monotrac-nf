 
process PLOTTING{
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