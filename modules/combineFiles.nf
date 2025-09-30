process COMBINEFILES {
    tag "Combining files"

    input:
    path (summary)

    output:
    path "combined_data.csv"

    script:
    """
    combineFiles.py ${summary.join(' ')}
    """
}