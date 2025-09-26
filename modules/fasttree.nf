process FASTTREE {
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