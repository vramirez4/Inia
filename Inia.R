#!/usr/bin/env Rscript

Rargs <- commandArgs(trailingOnly = FALSE)

if ("optparse" %in% rownames(installed.packages()) == FALSE) {
  install.packages("optparse", quiet = TRUE)
} else{
  system("echo \n")
}

suppressPackageStartupMessages(library(optparse))

system("echo \n")
system("echo \n")
system("echo \n")
system("echo '                                          .-          '")
system("echo '    ____  _  _  ____    __           .---`  `._       '")
system("echo '   (_  _)( \\( )(_  _)  /__\\       __/`-  _      `.    '")
system("echo '    _)(_  )  (  _)(_  /(__)\\     `-----`._`.----. \\    '")
system("echo '   (____)(_)\\_)(____)(__)(__)              `     \\;   '")
system("echo '                                                 ;_\\  '")
system("echo \n")
system("echo \n")
system("echo 'Welcome to Inia!'")
system("echo \n")
system("echo \n")
system("echo \n")
system("echo \n")

options_list = list(
  make_option(
    c("-i", "--input"),
    type = "character",
    default = NULL,
    help = "path to csv"
  ),
  make_option(
    c("-o", "--out"),
    type = "character",
    default = NULL,
    help = "path for output [default=%default]"
  ),
  make_option(
    c("-F", "--Fst"),
    type = "character",
    default = NULL,
    help = "Path to population file: See Documentation"
  )
)
opt_parser = OptionParser(option_list = options_list)
opt = parse_args(opt_parser)

#Set working directory to print out to
if (is.null(opt$out)) {
  system("echo Output will print in current directory")
  workingdirectory = getwd()
} else{
  workingdirectory = opt$out
}

filearg <- "--file="
filename <- sub(filearg, "", Rargs[grep(filearg, Rargs)])
filepath <- dirname(filename)

setwd(filepath)
source("CleanTemporaryFiles.R")
source("MergeFiles.R")
source("PopulationStats.R")
source("ExtractSnps.R")

if (is.null(opt$input)) {
  print_help(opt_parser)
  stop("Input file needs to be specified", call. = FALSE)
}


system("echo Checking installation of required R package")
system("echo \n")
system("echo \n")

if ("VariantAnnotation" %in% rownames(installed.packages()) == FALSE) {
  source("https://bioconductor.org/biocLite.R")
  biocLite('VariantAnnotation', suppressUpdates = TRUE)
} else {
  system("echo 'VariantAnnotation was previously installed'")
}

if ("tidyverse" %in% rownames(installed.packages()) == FALSE) {
  install.packages("tidyverse", quiet = TRUE)
} else{
  system("echo \n")
}

suppressPackageStartupMessages(library(VariantAnnotation))
suppressPackageStartupMessages(library(tidyverse))

setwd(workingdirectory)

GENEMAP = read.csv(opt$input, header = FALSE)
VCFPULL(GENEMAP)

system("echo \n")
system("echo \n")
system("echo Cleaning VCF Files")
BCFtools(GENEMAP)

#Let user Know the script is working
system("echo '\n'")

system("echo 'Initiating the Variant Effect Predictor'")
system("echo '\n'")
system("echo 'Accessing Functional Annotations and Predicting Variant Effects'")
system("echo '\n'")
VEPPULL(GENEMAP)

system("echo 'Variant Effect Prediction Is Completed")

PIPUll(GENEMAP)
HardyPull(GENEMAP)

#If a population file was supplied to Vcftools will be used to
#Compute the Wrights Fst
#Population Files will be made for each individual Population
if (is.null(opt$Fst)) {
  print("Fst will not be computed")
} else{
  POPFILE = read.csv(opt$Fst, header = TRUE)
  LEVELS = unique(POPFILE$Population)
  heads = POPFILE$ID
  weirsentence = ""
  for (i in seq(1, length(LEVELS))) {
    REFPOP = subset(POPFILE, POPFILE$Population == sprintf("%s", LEVELS[i]))
    in_POPFILE = c()
    for (j in REFPOP$ID) {
      indices = grep(j, heads)
      in_POPFILE = c(in_POPFILE, indices)
    }
    NEW = POPFILE$ID[in_POPFILE]
    NEWNAMES = data.matrix(NEW)
    
    write(
      NEWNAMES,
      sprintf("Population%s.txt", LEVELS[i]),
      ncolumns = 1,
      sep = '\n'
    )
    weirfst = sprintf("--weir-fst-pop Population%s.txt", LEVELS[i])
    weirsentence = paste(weirsentence, weirfst)
  }
  FSTPULL(GENEMAP)
}

##Read and Merge All resulting files
MergeFiles(GENEMAP)
system("echo \n")
system("echo \n")
system("echo \n")
system("echo 'Cleaning Files")

CleanFiles(GENEMAP)
system("echo \n")
system("echo \n")
system("echo \n")
system("echo 'Inia Has Finished You Analysis'")

