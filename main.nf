//main.nf file for sars-cov-2 clades assignment with nextflow
#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// PIPELINE PARAMETERS HERE
def helpMessage() {
    log.info"""
        Usage:
        The typical command for running the pipeline is as follows:
        nextflow run valentinelsra/CovSeq --multi_fa 'Users/valentinelesourd-aubert/nextseq_results/2021/COVID_RUN6_240921_DBLB/COVID_RUN6_240921_DBLB_sup95.multi.fasta' --outdir '.'
        Mandatory arguments:
        --multi_fa                  Path to multi FASTA, must be in quotes
        --outdir                    Specify path to output directory
        """.stripIndent()
}

// PROCESS
Process pangolin {
    container 'staphb/pangolin'
    cpus 1
    memory '1 GB'
    publishDir params.outdir, mode 'copy'

    iput:
    path multi_fa

    output path '*_lineage.csv'

    shell:
    '''

    pangolin --usher !{combined_fa} --outfile pangolin_lineage.csv
    '''
}

Process nextclade {
    container 'nextstrain/nextclade:latest'
    cpus 4
    memory '6 GB'
    PublishDir params.outdir

    input:
    path multi_fa

    output:
    path '*nextclade_lineage.csv'

    shell:
    ''' nextclade dataset get --name='sars-cov-2' --input-fasta !{multi_fa} --output-csv nextclade_lineage.csv
    '''

}

//WORKFLOW
workflow {
    multi_fa_data=channel.fromPath( params.multi_fa ).collect()
    //pangolin(multi_fa_data)
    nextclade(multi_fa_data)
}

//Input Files
params.reads = "$basedIRE:DATA:$:$_{R1,R2}_*.fastq.gz"

// Report Directory
params.outdir = 'reports'

