#REMOVE TEMPORARY FILES CREATED BY VCFTOOLS
CleanFiles=function(csv) {
  for (i in seq(1, dim(csv)[1])) {
    cleaner = sprintf("rm -r tmp_%s*", csv[i, 1])
    system(cleaner, ignore.stdout = TRUE)
  }
}