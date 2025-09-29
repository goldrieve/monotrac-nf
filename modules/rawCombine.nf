process RAWCOMBINE {
    tag "Combining mosdepth results"
    publishDir "${params.outdir}/Plots"

    input:
    path (raw)

    output:
    path "combined_raw.csv"

    script:
    """
    python rawCombine.py ${raw.join(' ')}
    """
}