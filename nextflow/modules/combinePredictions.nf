process FINAL{
    publishDir "${params.outdir}/Isolate_Morphology"

    input: 
    path predictions

    output:
    path "final_predictions.csv"

    script:
    """
    python $projectDir/bin/finaloutput.py "${predictions.join(' ')}" "final_predictions.csv" 
    """
}