process RAWCOMBINE {
    tag "Combining mosdepth results"

    input:
    path (raw)

    output:
    path "combined_raw.csv"

    script:
    """
    rawCombine.py ${raw.join(' ')}
    """
}