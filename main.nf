#!/usr/local/bin/nextflow
//main.nf file for sars-cov-2 clades assignment with nextflow

nextflow.enable.dsl=2

// PROCESS

/*
 * Variants assignment
 */
process pangolin {
    container 'staphb/pangolin'
    cpus 1
    memory '1 GB'
    publishDir params.outdir, mode 'copy'

    input:
    path multi_fa // switch with multi.fasta variable from end of pipeline

    output path 'pangolin.csv'

    shell:
    '''
    pangolin --usher !{multi_fa} --outfile pangolin.csv --threads $task.cpus
    '''
}

/*
 * Clades assignment
 */
process nextclade {
    container 'nextstrain/nextclade:latest'
    cpus 6
    memory '6 GB'
    publishDir params.outdir, mode 'copy'

    input:
    path multi_fa // switch with multi.fasta variable from end of pipeline

    output:
    path 'nextclade.csv'

    shell:
    ''' nextclade dataset get --name='sars-cov-2' --input-fasta !{multi_fa} --output-csv nextclade.csv --threads $task.cpus
    '''
}

//WORKFLOW
workflow {
    multi_fa_data=channel.fromPath( params.multi_fa ).collect()
    //pangolin(multi_fa_data)
    nextclade(multi_fa_data)
}
