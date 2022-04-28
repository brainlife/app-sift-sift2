#!/bin/bash

anat=`jq -r '.anat' config.json`
premask=`jq -r '.premask' config.json`
ncores=4

[ ! -f anat.mif ] && mrconvert ${anat} anat.mif -nthreads ${ncores} -quiet -force

if [[ ${premask} == true ]]; then
  [ ! -f 5tt.mif ] && 5ttgen fsl anat.mif 5tt.mif -premasked -nocrop -sgm_amyg_hipp -tempdir ./tmp -force -nthreads ${ncores} -quiet
else
  [ ! -f 5tt.mif ] && 5ttgen fsl anat.mif 5tt.mif -nocrop -sgm_amyg_hipp -tempdir ./tmp -force -nthreads ${ncores} -quiet
fi
