process PREDICT{
    tag "$sample"
    publishDir "${params.outdir}/predictions"

    input:
    tuple val (sample), path (csv) 
    path pkl

    output:
    path "${sample}_prediction.txt"

    script:
    """
    predict.py $csv
    """
}