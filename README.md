# assign_mutsigs_with_mutations


# R-dependencies:
# To install all dependencies open a R shell

install.packages("data.table")

if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install(c("BSgenome","GenomicRanges","BSgenome","MutationalPatterns","BSgenome.Hsapiens.UCSC.hg19"))

# python-dependencies:
# To install all dependencies open a python shell

pip install gzip logging os import click pandas collections
