process FINAL{
    tag "Combining predictions"
    publishDir "${params.outdir}/predictions"

    input: 
    path predictions

    output:
    path "final_predictions.csv"

    script:
    """
    finaloutput.py "${predictions.join(' ')}" "final_predictions.csv" 
    """
}