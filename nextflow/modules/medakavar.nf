 // module for running medaka variant on the raw reads 
 
process MEDAKAVAR {
    conda "/opt/anaconda3/envs/medaka"
    publishDir "${params.outdir}/Consensus/${reads}"

    input:
    path reads
    path reference
    val depth

    output:
    path "${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/medaka.consensus.fasta"
    path "${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/medaka.annotated.vcf.gz"
    path "${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/medaka.vcf"
    path "${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus"

    script:
    """
    medaka_consensus -i ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")} -d ${reference} -o ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus
    echo "Calling variant"
    medaka variant ${reference} ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/consensus_probs.hdf ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/medaka.vcf
    medaka tools annotate --dpsp ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/medaka.vcf ${reference} ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/calls_to_draft.bam ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/medaka.annotated.unfiltered.vcf 
        
    bcftools reheader ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/medaka.annotated.unfiltered.vcf -s <(echo '${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}') \
    | bcftools filter \
        -e 'INFO/DP < ${depth}' \
        -s LOW_DEPTH \
        -Oz -o ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/medaka.annotated.vcf.gz
 

    bcftools index ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/medaka.annotated.vcf.gz
    bcftools consensus -f ${reference} ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/medaka.annotated.vcf.gz \
        -i 'FILTER="PASS"' \
        -o ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/medaka.consensus.fasta
    """
}
 