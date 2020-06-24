
args = commandArgs(trailingOnly=TRUE)

## load libraries
library(deconstructSigs)
library(gplots)

# read the cancer type name
input_file=args[1]
output_file=args[2]
seq_type=args[3]
path_cosmic=args[4]

print(input_file)

load(path_cosmic)

# define which type of count we should be using!
if (seq_type == 'wes') {
    counts_method <- 'exome2genome'
} else {
    counts_method <- 'default'
}

x<-read.table(input_file, header=T, sep="\t")
names(x) <- c("Sample","chr","pos","ref","alt","mutation")

print("mut.to.sigs.input step")

# Convert to deconstructSigs input
# this step generates the matrix suitable for the program
sigs.input <- mut.to.sigs.input(mut.ref = x, 
                                sample.id = "Sample", 
                                chr = "chr", 
                                pos = "pos", 
                                ref = "ref", 
                                alt = "alt")

# remove samples with few mutations
samples_to_save <- rownames(sigs.input[apply(sigs.input,1,sum) >= 50,])

# now we run deconstructSigs for each sample in our input list
flag = 0

list_samples<-intersect(samples_to_save,unique(x$Sample))

sigs.input<-sigs.input[rownames(sigs.input)%in%list_samples,]

print(dim(sigs.input))
print(dim(signatures.cosmic))
print(counts_method)

for (sample in list_samples)
{
  print(sample)

  test = whichSignatures(tumor.ref = sigs.input,
                           signatures.ref = as.data.frame(t(signatures.cosmic)),
                           sample.id = sample,
                           contexts.needed = TRUE,
                           tri.counts.method = counts_method,
                           signature.cutoff = 0)

    a = test$weights # save the weights for each signature.
    a['SSE']  = round(sqrt(sum(test$diff * test$diff)), digits = 3) # compute the error rate
    a['mutation_count'] = nrow(x[which(x$Sample==sample),]) # number of mutations
    # append the results of each sample in to dataframe
    if (flag == 0){total = a; flag=1}
    else{total <- rbind(total, a)}
}

# prepare CSV file
myDF <- cbind(sample_id = rownames(total), total) # assign row names
rownames(myDF) <- NULL

print("write output")
# write the output to a file
write.table(myDF, file=output_file, sep="\t", col.names = TRUE, row.names=FALSE)
