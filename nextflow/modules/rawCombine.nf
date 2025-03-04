process RAWCOMBINE { 
    conda "/opt/anaconda3/envs/medaka"
    publishDir "${params.outdir}/Plots"

    input:
    path raw

    output:
    path "combined_raw.csv"

    script:
    """
    python $projectDir/bin/rawCombine.py ${raw.join(' ')}
    """
}