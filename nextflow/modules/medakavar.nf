 // module for running medaka variant on the raw reads 
 
process MEDAKAVAR {
    conda "/opt/anaconda3/envs/medaka"
    publishDir "${params.outdir}/Consensus/${reads}"

    input:
    path reads
    path reference
    val depth
    path orf

    output:
    path "${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/medaka.filtered.vcf.gz"
    path "${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/medaka.vcf"
    path "${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus", emit: consensus
    path "${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_CDS/${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_CDS.fas", emit: fasta
    

    script:
    """
    medaka_consensus -i ${reads} -d ${reference} -o ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus
    echo "Calling variant"
    medaka variant ${reference} ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/consensus_probs.hdf ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/medaka.vcf
    medaka tools annotate --dpsp ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/medaka.vcf ${reference} ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/calls_to_draft.bam ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/medaka.annotated.unfiltered.vcf 
        
    bcftools reheader ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/medaka.annotated.unfiltered.vcf -s <(echo '${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}') \
    | bcftools filter \
        -e 'INFO/DP < ${depth}' \
        -s LOW_DEPTH \
        -Oz | bcftools view -f PASS -O z -o ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/filtered.vcf.gz
 
    zgrep '^#' $projectDir/data/References/blank.vcf.gz > ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/medaka.filtered.vcf 
    zgrep -v '^#' ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/filtered.vcf.gz >> ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/medaka.filtered.vcf
    bgzip ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/medaka.filtered.vcf

    bcftools index ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/medaka.filtered.vcf.gz
    
    python $projectDir/bin/vcf2fasta/vcf2fasta.py --fasta ${reference} --vcf ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/medaka.filtered.vcf.gz \
    --gff ${orf} --feat CDS --out ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}

    python $projectDir/bin/concatfas.py ${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_consensus/${reads.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_CDS
    """
}
 
 