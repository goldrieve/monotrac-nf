process AACOUNT {
    tag "$sample"
    publishDir "${params.outdir}/aa_counts"

    input: 
    tuple val (sample), path (amino_acid) 

    output:
    tuple val (sample), path ("${sample}_AA_counts.csv")

    script:
    """
    AAcount.py ${amino_acid}
    """
}