process PREDICT{ 
    conda "/opt/anaconda3/envs/medaka"
    publishDir "${params.outdir}/Isolate_Morphology"

    input:
    path csv 
    path "data/ml.pkl"

    output:
    path "predictions_${csv.baseName.replaceAll(/\.fq(\.gz)?$/, "")}.txt"

    script:
    """
    python $projectDir/bin/predict.py ${csv.baseName.replaceAll(/\.fq(\.gz)?$/, "")}.csv
    """
}