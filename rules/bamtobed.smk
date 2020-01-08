rule bedtools_bamtobed:
    input:
        bam = rules.samtools_sort.output
    output:
        bed = "data/dataset/bamtobed/aligned.sortedByName.out.bed"
    conda:
        "../envs/bedtools.yaml"
    threads:
        12
    log:
        "../logs/bedtools.log"
    shell:
        "bedtools bamtobed -i {input.bam} > {output.bed}"
