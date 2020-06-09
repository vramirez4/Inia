#Nucleotide Diversity Command
PIPUll = function(csv) {
  for (i in seq(1, dim(csv)[1])) {
    PICOMMAND = sprintf(
      "vcftools --maf 0.000001 --vcf tmp_%s.BA1.vcf --site-pi --chr %s --out tmp_%s_pi",
      csv[i, 1],
      csv[i, 2],
      csv[i, 1]
    )
    system(PICOMMAND,
           ignore.stdout = TRUE)
  }
}



###Hardy Weinberg Command
HardyPull = function(csv) {
  for (i in seq(1, dim(csv)[1])) {
    HARDYCOMMAND = sprintf(
      "vcftools --maf 0.000001 --vcf tmp_%s.BA1.vcf --hardy --out tmp_%sHardy",
      csv[i, 1],
      csv[i, 1]
    )
    system(
      HARDYCOMMAND,
      ignore.stdout = TRUE
    )
  }
}

FSTPULL = function(csv) {
  for (i in seq(1, dim(csv)[1])) {
    FSTCOMMAND = sprintf(
      "vcftools --maf 0.000001 --vcf tmp_%s.BA1.vcf%s --out tmp_%sFst",
      csv[i, 1],
      weirsentence,
      csv[i, 1]
    )
    system(FSTCOMMAND, ignore.stdout = TRUE)
  }
}
