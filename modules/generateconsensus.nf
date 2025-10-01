        
process GENERATE_CONSENSUS {
    tag "$sample"
    publishDir "${params.outdir}/consensus"

    input:
    tuple val (sample), path (vcf), path (index)
    path reference
    path orf

    output:
    path ("${sample}*_padded.fa")
    path ("${sample}*.fa"), emit: fasta
    tuple val (sample), path ("${sample}*.fa"), emit: sample_fasta
    
    script:
    """
    cat ${reference} | grep -v ^\$ | bcftools consensus -H I ${sample}_final.vcf.gz > ${sample}_padded.fa
    bedtools getfasta -fi ${sample}_padded.fa -bed ${orf} -fo - | sed 's/:.*\$//' > ${sample}.fa
    """
}