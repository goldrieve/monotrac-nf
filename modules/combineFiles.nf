process COMBINEFILES { 
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