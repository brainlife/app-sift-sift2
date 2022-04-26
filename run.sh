#!/bin/bash

# set -x
# set -e

mkdir -p labels

#### configurable parameters ####
lmax2=`jq -r '.lmax2' config.json`
lmax4=`jq -r '.lmax4' config.json`
lmax6=`jq -r '.lmax6' config.json`
lmax8=`jq -r '.lmax8' config.json`
lmax10=`jq -r '.lmax10' config.json`
lmax12=`jq -r '.lmax12' config.json`
lmax14=`jq -r '.lmax14' config.json`
mask=`jq -r '.mask' config.json`
track=`jq -r '.track' config.json`
fd_scale_gm=`jq -r '.fd_scale_gm' config.json` # should be boolean
no_dilate_lut=`jq -r '.no_dilate_lut' config.json` # should be boolean
fd_thresh=`jq -r '.fd_thresh' config.json` # numerical
term_number=`jq -r '.term_number' config.json` # numerical: default null
term_ratio=`jq -r '.term_ratio' config.json` # numerical? default null
term_mu=`jq -r '.term_mu' config.json` # numerical: default null
lmax=`jq -r '.lmax' config.json`
ncores=8

#### convert data to mif ####
# fod
if [ ! -f lmax${lmax}.mif ]; then
	echo "converting fod"
	fod=$(eval "echo \$lmax${lmax}")
	mrconvert ${fod} lmax${lmax}.mif -force -nthreads ${ncores} -quiet
fi

# 5tt mask. need to set in case 5tt not provided
if ${act}; then
	if [ ! -f 5tt.mif ]; then
		echo "converting tissue-type image"
		mrconvert ${mask} 5tt.mif -force -nthreads ${ncores} -quiet
	fi
fi

#### perform SIFT2 to identify streamline weights ####
# identify additional optional boolean parameters
cmd=""
vars_to_loop="fd_scale_gm no_dilate_lut linear"
for i in ${vars_to_loop}
do
	tmp=$(eval "echo \$${i}")
	if [[ ${tmp} == true ]]; then
		cmd=$cmd" -${i}"
	fi
done

# go through advanced options. identify those that are different from defaults and append those values
if [[ ! ${fd_thresh} == "0" ]]; then
	cmd=$cmd" -fd_thresh ${fd_thresh}"
fi

if [[ ! ${term_number} == null ]]; then
	cmd=$cmd" -term_number ${term_number}"
fi

if [[ ! ${term_ratio} == null ]]; then
	cmd=$cmd" -term_ratio ${term_ratio}"
fi

if [[ ! ${term_mu} == null ]]; then
	cmd=$cmd" -term_mu ${term_mu}"
fi

# perform sift
if [ ! -f labels.txt ]; then
	echo "performing SIFT to filter streamlines"
	tcksift ${track} lmax${lmax}.mif weights.csv -act 5tt.mif -out_mu mu.txt -csv stats.csv -out_selection labels.txt $cmd -nthreads ${ncores} -force -quiet
	mu=`cat mu.txt`
	labels=`cat labels.txt`
fi



# if [ -f ./connectomes/count.csv ] && [ -f ./connectomes/length.csv ]; then
# 	echo "generation of connectomes is complete!"
# 	mv weights.csv assignments.csv ./connectomes/
#
# 	# need to convert csvs to actually csv and not space delimited
# 	for csvs in ./connectomes/*.csv
# 	do
# 		if [[ ! ${csvs} == './connectomes/centers.csv' ]]; then
# 			if [[ ${csvs} == './connectomes/assignments.csv' ]]; then
# 				sed 1,1d ${csvs} > tmp.csv
# 				cat tmp.csv > ${csvs}
# 				rm -rf tmp.csv
# 			fi
# 			sed -e 's/\s\+/,/g' ${csvs} > tmp.csv
# 			cat tmp.csv > ${csvs}
# 			rm -rf tmp.csv
# 		fi
# 	done
# 	for conmats in ${conmat_measures}
# 	do
# 		sed -e 's/\s\+/,/g' ./${conmats}_out/csv/correlation.csv > ./${conmats}_out/csv/tmp.csv
# 		cat ./${conmats}_out/csv/tmp.csv > ./${conmats}_out/csv/correlation.csv
# 		rm -rf ./${conmats}_out/csv/tmp.csv
# 	done
# else
# 	echo "something went wrong"
# fi
