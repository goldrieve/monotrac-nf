process COMBINECSV {
    tag "Generating AA combined csv"
    publishDir "${params.outdir}/."

    input:
    path (csvfiles) 

    output:
    path "combined.csv"

    script:
    """
    python combinecsv.py ${csvfiles.join(' ')}
    """
}