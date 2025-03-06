nextflow.enable.dsl = 2

params.samplesheet = "$projectDir/samplesheet.csv"
params.reference = "$projectDir/data/blastdb/concatAnTattb427.fa"
params.cores = "4"
params.outdir = "$projectDir/output"
params.help = ""
params.mode = "full"

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

workflow {
    if (params.mode == "full") {
        fastqc_ch = FASTQC(ch_reads)
    }  

    else {
        log.error("Invalid mode selected. Please select either 'full' or 'fastqc'")
        System.exit(1)
    }
}

workflow.onComplete {
    log.info(workflow.success ? "\nDone!" : "Oops .. something went wrong")
}