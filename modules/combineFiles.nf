process COMBINEFILES {
    tag "$sample"
    publishDir "${params.outdir}/Plots"

    input:
    tuple val (sample), path (summary)

    output:
    path "combined_data.csv"

    script:
    """
    echo "Summary files: ${summary}" 
    python combineFiles.py ${summary.join(' ')}
    """
}