process AACOUNT {
    tag "$sample"
    publishDir "${params.outdir}/AA_Counts"

    input: 
    tuple val (sample), path (amino_acid) 

    output:
    path "${sample}_counts.csv"

    script:
    """
    python AAcount.py ${amino_acid}
    """
}