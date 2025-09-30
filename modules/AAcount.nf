process AACOUNT {
    tag "$sample"
    publishDir "${params.outdir}/aa_counts"

    input: 
    tuple val (sample), path (amino_acid) 

    output:
    path ("${sample}_AA_counts.csv"), emit: counts
    tuple val (sample), path ("${sample}_AA_counts.csv"), emit: sample_counts

    script:
    """
    AAcount.py ${amino_acid}
    """
}