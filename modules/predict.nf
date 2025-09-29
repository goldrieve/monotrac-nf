process PREDICT{
    tag "$sample"
    publishDir "${params.outdir}/Isolate_Morphology"

    input:
    tuple val (sample), path (csv) 
    path "data/ml.pkl"

    output:
    path "${sample}_prediction.txt"

    script:
    """
    python predict.py ${sample}.csv
    """
}