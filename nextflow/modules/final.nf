process FINAL { 
    publishDir "${params.outdir}/Isolate_Morphology"

    input:
    path input_files 

    output:
    path "combined_prediction.csv"

    script:
    """
    python $projectDir/bin/final.py ${input_files.join(' ')} combined_prediction.csv
    """
}