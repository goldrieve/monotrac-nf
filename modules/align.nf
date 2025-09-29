process ALIGN {
    tag "Aligning FASTA"
    publishDir "${params.outdir}/Aligned"
    
    input:
    path (fastas)
    path (isolates_fasta_files)

    output:
    path "aligned.fas"

    script:
    """
    mkdir -p reordered_fastas
    python concatenate.py reordered_fastas $fastas $isolates_fasta_files
    mafft --auto reordered_fastas/concatenated_sequences.fasta > aligned.fas
    """
}