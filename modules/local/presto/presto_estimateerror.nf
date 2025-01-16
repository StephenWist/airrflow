process PRESTO_ESTIMATEERROR {
    tag "$meta.id"
    label "process_medium"
    label 'immcantation'

    conda "bioconda::presto=0.7.1"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/presto:0.7.1--pyhdfd78af_0' :
        'biocontainers/presto:0.7.1--pyhdfd78af_0' }"

    input:
    tuple val(meta), path(reads)

    output:
    path("*_command_log.txt") , emit: logs
    path("versions.yml"), emit: versions



    script:
    """
    EstimateError.py set -s $reads --outname ${meta.id} --log ${meta.id}.log > ${meta.id}_command_log.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        presto: \$( EstimateError.py --version | awk -F' '  '{print \$2}' )
    END_VERSIONS
    """
}
