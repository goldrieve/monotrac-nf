process VAR_CALL {
    tag "$sample"
    publishDir "${params.outdir}/vcf"

    input:
    tuple val (sample), file (reads)
    path reference
    path model
    val depth
    val mpq
    path blank

    output:
    tuple val (sample), path ("${sample}_final.vcf.gz"), path ("${sample}_final.vcf.gz.csi"),  emit: vcf
    tuple val (sample), path ("${sample}.bam.bai"), path ("${sample}.bam"), emit: bam
    
    script:
    """
    minimap2 -a -x map-ont $params.reference $reads \
    | samtools view -bS \
    | samtools sort -o ${sample}.bam -
    
    samtools index ${sample}.bam

    conda run -n monotrac-env run_clair3.sh \
    --bam_fn=${sample}.bam \
    --ref_fn=$params.reference \
    --threads=4 \
    --min_mq=$mpq \
    --min_coverage=$depth \
    --platform="ont" \
    --model_path="$model" \
    --include_all_ctgs \
    --output=${sample}_claire3

    mv ${sample}_claire3/merge_output.vcf.gz "${sample}.vcf"
    zgrep '^#' ${blank} > ${sample}_final.vcf 
    zgrep -v '^#' ${sample}.vcf >> ${sample}_final.vcf 
    bgzip ${sample}_final.vcf
    bcftools index ${sample}_final.vcf.gz
    """
}
 
