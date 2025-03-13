process AACOUNT {
    conda "/opt/anaconda3/envs/medaka"
    publishDir "${params.outdir}/AA_Counts"

    input: 
    path aaseq 

    output:
    path "${aaseq.baseName.replaceAll(/\.fq(\.gz)?$/, "")}_counts.csv"

    script:
    """
    python $projectDir/bin/AAcount.py ${aaseq}
    """
}