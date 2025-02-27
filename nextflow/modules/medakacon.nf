// Module for running medaka consensus on the raw reads 

process MEDAKACON{
    conda "/opt/anaconda3/envs/medaka"
    publishDir "${params.outdir}/Consensus"

    input:
    path reads 
    path reference

    output:
    path "${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus"

    script:
    """
    echo "Generating a consensus sequence for ${reads}"
    medaka_consensus -i ${reads} -d ${reference} -o ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus
    """
}