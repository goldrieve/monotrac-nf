        
process GENERATE_CONSENSUS {
    tag "$sample"
    publishDir "${params.outdir}/consensus"

    input:
    tuple val (sample), path (unfiltered)
    path reference
    val depth
    path orf
    path vcf

    output:
    tuple val (sample), path ("${sample}_final_filtered.vcf.gz")
    path ("${sample}*.fas"), emit: fasta
    tuple val (sample), path ("${sample}*.fas"), emit: sample_fasta
    
    script:
    """
    bcftools view -f PASS -O z -o ${sample}_filtered.vcf.gz $unfiltered
 
    zgrep '^#' ${vcf} > ${sample}_final_filtered.vcf 
    zgrep -v '^#' ${sample}_filtered.vcf.gz >> ${sample}_final_filtered.vcf 
    bgzip ${sample}_final_filtered.vcf 

    bcftools index ${sample}_final_filtered.vcf.gz
    cat ${reference} | grep -v ^\$ | bcftools consensus -H I ${sample}_final_filtered.vcf.gz > ${sample}_consensus.fas 
    """
}