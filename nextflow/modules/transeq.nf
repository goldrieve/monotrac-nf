process TRANSEQ { 
    conda "/opt/anaconda3/envs/medaka"
    publishDir "${params.outdir}/Protein_seqs"

    input:
    path dna

    output:
    path "${dna.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_AA.fas", emit: amino_acid_seq

    script:
    """
    transeq -sequence ${dna} -outseq ${dna.baseName.replaceAll(/\.fq(\.gz)?$/, "")}.temp.fas
    sed 's/_1\$//' ${dna.baseName.replaceAll(/\.fq(\.gz)?$/, "")}.temp.fas > ${dna.baseName.replaceAll(/\.fq(\.gz)?$/, "")}.temp2.fas
    sed 's/*\$//' ${dna.baseName.replaceAll(/\.fq(\.gz)?$/, "")}.temp2.fas > ${dna.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_AA.fas
    echo 'has this saved?'
    """
}