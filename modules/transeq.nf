process TRANSEQ {
    tag "$sample"
    publishDir "${params.outdir}/aa_seqs"

    input:
    tuple val (sample), path (dna)

    output:
    tuple val (sample), path ("${sample}_AA.fas")

    script:
    """
    transeq -sequence ${dna} -outseq ${sample}_AA.fas
    """
}