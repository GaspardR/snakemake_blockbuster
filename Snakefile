__author__ = "Gaspard Reulet"
__email__ = "gaspard.reulet@usherbrooke.ca"

rule all:
    input:
        block="data/dataset/blockbuster/blockbuster.out.bed",
        clusters="data/dataset/clusters/clusters.sorted.bed",
        flagstat = "data/qc/aligned.out.bam.flagstat"


rule all_internet:
    input:
        bam = "data/dataset/bam/aligned.out.bam"

rule download_bam:
    output:
        bam = "data/dataset/bam/aligned.out.bam"
    params:
        link = "https://zenodo.org/record/3256666/files/SRR5575709.aligned.out.bam"
    shell:
        "wget -o {output.bam} {params.link}"


rule flagstat:
    input:
        rules.download_bam.output.bam
    output:
        "data/qc/aligned.out.bam.flagstat"
    wrapper:
        "0.35.0/bio/samtools/flagstat"


rule samtools_sort:
    input:
        rules.download_bam.output.bam
    output:
        "data/dataset/sorted/aligned.sortedByName.out.bam"
    params:
        "-n"
    log:
        "logs/samtools.log"
    threads:
        12
    wrapper:
        "0.34.0/bio/samtools/sort"


rule bedtools_bamtobed:
    input:
        bam = rules.samtools_sort.output
    output:
        bed = "data/dataset/bamtobed/aligned.sortedByName.out.bed"
    conda:
        "envs/bedtools.yaml"
    threads:
        12
    log:
        "logs/bedtools.log"
    shell:
        "bedtools bamtobed -i {input.bam} > {output.bed}"


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
        "envs/pypackages.yaml"
    script:
        "bed_to_blockbuster.py"


rule blockbuster:
    """ Find clusters """
    input:
        bed = rules.bed_to_blockbuster.output.bed
    output:
        block = "data/dataset/blockbuster/blockbuster.out.bed",
        clusters = "data/dataset/clusters/clusters.sorted.bed"
    log:
        "logs/blockbuster.log"
    threads:
        12
    conda:
        "envs/blockbuster.yaml"
    shell:
        "blockbuster.x -format 1 "
        "-minBlockHeight 100 "
        "-print 1 "
        "-tagFilter 50 "
        "{input.bed} "
        "> {output.block} && "
        """
        grep -E '>' {output.block} | \
        awk '{{ print "chr"$2 "\t" $3 "\t" $4 "\t" $1 "\t" $6 "\t" $5}}' | \
        sort -k1,1 -k2,2n \
        > {output.clusters}
        """
