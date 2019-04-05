MergeFiles=function(csv){
  for(i in seq(1, dim(csv)[1])) {
    if (is.null(opt$Fst) == FALSE) {
      GeneFST = read.table(sprintf("tmp_%sFst.weir.fst", csv[i, 1]), header =
                             TRUE)
    }
    excel = sprintf("echo '%s file has been written'", csv[i, 1])
    filenames = sprintf("%stable.csv", csv$V1[i])
    GenePI = read.table(sprintf("tmp_%s_pi.sites.pi", csv[i, 1]), header =
                          TRUE)
    GeneHardy = read.table(sprintf("tmp_%sHardy.hwe", csv[i, 1]), header =
                             TRUE)
    vcf = readVcf(sprintf("tmp_%s.BA1.vcf", csv[i, 1]), 'hg19')
    vcftable = read.table(sprintf("tmp_%s.BA1.vcf", csv[i, 1]))
    vcftable2 = data.frame(info(vcf))
    vcftable2_1 = vcftable2[14:27]
    rspositions = start(vcf)
    rspositions = data.frame(rspositions)
    vcftable3 = data.frame(c(rspositions, vcftable[4:5], vcftable2_1))
    rownames(vcftable3) = rownames(vcftable2)
    vcftable3 = subset(vcftable3, vcftable3$AC != 5008)
    numline = system(sprintf("grep '##' %s.tsv -c", csv[i, 1]), intern = TRUE)
    vep = read.table(
      sprintf("%s.tsv", csv[i, 1]),
      comment.char = "",
      skip = numline,
      header = TRUE
    )
    Genevep = subset(vep,
                     vep$Gene == sprintf('%s', csv[i, 6]) &
                       vep$Feature == (sprintf('%s', csv[i, 7])))
    #Select functional predictions
    Highimpact = c(grep("HIGH*", Genevep$IMPACT))
    Moderate = c(grep("MODERATE*", Genevep$IMPACT))
    Low = c(grep("LOW*", Genevep$IMPACT))
    
    #Append Sites
    HighSIFT = c(Highimpact, Moderate, Low)
    HighSIFT = sort(HighSIFT)
    HighSIFT = HighSIFT[!duplicated(HighSIFT)]
    #Append Sites
    
    
    GeneHighimpact = data.frame()
    #Retrieve variant rsIDs and info for high impact predicitons
    for (i in HighSIFT) {
      GeneHighimpact <- rbind(GeneHighimpact, data.frame(Genevep[i, ]))
    }
    GeneHighimpact = GeneHighimpact[!duplicated(GeneHighimpact$X.Uploaded_variation), ]
    if (length(GeneHighimpact) > 0) {
      GeneHighimpact = data.frame(GeneHighimpact[2:31], row.names = GeneHighimpact$X.Uploaded_variation)
    } else{
      GeneHighimpact = GeneHighimpact
    }
    
    #Read the vcf to extract genotype data for all variation
    #read the vcf and make a table
    #extract info field from vcf
    
    #take only what is needed
    #merge info fields and and genotypes
    
    
    #Chromosomal Positions Data Frame
    #Join dataframes to have clean table of vcfdata
    vcftable4 = cbind(vcftable3, GenePI$PI)
    if (is.null(opt$Fst)) {
      colnames(vcftable4)[1] <- 'POS'
      colnames(vcftable4)[2] <- 'REF'
      colnames(vcftable4)[3] <- 'ALT'
      vcftable4 = cbind(vcftable4, GeneHardy[5:6])
      if (length(GeneHighimpact) > 0)
        Genemerge = merge(vcftable4, GeneHighimpact, by = 0, sort = FALSE)
      else
        Genemerge = vcftable4
      write.csv(Genemerge, filenames)
    } else{
      vcftable4 = cbind(vcftable4, GeneFST$WEIR_AND_COCKERHAM_FST)
      colnames(vcftable4)[1] <- 'POS'
      colnames(vcftable4)[2] <- 'REF'
      colnames(vcftable4)[3] <- 'ALT'
      vcftable4 = cbind(vcftable4, GeneHardy[5:6])
      if (length(GeneHighimpact) > 0)
        Genemerge = merge(vcftable4, GeneHighimpact, by = 0, sort = FALSE)
      else
        Genemerge = vcftable4
      write.csv(Genemerge, filenames)
      system(excel)
    }
  }
}