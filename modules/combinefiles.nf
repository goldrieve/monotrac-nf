process COMBINE_FILES {
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