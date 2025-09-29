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
params.ml = "$projectDir/data/ml.pkl"
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
include { VAR_CALL } from './modules/var_call.nf'
include { CREATE_VCF } from './modules/create_vcf.nf'
include { MOSDEPTH } from './modules/mosdepth.nf'
include { PLOTTING } from './modules/plotting.nf'
include { BOXPLOT } from './modules/boxplot.nf'
include { ALIGN } from './modules/align.nf'
include { FASTTREE } from './modules/fasttree.nf'
include { COMBINEFILES } from './modules/combineFiles.nf'
include { RAWCOMBINE } from './modules/rawCombine.nf'
include { LINEPLOT } from './modules/lineplot.nf'
include { MULTIQC } from './modules/multiqc.nf'
include { TRANSEQ } from './modules/transeq.nf'
include { AACOUNT } from './modules/AAcount.nf'
include { COMBINECSV } from './modules/combinecsv.nf'
include { PREDICT } from './modules/predict.nf'
include { FINAL } from './modules/final.nf'

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
        CREATE_VCF(
            VAR_CALL.out,
            params.reference,
            params.depth,
            params.orf,
            params.vcf
            )
        MOSDEPTH(
            CREATE_VCF.out.consensus
            )
        PLOTTING(
            MOSDEPTH.out.global
            )
        COMBINEFILES(
            (MOSDEPTH.out.summary).collect()
            )
        BOXPLOT(
            COMBINEFILES.out
            )
        RAWCOMBINE(
            (MOSDEPTH.out.global).collect()
            )
        LINEPLOT(
            RAWCOMBINE.out
            )
        isolates_fasta_files = Channel.fromPath("${params.isolates}/*.fas").collect()
        ALIGN(
            (CREATE_VCF.out.fasta).collect(),
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
            CREATE_VCF.out.fasta
            )
        AACOUNT(
            TRANSEQ.out
            )
        COMBINECSV(
            (AACOUNT.out).collect()
            )
        PREDICT(AACOUNT.out,
            params.ml
            )
        FINAL(
            (PREDICT.out).collect()
            )
}

workflow {
    help ()
    monotrac()
}