process FASTTREE {
    tag "Generating tree"
    publishDir "${params.outdir}/Plots"

    input:
    path (mafft)

    output:
    path "tree.nwk" 

    script:
    """
    FastTree -nt -gtr -gamma $mafft > tree.nwk
    """
}