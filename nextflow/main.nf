nextflow.enable.dsl = 2

params.samplesheet = "$projectDir/samplesheet.csv"
params.reference_1 = "$projectDir/References/targets.fasta"
params.reference_2 = "$projectDir/References/targets_sequence.fasta"
params.reference_3 = "$projectDir/References/targets_sequence2.fasta"
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

include { MINIMAP } from './modules/minimap2.nf'

include { MEDAKACON } from './modules/medakacon.nf'

include { MEDAKAVAR } from './modules/medakavar.nf'

workflow {
    // Running the first fastqc process
    if (params.mode == "full") {
        fastqc_ch = FASTQC(ch_reads)
    
        // running minimap2
        minimap_ch = MINIMAP(ch_reads, file(params.reference_2))

        // running medaka consensus
        medakacon_ch = MEDAKACON(ch_reads, file(params.reference_1))

        // running medaka variant
        medakavar_ch = MEDAKAVAR(medakacon_ch, file(params.reference_1))
    }  

    else {
        log.error("Invalid mode selected. Please select either 'full' or 'fastqc'")
        System.exit(1)
    }
}

workflow.onComplete {
    log.info(workflow.success ? "\nDone!" : "Oops .. something went wrong")
}