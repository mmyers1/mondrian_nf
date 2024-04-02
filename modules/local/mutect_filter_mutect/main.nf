process FILTERMUTECT {
    time '48h'
    cpus 12
    memory '12 GB'
    label 'process_high'

  input:
    path(reference)
    path(reference_fai)
    path(reference_dict)
    path(unfiltered_vcf)
    path(unfiltered_vcf_tbi)
    path(mutect_stats)
    path(contamination_table)
    path(maf_segments)
    path(artifact_priors_tar_gz)
    val(filename)
  output:
    path("${filename}.vcf.gz"), emit: vcf
    path("${filename}.vcf.gz.tbi"), emit: tbi
    path("${filename}.stats"), emit: stats
  script:
    """
        set -e
        gatk FilterMutectCalls -V ${unfiltered_vcf} \
            -R ${reference} \
            -O ${filename}.vcf.gz \
            -stats ${mutect_stats} \
            --ob-priors ${artifact_priors_tar_gz} \
            --contamination-table ${contamination_table} \
            --tumor-segmentation ${maf_segments} \
            --filtering-stats ${filename}.stats
    """
}
