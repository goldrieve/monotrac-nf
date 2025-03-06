process FASTTREE {
    conda "/opt/anaconda3/envs/mafft"
    publishDir "${params.outdir}/Plots"

    input:
    path mafft

    output:
    path "tree.nwk" 

    script:
    """
    FastTree -nt -gtr -gamma aligned.fas > tree.nwk
    """
}