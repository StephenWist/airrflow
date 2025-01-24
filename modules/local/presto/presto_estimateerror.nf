process PRESTO_ESTIMATEERROR {
    tag "$meta.id"
    label "process_medium"
    label 'immcantation'

    conda "bioconda::presto=0.7.1"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/presto:0.7.1--pyhdfd78af_0' :
        'biocontainers/presto:0.7.1--pyhdfd78af_0' }"

    input:
    tuple val(meta), path(R1), path(R2)
    val(barcode_position)

    output:
    tuple val(meta), path("*.tab")
    path("*_command_log.txt") , emit: logs
    path("versions.yml"), emit: versions

    script:
    """
    if [ $barcode_position == "R2" ]; then 
        EstimateError.py set -s $R2 --outname ${meta.id} --log ${meta.id}.log > ${meta.id}_command_log.txt
    elif [ $barcode_position == "R1" ]; then
        EstimateError.py set -s $R1 --outname ${meta.id} --log ${meta.id}.log > ${meta.id}_command_log.txt
    fi
    
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        presto: \$( EstimateError.py --version | awk -F' '  '{print \$2}' )
    END_VERSIONS
    """
}
