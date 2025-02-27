// mosdepth module 

process MOSDEPTH{ 
    conda "/opt/anaconda3/envs/monotrac"
    publishDir "${params.outdir}"
}