process RAWCOMBINE {
    tag "Combining mosdepth results"

    input:
    tuple val (sample), path (raw)

    output:
    path "combined_raw.csv"

    script:
    """
    rawCombine.py ${raw.join(' ')}
    """
}