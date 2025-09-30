process VAR_CALL {
    tag "$sample"
    publishDir "${params.outdir}/vcf"

    input:
    tuple val (sample), file (reads)
    path reference
    path model

    output:
    tuple val (sample), path ("${sample}_unfiltered.vcf"), emit: vcf
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
    --platform="ont" \
    --model_path="$model" \
    --include_all_ctgs \
    --output=${sample}_claire3

    mv ${sample}_claire3/merge_output.vcf.gz "${sample}_unfiltered.vcf"
    """
}
 
