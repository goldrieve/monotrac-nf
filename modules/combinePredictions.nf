process FINAL{
    tag "Combining predictions"
    publishDir "${params.outdir}/Isolate_Morphology"

    input: 
    path predictions

    output:
    path "final_predictions.csv"

    script:
    """
    python finaloutput.py "${predictions.join(' ')}" "final_predictions.csv" 
    """
}