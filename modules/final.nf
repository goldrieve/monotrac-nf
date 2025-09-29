process FINAL {
    tag "Summary"
    publishDir "${params.outdir}/Isolate_Phenotype"

    input:
    path input_files 

    output:
    path "combined_prediction.csv"

    script:
    """
    python final.py ${input_files.join(' ')} combined_prediction.csv
    """
}