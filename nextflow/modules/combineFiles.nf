process COMBINEFILES { 
    conda "/opt/anaconda3/envs/medaka"
    publishDir "${params.outdir}/Plots"

    input:
    path summary

    output:
    path "combined_data.csv"

    script:
    """
    echo "Summary files: ${summary}" 
    python $projectDir/bin/combineFiles.py ${summary.join(' ')}
    """
}