#TABIX FUNCTION
VCFPULL = function(csv) {
  for (i in seq(1, dim(csv)[1])) {
    tabixcommand = sprintf("tabix -h ftp://ftp.ebi.ac.uk/1000g/ftp/release/20130502/ALL.chr%s.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz %s:%s-%s > %s.vcf", csv[i, 2], csv[i, 2], csv[i, 3], csv[i, 4], csv[i, 1])
    extractremark = sprintf("echo %s Extracted", csv[i, 1])
    system(tabixcommand)
    system(extractremark)
  }
}

#KEEPING ONLY BIALLELIC SNPS
BCFtools = function(csv) {
  for (i in seq(1, dim(csv)[1])) {
    bcfcommand = sprintf("bcftools view -m2 -M2 -q .0000001 %s.vcf >tmp_%s.BA1.vcf",
                         csv[i, 1],
                         csv[i, 1])
    system(bcfcommand)
  }
}


#VEP COMMAND
VEPPULL = function(csv) {
  for (i in seq(1, dim(csv)[1])) {
    vepcommand = sprintf(
      "vep --buffer_size 10000 --cache --check_existing --format vcf --gene_phenotype --input_file %s.vcf --offline --output_file %s.tsv --phased --polyphen b --pubmed --sift b --tab --total_length --variant_class --number --force_overwrite
      ",
      csv[i, 1],
      csv[i, 1]
    )
    system(vepcommand, ignore.stdout = TRUE)
  }
}
