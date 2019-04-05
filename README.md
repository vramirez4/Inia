# Inia: Scripts for Exploring Local Regions From the 1000 Genomes Project

Population genetic analyses of local genomic regions shed important light on the evolutionary and demographic processes shaping human diversity. By revealing pressures exerted on specific genes and functional domains they illuminate the origins of genotypic and phenotypic variation. Inia facilitates the investigation of localized genomic regions by providing tools to extract, organize, and summarize variants in the 1000 Genomes Project catalogue, one of the largest whole-genome sequence database currently available. Given an input file specifying genes and regions to be analyzed, Inia automatically extracts and integrates 1000 Genomes data with information on functional effects catalogued in the Ensembl database (via Ensembl VEP) and computes population genetic statistics including allele frequencies, heterozygosity, genetic distance between populations (Fst), and Hardy-Weinberg equilibrium. Inia‘s output provides further summary information consisting of site by site annotations of genomic features such as exon number, codon and amino acid changes, functional effects predicted by SIFT and PolyPhen2 scores, catalogued clinical relevance of the coding variants via ClinVar, and occurrences of the variant in the literature via PubMed. Thus, Inia provides a rapid yet comprehensive overview of variation in any genomic region.


# Installation Instructions

The following installation is intended for users using Ubuntu Xenial 16.04 with a previous installation of Perl installed. Installation in other flavors of Linux , MacOS/OSX are possible. This can be accomplished using Homebrew (MacOS/OSX) or Anaconda (Linux,Mac).
1)	Open Terminal

2)	Install vcftools using sudo apt install vcftools

3)	Install samtools using sudo apt install samtools

4)	Install tabix using sudo apt install tabix

5)	Install the git utility using sudo apt install git

6)	Install the Perl DBI module using sudo apt install libdbi-perl

7)	If necessary install the libcurl module using sudo apt-get install libcurl4-openssl-dev

8)	If necessary install the xml2-config module using sudo apt-get install libxml2-dev

9)	Install the variant effect predictor from the Ensembl repository

      a.	git clone https://github.com/Ensembl/ensembl-vep.git
      
      b.	cd ensembl-vep/
      
      c.	perl INSTALL.pl –-NO_HTSLIB
      
      d.	Follow the input command prompts during installation
      
      e.	Install cache using homo_sapiens_vep_90_GRCh37.tar.gz or species file number 59. This will take some time.
      
      f.	Set the path to the ./vep command using: export PATH=$PATH:/path_to_vep
      
      g.	Add step 4 to the /.profile file
      
10)	Install R from the CRAN repository using the following instructions:

      a.	Add a line to the “etc/apt/sources.list” file with the following code (for other versions of Ubuntu change the version “Xenial” to your appropriate version”) sudo echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" | sudo tee -a /etc/apt/sources.list.
      
      b.	Add R to the ubuntu keyring using the following:
      
          i.	gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
          
          ii.	gpg -a --export E084DAB9 | sudo apt-key add -
          
      c.	Install R-base
      
          i.	sudo apt-get update
          
          ii.	sudo apt-get install r-base r-base-dev
    
    
# Usage of Tool:

Inia_Genomic_Toolkit.R [options]

--input -i Gene Coordinates csv

--Fst -F Population File

--out -o Directory for output

Rscript ~/path_to_tool/ -i ~/path_to_genecoordinates_file –F ~/path_to_population_file –o ~/path_to_desired_output

# Example:

mkdir ~/IniaOutput

Inia_Genomic_Toolkit.R -i ~/Inia_Genomic_Toolkit/TAS2RMAP.csv -o ~/IniaOutput -F ~/Inia_Genomic_Toolkit/Populations.csv
