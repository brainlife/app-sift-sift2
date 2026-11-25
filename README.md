<h1 align="center">SIFT and SIFT2 for whole-brain tractograms</h1>

<p align="center">
  A filtered tractogram (SIFT) or per-streamline weights (SIFT2) that make streamline densities match the fibre densities of the FODs, with MRtrix3.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/brainlife.app.615"><img src="https://img.shields.io/badge/Brainlife-brainlife.app.615-blue.svg" alt="Run on brainlife.io"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="MIT license"></a>
</p>

> 📍 **This branch, `sift2-v1.0`, is the brainlife.io App Compute streamline weights using SIFT2** ([doi:10.25663/brainlife.app.615](https://doi.org/10.25663/brainlife.app.615)). The other Apps in this repository are listed under **Versions on brainlife.io** below.

## 🧠 At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Computes per-streamline weights for a whole-brain tractogram with MRtrix3 tcksift2, using the FOD and a 5-tissue-type mask, so streamline counts match the underlying fibre densities.**

Converts the CSD FOD of the chosen lmax and the 5tt image (generated from the T1w if not provided) and runs tcksift2 with the given regularisation and convergence settings. The resulting streamline-weights file can be passed directly to structural connectivity Apps. Use it after tractography with the same FOD; unlike SIFT it keeps every streamline.

| | |
|---|---|
| 📥 **Inputs** | `neuro/track/tck` · `neuro/csd` · `neuro/mask` (optional) · `neuro/anat/t1w` (optional) |
| 📤 **Outputs** | `neuro/streamline-weights` · `raw` |
| 🐳 **Container** | `brainlife/mrtrix3:3.0_RC3` |
| ⚙️ **Resources** | 4 CPUs · 40 GB memory · 3 h walltime |
| 🔗 **Run it** | [doi.org/10.25663/brainlife.app.615](https://doi.org/10.25663/brainlife.app.615) |

#### 📥 Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `track` | `neuro/track/tck` | yes | path to the input tractogram |
| `csd` | `neuro/csd` | yes | paths to the individual FOD files |
| `mask` | `neuro/mask` (5tt_masks) | no | Five-tissue-type (5tt) segmentation used for anatomically constrained processing; generated from the T1w with MRtrix3 if not given. |
| `anat` | `neuro/anat/t1w` | no | This is only needed if a tissue type mask (5tt) was not inputted. Will generate internally with this T1 |

#### 📤 Outputs

| Output | Datatype | Description |
|---|---|---|
| `weights` | `neuro/streamline-weights` | weights file containing the weights for each streamline from SIFT2 |
| `raw` | `raw` | contains the derivative files generated during the sift process, including the weights and proportionality coefficient and relative statistics files |

<details>
<summary><b>⚙️ Parameters</b> (17)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `lmax` | number | `8` | the spherical harmonic order (lmax) to use |
| `fd_scale_gm` | boolean | `true` | provide this option (in conjunction with -act) to heuristically downsize the fibre density estimates based on the presence of GM in the voxel. This can assist in reducing tissue interface effects when using a single-tissue deconvolution algorithm |
| `no_dilate_lut` | boolean | `false` | do NOT dilate FOD lobe lookup tables; only map streamlines to FOD lobes if the precise tangent lies within the angular spread of that lobe |
| `linear` | boolean | `false` | perform a linear estimation of streamline weights, rather than the standard non-linear optimisation (typically does not provide as accurate a model fit; but only requires a single pass) |
| `fd_thresh` | number | `0` | fibre density threshold; exclude an FOD lobe from filtering processing if its integral is less than this amount (streamlines will still be mapped to it, but it will not contribute to the cost function or the filtering) |
| `reg_tikhonov` | number | `0` | provide coefficient for regularising streamline weighting coefficients (Tikhonov regularisation) (default: 0) |
| `reg_tv` | number | `0.1` | provide coefficient for regularising variance of streamline weighting coefficient to pixels along its length (Total Variation regularisation) (default: 0.1) |
| `min_td_frac` | number | `0.1` | minimum fraction of the FOD integral reconstructed by streamlines; if the reconstructed streamline density is below this fraction, the pixel is excluded from optimisation (default: 0.1) |
| `min_iters` | number | `10` | minimum number of iterations to run before testing for convergence; this can prevent premature termination at early iterations if the cost function increases slightly (default: 10) |
| `max_iters` | number |  | maximum number of iterations to run before terminating program |
| `min_factor` | string | `0` | minimum weighting factor for an individual streamline; if the factor falls below this number the streamline will be rejected entirely (factor set to zero) (default: 0) |
| `min_coeff` | string | `-inf` | minimum weighting coefficient for an individual streamline; similar to the ‘-min_factor’ option, but using the exponential coefficient basis of the SIFT2 model; these parameters are related as: factor = e^(coeff). Note that the -min_factor and -min_coeff options are mutually exclusive - you can only provide one. (default: -inf) |
| `max_factor` | string | `inf` | maximum weighting factor that can be assigned to any one streamline (default: inf) |
| `max_coeff` | string | `inf` | maximum weighting coefficient for an individual streamline; similar to the ‘-max_factor’ option, but using the exponential coefficient basis of the SIFT2 model; these parameters are related as: factor = e^(coeff). Note that the -max_factor and -max_coeff options are mutually exclusive - you can only provide one. (default: inf) |
| `max_coeff_step` | number | `1` | maximum change to a streamline’s weighting coefficient in a single iteration (default: 1) |
| `min_cf_decrease` | number | `2.5e-05` | minimum decrease in the cost function (as a fraction of the initial value) that must occur each iteration for the algorithm to continue (default: 2.5e-05) |
| `premask` | boolean | `false` | If T1 has already been masked, set to true |

</details>

<!-- brainlife-app:end -->

## 🏷️ Versions on brainlife.io

This repository hosts two Apps, each built from its own branch. Both are maintained.

| App | MRtrix3 command | Branch | Run it | Status |
|---|---|---|---|---|
| Filter Streamlines using SIFT | `tcksift` | [`sift-v1.0`](https://github.com/brainlife/app-sift-sift2/tree/sift-v1.0) | [doi:10.25663/brainlife.app.616](https://doi.org/10.25663/brainlife.app.616) | current |
| **Compute streamline weights using SIFT2** (this branch) | `tcksift2` | [`sift2-v1.0`](https://github.com/brainlife/app-sift-sift2/tree/sift2-v1.0) | [doi:10.25663/brainlife.app.615](https://doi.org/10.25663/brainlife.app.615) | current |

## 🚀 Running the App

### ☁️ On brainlife.io

Both Apps take a whole-brain tractogram (`neuro/track/tck`), the CSD FODs it was made from (`neuro/csd`, with `lmax` selecting the order to use) and a five-tissue-type mask (`neuro/mask`, `5tt_masks`) for anatomically-constrained processing. Without a 5TT mask, give a T1-weighted image instead and the App makes one with `5ttgen fsl` (set `premask` if the T1 is already skull-stripped).

- **SIFT** ([doi.org/10.25663/brainlife.app.616](https://doi.org/10.25663/brainlife.app.616)) removes streamlines until the streamline densities match the FOD fibre densities. Stop it early with `term_number` (streamlines to keep), `term_ratio` or `term_mu`. It outputs the filtered tractogram (not archived automatically, to save space), a `neuro/labels` dataset with the indices of the surviving streamlines, and a `raw` dataset of statistics.
- **SIFT2** ([doi.org/10.25663/brainlife.app.615](https://doi.org/10.25663/brainlife.app.615)) keeps every streamline and computes a weight for each. Its `neuro/streamline-weights` output can be passed directly to structural connectivity Apps. The advanced options (`reg_tikhonov`, `reg_tv`, `min_td_frac`, `min_iters`, `max_iters`, `min_factor`/`min_coeff`, `max_factor`/`max_coeff`, `max_coeff_step`, `min_cf_decrease`, `linear`) map directly to `tcksift2` options and are passed only when they differ from the MRtrix3 defaults.

Both share `fd_scale_gm` (on by default), `no_dilate_lut` and `fd_thresh`.

### 💻 Locally

You need [Singularity/Apptainer](https://apptainer.org/) and [`jq`](https://jqlang.github.io/jq/). The Apps run `tcksift`/`tcksift2` from `brainlife/mrtrix3:3.0.3`, and `5ttgen` from `brainlife/mrtrix3:3.0_RC3` when a 5TT mask has to be made.

1. Clone this repository and check out the App you want (`git checkout sift-v1.0` or `git checkout sift2-v1.0`).
2. Create `config.json`. For SIFT2:

   ```json
   {
       "track": "/input/track/track.tck",
       "lmax2": "/input/csd/lmax2.nii.gz",
       "lmax4": "/input/csd/lmax4.nii.gz",
       "lmax6": "/input/csd/lmax6.nii.gz",
       "lmax8": "/input/csd/lmax8.nii.gz",
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

   For SIFT, use the same `track`, `lmax*`, `mask`, `lmax`, `fd_scale_gm`, `no_dilate_lut` and `fd_thresh` keys, plus `term_number`, `term_ratio` and `term_mu` (`null` to leave unset). To have the 5TT mask made for you, replace `mask` with `"anat": "/input/t1/t1.nii.gz"` and `"premask": false`.

3. Run the App:

   ```bash
   ./main
   ```

### 🧪 Sample data

Download sample datasets from brainlife.io with the [brainlife CLI](https://github.com/brainlife/cli):

```bash
npm install -g brainlife
bl login
mkdir input
bl dataset download <dataset-id>
```

## 📦 Outputs

SIFT:

```text
filtered/track.tck   filtered tractogram
labels/index.csv     selection of the input streamlines that survived (-out_selection)
raw/                 mu.txt, stats.csv and the intermediate .mif images
```

SIFT2:

```text
weights/weights.csv  one weight per streamline, one per line
raw/                 mu.txt, stats.csv, coeffs.txt, MRtrix3's original weights.csv and the .mif images
```

## 🩺 Troubleshooting

- **`missing tissue-type mask datatype and anat/t1w datatype. this is required to perform sift. please input either of the two`**: provide a 5TT tissue-type mask or a T1-weighted image.
- **`something went wrong. check derivatives`** (SIFT2): `weights/weights.csv` was not written. Check the log for the `tcksift2` error, and that the tractogram, FODs and mask share the same space.

## 📚 Citing

> [!TIP]
> If you use this App in your work, please cite the App, the software it builds on and brainlife.io (below). GitHub's **Cite this repository** button gives the App citation in APA and BibTeX.

If you use these Apps, please cite MRtrix3, SIFT or SIFT2, and brainlife.io:

- Tournier J-D, Smith RE, Raffelt D, Tabbara R, Dhollander T, Pietsch M, Christiaens D, Jeurissen B, Yeh C-H, Connelly A. MRtrix3: A fast, flexible and open software framework for medical image processing and visualisation. *NeuroImage* 202:116137 (2019).
- Smith RE, Tournier J-D, Calamante F, Connelly A. The effects of SIFT on the reproducibility and biological accuracy of the structural connectome. *NeuroImage* 104:253–265 (2015).
- Smith RE, Tournier J-D, Calamante F, Connelly A. SIFT2: Enabling dense quantitative assessment of brain white matter connectivity using streamlines tractography. *NeuroImage* 119:338–351 (2015).
- Smith RE, Raffelt D, Tournier J-D, Connelly A. Quantitative Streamlines Tractography: Methods and Inter-Subject Normalisation. *Open Science Framework*. [doi:10.31219/osf.io/c67kn](https://doi.org/10.31219/osf.io/c67kn)
- Compute streamline weights using SIFT2. brainlife.io App. [doi:10.25663/brainlife.app.615](https://doi.org/10.25663/brainlife.app.615)
- Tournier J-D, Smith RE, Raffelt D, et al. MRtrix3: A fast, flexible and open software framework for medical image processing and visualisation. NeuroImage 202:116137 (2019).
- Smith RE, Tournier J-D, Calamante F, Connelly A. The effects of SIFT on the reproducibility and biological accuracy of the structural connectome. NeuroImage 104:253-265 (2015).
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. Sci Data 6:69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)
- Tournier et al. MRtrix3: A fast, flexible and open software framework for medical image processing and visualisation. *NeuroImage* 202:116137 (2019). [doi:10.1016/j.neuroimage.2019.116137](https://doi.org/10.1016/j.neuroimage.2019.116137)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)

## 👥 Authors

- Brad Caron

**Contributors:** Soichi Hayashi

## 💰 Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io is publicly funded, and acknowledging that support helps keep it running. This App was developed with support from Wellcome, the U.S. National Institutes of Health (including the BRAIN Initiative BRAIN CONNECTS program: The Axonal Projectome EXchange, U24NS140384, and the Center for Mesoscale Connectomics, UM1NS132207) and the U.S. National Science Foundation.</sub>

## ⚖️ License

[MIT](LICENSE). MRtrix3 is distributed under its own license.
