 // module for running medaka variant on the raw reads 
 
process MEDAKAVAR {
    conda "/opt/anaconda3/envs/medaka"
    publishDir "${params.outdir}/Consensus/VCF/${hdf}"

    input:
    path hdf
    path reference

    output:
    path "${hdf}_medaka.vcf"

    script:
    """
    echo "Calling variant"
    medaka variant ${reference} ${hdf}/consensus_probs.hdf ${hdf}_medaka.vcf
    """
}
 