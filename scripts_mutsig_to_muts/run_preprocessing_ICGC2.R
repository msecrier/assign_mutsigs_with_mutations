library(MutationalPatterns)
library(data.table)
library(GenomicRanges)
library(BSgenome)
library("BSgenome.Hsapiens.UCSC.hg19")

setwd("/home/guidantoniomt/kate")

vcf<-as.data.frame(fread('simple_somatic_mutation.open.PRAD-CA.tsv'))

vcf<-vcf[vcf$mutation_type=='single base substitution',]

vcf_reduce<-vcf[,c('icgc_donor_id','chromosome','chromosome_start','reference_genome_allele','mutated_to_allele')]

list_samples<-NULL

myvcf2<-vcf_reduce
        
myvcf2<-myvcf2[myvcf2$reference_genome_allele!='-',]

myvcf2<-myvcf2[myvcf2$mutated_to_allele!='-',]


	if(length(which(myvcf2$reference_genome_allele == myvcf2$mutated_to_allele))!=0)

	{
	myvcf2<-myvcf2[-which(myvcf2$reference_genome_allele == myvcf2$mutated_to_allele),]
	}else{
	myvcf2<-myvcf2
	}
	        
	myvcf2_parse<-data.frame(SAMPLE=myvcf2[,'icgc_donor_id'],	
				 CHR=myvcf2[,'chromosome'],
				 POS=myvcf2[,'chromosome_start'],
				 REF=myvcf2[,'reference_genome_allele'],
				 ALT=myvcf2[,'mutated_to_allele'])

	triplets = as.character(getSeq(Hsapiens, paste("chr",myvcf2_parse$CHR,sep=""), start = myvcf2_parse$POS-1, end = myvcf2_parse$POS+1))

	myvcf2_parse<-unique(cbind(myvcf2_parse,triplets))

setwd("/home/guidantoniomt/kate/vcf_files")
	
write.table(myvcf2_parse,file="deconstructsigs.tsv",sep='\t',row.names=F,quote=F,col.names=T)
