nextflow.enable.dsl = 2

params.samplesheet = "$projectDir/samplesheet.csv"
params.reference_1 = "$projectDir/References/targets.fasta"
params.reference_2 = "$projectDir/References/targets_sequence.fasta"
params.reference_3 = "$projectDir/References/targets_sequence2.fasta"
params.cores = "4"
params.outdir = "$projectDir/output"
params.help = ""
params.mode = "full"
params.depth = "10"

if (params.help) {
    help = """mono-trac.nf: A pipeline for analysing mono-trac data
             |
             |Arguments:
             |
             |  --reference Location of assemblies
             |                [default: ${params.reference}]
             |  --cores  Define number of cores Trinity and other tools will use.
             |                [default: ${params.cores}]
             |  --outdir        VSGSeq output directory. 
             |                [default: ${params.outdir}]
             |  --samplesheet  Define the path to the samplesheet.
             |                [default: ${params.samplesheet}]
             |  --help         Print this message.""".stripMargin()
    // Print the help with the stripped margin and exit
    println(help)
    exit(0)
}

include { FASTQC } from './modules/fastqc'

ch_samplesheet = Channel.fromPath(params.samplesheet)

ch_reads = ch_samplesheet.splitCsv(header:true).map {
    file(it['read'])
}

include { MEDAKAVAR } from './modules/medakavar.nf'

include { MOSDEPTH } from './modules/mosdepth.nf'

include { PLOTTING } from './modules/plotting.nf'

include { BOXPLOT } from './modules/boxplot.nf'

include { ALIGN } from './modules/align.nf'


workflow {
    // Running the first fastqc process
    if (params.mode == "full") {
        fastqc_ch = FASTQC(ch_reads)
        medakavar_ch = MEDAKAVAR(ch_reads, params.reference_1, params.depth)
        mosdepth_ch = MOSDEPTH(medakavar_ch.consensus)
        plotting_ch = PLOTTING(mosdepth_ch.global)
        align_ch = ALIGN((medakavar_ch.fasta).collect())
        boxplot_ch = BOXPLOT(mosdepth_ch.summary)
    }  

    else {
        log.error("Invalid mode selected. Please select either 'full' or 'fastqc'")
        System.exit(1)
    }
}

workflow.onComplete {
    log.info(workflow.success ? "\nDone!" : "Oops .. something went wrong")
}