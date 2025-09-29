process COMBINEFILES {
    tag "$sample"

    input:
    tuple val (sample), path (summary)

    output:
    path "combined_data.csv"

    script:
    """
    combineFiles.py ${summary.join(' ')}
    """
}