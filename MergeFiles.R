MergeFiles <- function(csv){
  for(i in seq(1, dim(csv)[1])) {
    filenames <- sprintf("%stable.csv", csv[i,1])
    excel <- sprintf("'%s file has been written'", csv[i, 1])
    vcf <- readVcf(sprintf("tmp_%s.BA1.vcf", csv[i, 1]))
    tsv <- read_tsv(sprintf("%s.tsv", csv$V1[i]),comment = "##") %>% dplyr::select(-`Location`)
    pi <- read.table(sprintf("tmp_%s_pi.sites.pi", csv[i, 1]), header= T)
    hwe <- read.table(sprintf("tmp_%sHardy.hwe", csv[i, 1]), header = T)
    
    tsv <- tsv %>% filter(Feature==csv[i,6])
    tsv <- tsv %>% dplyr::rename(rsID=`#Uploaded_variation`)
    
    rs<-data.frame(ranges(vcf))
    rs<-rs %>% dplyr::select(names,start)
    colnames(rs)<-c("rsID","POS")
    vcfinfo<-data.frame(info(vcf))
    vcfselect<- vcfinfo[14:27] 
    vcfselect<- subset(vcfselect,vcfselect$AC!=5008)
    vcftable<- data.frame(rs,vcfselect)
    
    vcfmerge <- data.frame(vcftable,hwe[,c("ChiSq_HWE","P_HWE","P_HET_DEFICIT","P_HET_EXCESS")],pi[,"PI"])
    
    if(is.null(opt$Fst==FALSE)) {
      Fst = read.table(sprintf("tmp_%sFst.weir.fst",csv[i, 1]), header =
                         TRUE)
      vcfmerge <- data.frame(vcfmerge,Fst[,"WEIR_AND_COCKERHAM_FST"])
    }
    
    merged_vcf <- vcfmerge %>% left_join(tsv)
    
    write.csv(merged_vcf,filenames)
    cat(excel)
    
  }
}