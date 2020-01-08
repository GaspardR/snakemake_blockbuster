rule download_bam:
    output:
        bam = "data/dataset/bam/aligned.out.bam"
    params:
        link = "https://zenodo.org/record/3256666/files/SRR5575709.aligned.out.bam"
    shell:
        "wget -O {output.bam} {params.link}"
