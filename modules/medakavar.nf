 // module for running medaka variant on the raw reads 
 
process MEDAKAVAR {
    tag "$sample"
    publishDir "${params.outdir}/Consensus/${reads}"

    input:
    tuple val (sample), file (reads)
    path reference
    val depth
    path orf

    output:
    tuple val (sample), path ("${sample}_consensus/medaka.filtered.vcf.gz")
    tuple val (sample), path ("${sample}_consensus/medaka.vcf")
    tuple val (sample), path ("${sample}_consensus"), emit: consensus
    tuple val (sample), path ("${sample}_CDS/${sample}_CDS.fas"), emit: fasta
    

    script:
    """
    medaka_consensus -i ${reads} -d ${reference} -o ${sample}_consensus
    echo "Calling variant"
    medaka vcf ${reference} ${sample}_consensus/consensus_probs.hdf ${sample}_consensus/medaka.vcf
    medaka tools annotate --dpsp ${sample}_consensus/medaka.vcf ${reference} ${sample}_consensus/calls_to_draft.bam ${sample}_consensus/medaka.annotated.unfiltered.vcf 
        
    bcftools reheader ${sample}_consensus/medaka.annotated.unfiltered.vcf -s <(echo '${sample}') \
    | bcftools filter \
        -e 'INFO/DP < ${depth}' \
        -s LOW_DEPTH \
        -Oz | bcftools view -f PASS -O z -o ${sample}_consensus/filtered.vcf.gz

    echo "The variants have been filtered based on the depth of coverage"
 
    zgrep '^#' $projectDir/data/References/blank.vcf.gz > ${sample}_consensus/medaka.filtered.vcf 
    zgrep -v '^#' ${sample}_consensus/filtered.vcf.gz >> ${sample}_consensus/medaka.filtered.vcf
    bgzip ${sample}}_consensus/medaka.filtered.vcf

    echo "a blank vcf header has been added to account for missing genes"

    bcftools index ${sample}_consensus/medaka.filtered.vcf.gz

    echo "The filtered vcf has been indexed"
    
    python vcf2fasta.py --fasta ${reference} --vcf ${sample}_consensus/medaka.filtered.vcf.gz \
    --gff ${orf} --feat CDS --out ${sample}

    python concatfas.py ${sample}_consensus/${sample}_CDS
    """
}
 
