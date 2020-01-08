rule samtools_sort:
    input:
        rules.download_bam.output.bam
    output:
        "data/dataset/sorted/aligned.sortedByName.out.bam"
    params:
        "-n"
    conda:
        "../envs/samtools.yaml"
    log:
        "logs/samtools_sort.log"
    threads:
        1
    shell:
        "samtools sort -n {input} > {output}"
