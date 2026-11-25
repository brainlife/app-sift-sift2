[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-brainlife.app.615-blue.svg)](https://doi.org/10.25663/brainlife.app.615)

# Compute streamline weights using SIFT2

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

**Filters a whole-brain tractogram with MRtrix3 tcksift, removing streamlines until streamline densities match the FOD fibre densities, and outputs the filtered tractogram and surviving-streamline labels.**

Converts the CSD FOD of the chosen lmax and the 5tt image (generated from the T1w if not provided) and runs tcksift, stopping at the requested number of streamlines, termination ratio or proportionality coefficient. Use it to reduce tractography biases before connectomics; use SIFT2 instead to keep all streamlines and obtain weights.

Run it on brainlife.io: [https://doi.org/10.25663/brainlife.app.616](https://doi.org/10.25663/brainlife.app.616)

| Input | Datatype | Required | Description |
|---|---|---|---|
| `track` | `neuro/track/tck` | yes | path to the input tractogram |
| `csd` | `neuro/csd` | yes | paths to the individual FOD files |
| `mask` | `neuro/mask` (5tt_masks) | no | Five-tissue-type (5tt) segmentation used for anatomically constrained processing; generated from the T1w with MRtrix3 if not given. |
| `anat` | `neuro/anat/t1w` | no | Only required if no tissue-type mask datatype available |

| Output | Datatype | Description |
|---|---|---|
| `labels` | `neuro/labels` | label file containing the streamline indices that survived SIFT2 |
| `raw` | `raw` | contains the derivative files generated during the sift process, including the weights and proportionality coefficient and relative statistics files |
| `filtered` | `neuro/track/tck` | this contains the filtered tractogram. not automatically archived to save space and avoid redundant data objects |

| Parameter | Type | Default | Description |
|---|---|---|---|
| `lmax` | number | `8` | the spherical harmonic order (lmax) to use |
| `fd_scale_gm` | boolean | `true` | provide this option (in conjunction with -act) to heuristically downsize the fibre density estimates based on the presence of GM in the voxel. This can assist in reducing tissue interface effects when using a single-tissue deconvolution algorithm |
| `no_dilate_lut` | boolean | `false` | do NOT dilate FOD lobe lookup tables; only map streamlines to FOD lobes if the precise tangent lies within the angular spread of that lobe |
| `fd_thresh` | number | `0` | fibre density threshold; exclude an FOD lobe from filtering processing if its integral is less than this amount (streamlines will still be mapped to it, but it will not contribute to the cost function or the filtering) |
| `term_number` | number |  | number of streamlines - continue filtering until this number of streamlines remain |
| `term_ratio` | number |  | termination ratio - defined as the ratio between reduction in cost function, and reduction in density of streamlines. Smaller values result in more streamlines being filtered out. |
| `term_mu` | number |  | terminate filtering once the SIFT proportionality coefficient reaches a given value |
| `premask` | boolean | `false` | If the t1 has been masked already, set to true |

Runtime: container `brainlife/mrtrix3:3.0_RC3`; 4 CPUs; 40 GB memory; 3 h walltime.

Please cite:
- Tournier J-D, Smith RE, Raffelt D, et al. MRtrix3: A fast, flexible and open software framework for medical image processing and visualisation. NeuroImage 202:116137 (2019).
- Smith RE, Tournier J-D, Calamante F, Connelly A. The effects of SIFT on the reproducibility and biological accuracy of the structural connectome. NeuroImage 104:253-265 (2015).
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. Sci Data 6:69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

<!-- brainlife-app:end -->

This app will compute streamline weights from a wholebrain tractogram using SIFT2. The main output from this app, the streamlines-weight datatype, can be passed directly into structural connectivity generation apps.

### Authors

- Brad Caron (bacaron@utexas.edu)

### Contributors

- Soichi Hayashi (shayashi@iu.edu)

### Funding Acknowledgement

brainlife.io is publicly funded and for the sustainability of the project it is helpful to Acknowledge the use of the platform. We kindly ask that you acknowledge the funding below in your publications and code reusing this code.

[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-1636893](https://img.shields.io/badge/NSF_BCS-1636893-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-ACI-1916518](https://img.shields.io/badge/NSF_ACI-1916518-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1916518)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://grantome.com/grant/NIH/R01-EB029272-01)

### Citations

We kindly ask that you cite the following articles when publishing papers and code using this code.

1. Avesani, P., McPherson, B., Hayashi, S. et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. Sci Data 6, 69 (2019). https://doi.org/10.1038/s41597-019-0073-y

2. Tournier, J.-D.; Smith, R. E.; Raffelt, D.; Tabbara, R.; Dhollander, T.; Pietsch, M.; Christiaens, D.; Jeurissen, B.; Yeh, C.-H. & Connelly, A. MRtrix3: A fast, flexible and open software framework for medical image processing and visualisation. NeuroImage, 2019, 202, 116137

3. Smith, R. E.; Tournier, J.-D.; Calamante, F. & Connelly, A. The effects of SIFT on the reproducibility and biological accuracy of the structural connectome. NeuroImage, 2015, 104, 253-265

4. Smith, R. E.; Tournier, J.-D.; Calamante, F. & Connelly, A. SIFT2: Enabling dense quantitative assessment of brain white matter connectivity using streamlines tractography. NeuroImage, 2015, 119, 338-351

5. Smith, RE; Raffelt, D; Tournier, J-D; Connelly, A. Quantitative Streamlines Tractography: Methods and Inter-Subject Normalisation. Open Science Framework, https://doi.org/10.31219/osf.io/c67kn.

#### MIT Copyright (c) 2020 brainlife.io The University of Texas at Austin and Indiana University

## Running the App

### On Brainlife.io

You can submit this App online at [https://doi.org/10.25663/brainlife.app.615](https://doi.org/10.25663/brainlife.app.615) via the 'Execute' tab.

### Running Locally (on your machine)

1. git clone this repo

2. Inside the cloned directory, create `config.json` with something like the following content with paths to your input files.

```json
{
    "track": "/input/track/track.tck",
    "lmax2": "/input/csd/lmax2.nii.gz",
    "lmax4": "/input/csd/lmax4.nii.gz",
    "lmax6": "/input/csd/lmax6.nii.gz",
    "lmax8": "/input/csd/lmax8.nii.gz",
    "lmax10": "/input/csd/lmax10.nii.gz",
    "lmax12": "/input/csd/lmax12.nii.gz",
    "lmax14": "/input/csd/lmax14.nii.gz",
    "mask": "/input/mask/mask.nii.gz",
    "lmax": 8,
    "fd_scale_gm": true,
    "no_dilate_lut": false,
    "linear": false,
    "fd_thresh": 0,
    "reg_tikhonov": 0,
    "reg_tv": 0.1,
    "min_td_frac": 0.1,
    "min_iters": 10,
    "max_iters": null,
    "min_factor": "0",
    "min_coeff": "-inf",
    "max_factor": "inf",
    "max_coeff": "inf",
    "max_coeff_step": 1,
    "min_cf_decrease": 0.000025
}
```

### Sample Datasets

You can download sample datasets from Brainlife using [Brainlife CLI](https://github.com/brain-life/cli).

```
npm install -g brainlife
bl login
mkdir input
bl dataset download
```

3. Launch the App by executing 'main'

```bash
./main
```

## Output

The main output of this App is a raw datatype containing all of the statistics and derivatives generated during this app, and a streamline-weights datatype containing the weights from SIFT2 for each streamline.

#### Product.json

The secondary output of this app is `product.json`. This file allows web interfaces, DB and API calls on the results of the processing.

### Dependencies

This App only requires [singularity](https://www.sylabs.io/singularity/) to run. If you don't have singularity, you will need to install following dependencies.   

- MRTrix3: https://www.mrtrix.org/

#### MIT Copyright (c) 2020 brainlife.io The University of Texas at Austin and Indiana University
