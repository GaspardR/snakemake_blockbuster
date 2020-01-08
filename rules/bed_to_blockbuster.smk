rule bed_to_blockbuster:
    """ Format bed file to blockbuster input format """
    input:
        bed = rules.bedtools_bamtobed.output.bed
    output:
        bed = "data/dataset/blockbuster_bed/aligned.sortedByName.blockbuster.out.bed"
    log:
        "logs/bed_to_blockbuster.log"
    threads:
        1
    conda:
        "../envs/pypackages.yaml"
    script:
        "../bed_to_blockbuster.py"
