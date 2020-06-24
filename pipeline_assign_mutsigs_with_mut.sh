#
#  Step1: Prepare Cosmic data
#

# Input files:
# - A table with the COSMIC signatures (e.g. sigProfiler_SBS_signatures_2019_05_22.csv)
# Output files:
# - An .RData object with the COSMIC signatures (e.g. sigProfiler_SBS_signatures_2019_05_22.RData)
 - A parsed table with the COSMIC signatures (default output name: signatures_probabilities.txt)

working_dir=$(pwd) # users can remove this line and change manually the code

Rscript $working_dir/scripts_mutsig_to_muts/run_prepare_data_cosmic.R

#
#  Step2: Pre-processing ICGC data, perform the pre-processing of variants file on ICGC
#

# Input files:
# - vcf with the variants
# Output files:
# - a tab-delimited file  (deconstructsigs.tsv) with this format: ID, chr, start, REF, ALT (input for deconstructsigs)

Rscript $working_dir/scripts_mutsig_to_muts/run_preprocessing_ICGC2.R


#
# Step2: Run deconstructsigs and assign each mutational signature with each mutation
#

# Input files:
# directory with input file for deconstructSigs (e.g. /home/guidantoniomt/kate/vcf_files), The file in this foIDlder must be in .tsv format
# directory with output deconstructSigs (e.g. /home/guidantoniomt/kate/output_assignment)
# tri.counts.method for deconstructSigs (possible values: default, exome2genome)
# path to cosmic RData (e.g. /home/guidantoniomt/kate/sigProfiler_SBS_signatures_2019_05_22.RData)

# Output files:
# - for each samples the weights computed for each signature
# - for each mutational signature a .txt table (e.g. SBS15.tsv) with this format: chr, start, REF, ALT, patient_id

sh $working_dir/scripts_mutsig_to_muts/deconstructsigs.sh /home/guidantoniomt/kate/vcf_files /home/guidantoniomt/kate/output_assignment default /home/guidantoniomt/kate/sigProfiler_SBS_signatures_2019_05_22.RData

