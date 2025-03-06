// module for removing any reads that are not T, brucei DNA. 

process KRAKEN{ 
    conda "/opt/anaconda3/envs/monotrac"
    publishDir "${params.outdir}/kraken"

    input: 
    path fastq
    path kraken 

    output:
    path "${fastq.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_report.txt"

    script:
    """
    kraken2 --db ${kraken} --output ${fastq.baseName.replaceAll(/\.fq(\.gz)?$/, "")} --report ${fastq.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_report.txt ${fastq}
    """
}