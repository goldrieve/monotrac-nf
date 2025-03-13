process COMBINECSV {
    conda "/opt/anaconda3/envs/medaka"
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