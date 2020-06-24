#!/usr/bin/env bash

# Run DeconstructSigs over a set of mutation files and
# assign to each mutation the most probable signature
# The process is:
# - preprocess the mutations data to generate the format required by *deconstructsigs*
# - use *deconstructsigs* to compute the weights of each sample for each signature
# - compute the most probable signature contributing to each mutation


this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

echo $this_dir

mutations_folder="$1"
output_folder="$2"
sequencing="$3"
path_cosmic="$4"


# This part can be parallelized
for mut_file in ${mutations_folder}/*.tsv

do

    mkdir -p ${output_folder}

    deconstructsigs_infile=${mutations_folder}/deconstructsigs.tsv
    deconstructsigs_outfile=${output_folder}/signatures_weight.tsv

    # Prepare the file
    # python ${this_dir}/fmt.py ${mut_file} ${deconstructsigs_infile}
    # ret=$?
    # if [ $ret -eq 3 ]
    # then
    #     echo "File ${mut_file} does not have enough mutations in any sample"
    #     continue
    #fi

    # Run analysis
    #Rscript ${this_dir}/deconstructSigs.r ${deconstructsigs_infile} ${deconstructsigs_outfile} ${sequencing} ${path_cosmic}

    # Assing mutations
    #python ${this_dir}/assign.py ${deconstructsigs_infile} ${deconstructsigs_outfile} signatures_probabilities.txt ${output_folder}
    echo $deconstructsigs_infile
    echo $deconstructsigs_outfile
    python ${this_dir}/assign.py ${deconstructsigs_infile} ${deconstructsigs_outfile} /home/guidantoniomt/kate/signatures_probabilities.txt ${output_folder}

done

