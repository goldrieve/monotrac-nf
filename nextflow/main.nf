nextflow.enable.dsl = 2

params.samplesheet = "$projectDir/data/samplesheet.csv"
params.reference_1 = "$projectDir/data/References/targets_sequence2.fasta"

params.cores = "4"
params.outdir = "$projectDir/output"
params.help = ""
params.mode = "full"
params.depth = "10"
params.isolates = "$projectDir/data/isolate_fasta"
params.kraken_db = "$projectDir/data/kraken/monotrac_db"

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
include { KRAKEN } from './modules/kraken2.nf'
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


workflow {
    // Running the first fastqc process
    if (params.mode == "full") {
        kraken_ch = KRAKEN(ch_reads, params.kraken_db)
        fastqc_ch = FASTQC(ch_reads)
        medakavar_ch = MEDAKAVAR(ch_reads, params.reference_1, params.depth)
        mosdepth_ch = MOSDEPTH(medakavar_ch.consensus)
        plotting_ch = PLOTTING(mosdepth_ch.global)
        combinefiles_ch = COMBINEFILES((mosdepth_ch.summary).collect())
        boxplot_ch = BOXPLOT(combinefiles_ch)
        rawcombine_ch = RAWCOMBINE((mosdepth_ch.global).collect())
        lineplot_ch = LINEPLOT(rawcombine_ch)
        align_ch = ALIGN((medakavar_ch.fasta).collect(), isolates_fasta_files)
        fasttree_ch = FASTTREE(align_ch)
        multiqc_ch = MULTIQC((kraken_ch).collect(), (fastqc_ch.zip).collect(), (mosdepth_ch.global).collect()) 
    }  

    else {
        log.error("Invalid mode selected. Please select either 'full' or 'fastqc'")
        System.exit(1)
    }
}

workflow.onComplete {
    log.info(workflow.success ? "\nDone!" : "Oops .. something went wrong")
}