#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

/* Define variables */
params.samplesheet = "$projectDir/data/samplesheet.csv"
params.reference = "$projectDir/data/references/padded_targets_positive.fasta"
params.cores = "4"
params.outdir = "$projectDir/output"
params.help = false
params.mode = "full"
params.depth = "10"
params.isolates = "$projectDir/data/isolate_fasta"
params.orf = "$projectDir/data/references/orf.gff"
params.pkl = "$projectDir/data/machine_learning/ml.pkl"
params.vcf = "$projectDir/data/references/blank.vcf.gz"
params.model = "$projectDir/data/model/r1041_e82_400bps_hac_v520"

/* Print help message if --help is passed */
workflow help {
    if (params.help) {
        println """
        main.nf: A pipeline for analysing mono-trac data
                 |
                 |Arguments:
                 |
                 |  --reference Location of reference file.
                 |                [default: ${params.reference}]
                 |  --cores  Define number of cores the tools will use.
                 |                [default: ${params.cores}]
                 |  --outdir        pipeline output directory. 
                 |                [default: ${params.outdir}]
                 |  --samplesheet  Define the path to the samplesheet.
                 |                [default: ${params.samplesheet}]
                 |  --help         Print this message.
                 """
        exit(0)
    }
}

/* set modules */
include { FASTQC } from './modules/fastqc'
include { VAR_CALL } from './modules/varcall'
include { GENERATE_CONSENSUS } from './modules/generateconsensus'
include { MOSDEPTH } from './modules/mosdepth'
include { PLOTTING } from './modules/plotting'
include { ALIGN } from './modules/align'
include { FASTTREE } from './modules/fasttree'
include { MULTIQC } from './modules/multiqc'
include { TRANSEQ } from './modules/transeq'
include { AA_COUNT } from './modules/aacount'
include { COMBINE_CSV } from './modules/combinecsv'
include { PREDICT } from './modules/predict'
include { FINAL } from './modules/final'

/* MONOTRAC workflow */
workflow monotrac {
    main:
        Channel
            .fromPath(params.samplesheet)
            .splitCsv(header: true)
            .map { row -> [row.sample, file(row.read)] }
            .set { sample_ch }

        FASTQC(
            sample_ch
            )
        VAR_CALL(
            sample_ch,
            params.reference,
            params.model
            )
        GENERATE_CONSENSUS(
            VAR_CALL.out.vcf,
            params.reference,
            params.depth,
            params.orf,
            params.vcf
            )
        MOSDEPTH(
            VAR_CALL.out.bam
            )
        PLOTTING(
            MOSDEPTH.out.sample_global,
            (MOSDEPTH.out.summary).collect(),
            )
        isolates_fasta_files = Channel.fromPath("${params.isolates}/*.fas").collect()
        ALIGN(
            (GENERATE_CONSENSUS.out.fasta).collect(),
            isolates_fasta_files
            )
        FASTTREE(
            ALIGN.out
            )
        MULTIQC(
            (FASTQC.out.zip).collect(),
            (MOSDEPTH.out.global).collect()
            ) 
        TRANSEQ(
            GENERATE_CONSENSUS.out.sample_fasta
            )
        AA_COUNT(
            TRANSEQ.out
            )
        COMBINE_CSV(
            (AA_COUNT.out.counts).collect()
            )
        PREDICT(
            AA_COUNT.out.sample_counts,
            params.pkl
            )
        FINAL(
            (PREDICT.out).collect()
            )
}

workflow {
    help ()
    monotrac()
}