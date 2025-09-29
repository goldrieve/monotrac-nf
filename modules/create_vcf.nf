        
process CREATE_VCF {
    tag "$sample"
    publishDir "${params.outdir}/Consensus/${reads}"

    input:
    tuple val (sample), file (unfiltered)
    path reference
    val depth
    path orf
    path vcf

    output:
    tuple val (sample), path ("${sample}_consensus/medaka.filtered.vcf.gz")
    tuple val (sample), path ("${sample}_consensus/medaka.vcf")
    tuple val (sample), path ("${sample}_consensus"), emit: consensus
    tuple val (sample), path ("${sample}_CDS/${sample}_CDS.fas"), emit: fasta
    
    script:
    """
    bcftools reheader ${sample}_consensus/medaka.annotated.unfiltered.vcf -s <(echo '${sample}') \
    | bcftools filter \
        -e 'INFO/DP < ${depth}' \
        -s LOW_DEPTH \
        -Oz | bcftools view -f PASS -O z -o ${sample}_consensus/filtered.vcf.gz
 
    zgrep '^#' ${vcf} > ${sample}_consensus/medaka.filtered.vcf 
    zgrep -v '^#' ${sample}_consensus/filtered.vcf.gz >> ${sample}_consensus/medaka.filtered.vcf
    bgzip ${sample}}_consensus/medaka.filtered.vcf

    bcftools index ${sample}_consensus/medaka.filtered.vcf.gz
    
    python vcf2fasta.py --fasta ${reference} --vcf ${sample}_consensus/medaka.filtered.vcf.gz \
    --gff ${orf} --feat CDS --out ${sample}

    python concatfas.py ${sample}_consensus/${sample}_CDS
    """
}