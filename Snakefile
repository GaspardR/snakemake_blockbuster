__author__ = "Gaspard Reulet"
__email__ = "gaspard.reulet@usherbrooke.ca"
__license__ = "MIT"


include: "rules/downloads.smk"
include: "rules/flagstat.smk"
include: "rules/samtools_sort.smk"
include: "rules/bamtobed.smk"
include: "rules/bed_to_blockbuster.smk"
include: "rules/blockbuster.smk"


rule all:
    input:
        block="data/dataset/blockbuster/blockbuster.out.bed",
        clusters="data/dataset/clusters/clusters.sorted.bed",
        flagstat = "data/qc/aligned.out.bam.flagstat"


rule all_internet:
    input:
        bam = "data/dataset/bam/aligned.out.bam"
