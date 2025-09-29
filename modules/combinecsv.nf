process COMBINECSV {
    tag "Generating AA combined csv"
    publishDir "${params.outdir}/combined_csv"

    input:
    tuple val (sample), path (csvfiles) 

    output:
    path "combined.csv"

    script:
    """
    combinecsv.py ${csvfiles.join(' ')}
    """
}