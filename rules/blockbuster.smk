rule blockbuster:
    """ Find clusters """
    input:
        bed = rules.bed_to_blockbuster.output.bed
    output:
        block = "data/dataset/blockbuster/blockbuster.out.bed",
        clusters = "data/dataset/clusters/clusters.sorted.bed"
    log:
        "../logs/blockbuster.log"
    threads:
        12
    conda:
        "../envs/blockbuster.yaml"
    shell:
        "blockbuster.x -format 1"
        " -minBlockHeight 100"
        " -print 1"
        " -tagFilter 50"
        " {input.bed}"
        " > {output.block} &&"
        """
        grep -E '>' {output.block} | \
        awk '{{ print "chr"$2 "\t" $3 "\t" $4 "\t" $1 "\t" $6 "\t" $5}}' | \
        sort -k1,1 -k2,2n \
        > {output.clusters}
        """
