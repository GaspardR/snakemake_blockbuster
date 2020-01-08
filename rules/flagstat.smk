
rule flagstat:
    input:
        rules.download_bam.output.bam
    output:
        "data/qc/aligned.out.bam.flagstat"
    conda:
        "../envs/samtools.yaml"
    shell:
        "samtools flagstat {input} > {output}"
