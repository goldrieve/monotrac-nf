process FINAL {
    tag "Summary"
    publishDir "${params.outdir}/predictions"

    input:
    path input_files 

    output:
    path "combined_prediction.csv"

    script:
    """
    final.py ${input_files.join(' ')} combined_prediction.csv
    """
}