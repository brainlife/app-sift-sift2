#!/bin/bash

set -x
set -e

mkdir -p weights raw

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
reg_tikhonov=`jq -r '.reg_tikhonov' config.json` # numerical: default 0
reg_tv=`jq -r '.reg_tv' config.json` # numerical: default 0.1
min_td_frac=`jq -r '.min_td_frac' config.json` # numerical: default 0.1
min_iters=`jq -r '.min_iters' config.json` # numerical: default 10
max_iters=`jq -r '.max_iters' config.json` # nuemrical
min_factor=`jq -r '.min_factor' config.json` # numerical: default 0. CAN ONLY BE USED IF MIN_COEFF NOT USED
min_coeff=`jq -r '.min_coeff' config.json` # string: default -inf. CAN ONLY BE USED IF MIN_FACTOR NOT USED
max_factor=`jq -r '.max_factor' config.json` # string; default inf. CAN ONLY BE USED IF MAX_COEFF NOT USED
max_coeff=`jq -r '.max_coeff' config.json` # string: default inf. AN ONLY BE USED IF MAX_FACTOR NOT USED
max_coeff_step=`jq -r '.max_coeff_step' config.json` # numerical: default 1
min_cf_decrease=`jq -r '.min_cf_decrease' config.json` # numerical (fraction): default 0.000025
linear=`jq -r '.linear' config.json` # should be boolean
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

if [[ ! ${reg_tikhonov} == "0" ]]; then
	cmd=$cmd" -reg_tikhonov ${reg_tikhonov}"
fi

if [[ ! ${reg_tv} == "0.1" ]]; then
	cmd=$cmd" -reg_tv ${reg_tv}"
fi

if [[ ! ${min_td_frac} == "0.1" ]]; then
	cmd=$cmd" -min_td_frac ${min_td_frac}"
fi

if [[ ! ${min_iters} == "10" ]]; then
	cmd=$cmd" -min_iters ${min_iters}"
fi

if [[ ! ${max_iters} == null ]]; then
	cmd=$cmd" -max_iters ${max_iters}"
fi

if [[ ! ${min_factor} == "0" ]]; then
	cmd=$cmd" -min_factor ${min_factor}"
fi

if [[ ! ${min_coeff} == "-inf" ]]; then
	cmd=$cmd" -min_coeff ${min_coeff}"
fi

if [[ ! ${max_factor} == "inf" ]]; then
	cmd=$cmd" -max_factor ${max_factor}"
fi

if [[ ! ${max_coeff} == "inf" ]]; then
	cmd=$cmd" -max_coeff ${max_coeff}"
fi

if [[ ! ${max_coeff_step} == "1" ]]; then
	cmd=$cmd" -max_coeff_step ${max_coeff_step}"
fi

if [[ ! ${min_cf_decrease} == "2.5e-05" ]]; then
	cmd=$cmd" -min_cf_decrease ${min_cf_decrease}"
fi

# perform sift2
if [ ! -f ./weights/weights.csv ]; then
	echo "performing SIFT2 to identify streamlines weights"
	tcksift2 ${track} lmax${lmax}.mif weights.csv -act 5tt.mif -out_mu ./raw/mu.txt -csv ./raw/stats.csv -out_coeffs ./raw/coeffs.txt $cmd -nthreads ${ncores} -force -quiet

	# remove header row from mrtrix3 weights.csv file
	sed 1,1d ./weights.csv > tmp.csv
	tr -s ',' '\n'< ./tmp.csv >> ./weights/weights.csv
	rm -rf tmp.csv
	mv ./weights.csv ./raw/
fi

# error check
if [ -f ./weights/weights.csv ]; then
	echo "SIFT2 complete!"
	mv ./weights.csv *.mif ./raw/
else
	echo "something went wrong. check derivatives"
	exit 1
fi
