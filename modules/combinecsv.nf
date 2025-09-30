process COMBINE_CSV {
    tag "Generating AA combined csv"
    publishDir "${params.outdir}/combined_csv"

    input:
    path (csvfiles) 

    output:
    path "combined.csv"

    script:
    """
    combinecsv.py ${csvfiles.join(' ')}
    """
}