nextflow.enable.dsl = 2

params.samplesheet = "$projectDir/data/samplesheet.csv"
params.reference_1 = "$projectDir/data/References/padded_targets_positive.fasta"
params.cores = "4"
params.outdir = "$projectDir/output"
params.help = ""
params.mode = "full"
params.depth = "10"
params.isolates = "$projectDir/data/isolate_fasta"
params.orf = "$projectDir/data/References/orf.gff"
params.ml = "$projectDir/data/ml.pkl"


if (params.help) {
    help = """main.nf: A pipeline for analysing mono-trac data
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
             |  --help         Print this message.""".stripMargin()
    // Print the help with the stripped margin and exit
    println(help)
    exit(0)
}

include { FASTQC } from './modules/fastqc'
include { MEDAKAVAR } from './modules/medakavar.nf'
include { MOSDEPTH } from './modules/mosdepth.nf'
include { PLOTTING } from './modules/plotting.nf'
include { BOXPLOT } from './modules/boxplot.nf'
include { ALIGN } from './modules/align.nf'
isolates_fasta_files = Channel.fromPath("${params.isolates}/*.fas").collect()
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


workflow {
    if (params.mode == "full") {
        Channel
            .fromPath(params.samplesheet)
            .splitCsv(header: true)
            .map { row -> [row.sample, file(row.read)] }
            .set { sample_ch }

        fastqc_ch = FASTQC(sample_ch)
        medakavar_ch = MEDAKAVAR(sample_ch, params.reference_1, params.depth, params.orf)
        mosdepth_ch = MOSDEPTH(medakavar_ch.consensus)
        plotting_ch = PLOTTING(mosdepth_ch.global)
        combinefiles_ch = COMBINEFILES((mosdepth_ch.summary).collect())
        boxplot_ch = BOXPLOT(combinefiles_ch)
        rawcombine_ch = RAWCOMBINE((mosdepth_ch.global).collect())
        lineplot_ch = LINEPLOT(rawcombine_ch)
        align_ch = ALIGN((medakavar_ch.fasta).collect(), isolates_fasta_files)
        fasttree_ch = FASTTREE(align_ch)
        multiqc_ch = MULTIQC((fastqc_ch.zip).collect(), (mosdepth_ch.global).collect()) 
        transeq_ch = TRANSEQ(medakavar_ch.fasta)
        aacount_ch = AACOUNT(transeq_ch.amino_acid_seq)
        combinecsv_ch = COMBINECSV((aacount_ch).collect())
        predict_ch = PREDICT(aacount_ch, params.ml)
        final_ch = FINAL((predict_ch).collect())
    }  

    else {
        log.error("Invalid mode selected. Please select either 'full' or 'fastqc'")
        System.exit(1)
    }
}

workflow.onComplete {
    log.info(workflow.success ? "\nDone!" : "Oops .. something went wrong")
}
