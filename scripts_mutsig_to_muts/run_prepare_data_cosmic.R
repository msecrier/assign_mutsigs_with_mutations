setwd('/home/guidantoniomt/kate/')
cosmic_table<-read.csv(file='sigProfiler_SBS_signatures_2019_05_22.csv')
cosmic_table2<-cosmic_table[,-c(1:2)]

start_context<-substr(cosmic_table$SubType,1,1)
end_context<-substr(cosmic_table$SubType,3,3)

MUTATIONS<-paste('[',cosmic_table$Type,']',sep='')
VARIANT_CLASS<-paste(start_context,MUTATIONS,end_context,sep='')
rownames(cosmic_table2)<-VARIANT_CLASS

signatures.cosmic<-cosmic_table2

save(signatures.cosmic,file="sigProfiler_SBS_signatures_2019_05_22.RData")

cosmic_table3<-data.frame(cosmic_table[,c(1:2)],VARIANT_CLASS,cosmic_table2)
colnames(cosmic_table3)[1:3]<-c("Substitution Type","Trinucleotide","Somatic Mutation Type")

write.table(cosmic_table3,file="signatures_probabilities.txt",sep="\t",row.names=F,quote=F)
