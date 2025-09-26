process COMBINECSV {
    publishDir "${params.outdir}/."

    input:
    path csvfiles 

    output:
    path "combined.csv"

    script:
    """
    python ${projectDir}/bin/combinecsv.py ${csvfiles.join(' ')}
    """
}