process ALIGN {
    conda "/opt/anaconda3/envs/mafft"
    publishDir "${params.outdir}/Aligned"
    
    input:
    path (fastas)

    output:
    path "aligned.fas"

    script:
    """
    python $projectDir/bin/concatenate.py 
    mafft --auto reordered_fastas/concatenated_sequences.fasta > aligned.fas
    """
}