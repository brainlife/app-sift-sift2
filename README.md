[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-brainlife.app.580-blue.svg)](https://doi.org/10.25663/brainlife.app.580)

# Filter streamlines using SIFT

This app will filter streamlines from a wholebrain tractogram using SIFT. 

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

#### MIT Copyright (c) 2020 brainlife.io The University of Texas at Austin and Indiana University

## Running the App

### On Brainlife.io

You can submit this App online at [https://doi.org/10.25663/brainlife.app.580](https://doi.org/10.25663/brainlife.app.580) via the 'Execute' tab.

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
    "no_dilate_lut":    false,
    "fd_thresh": 0,
    "term_number":  null,
    "term_ratio":   null,
    "term_mu":  null
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

The main output of this App is a raw datatype containing all of stats files and converted data, a track/tck datatype containing the filtered tractogram, and a labels datatype containing the boolean streamline indices from the input tractogram for the streamlines that survived SIFT.

#### Product.json

The secondary output of this app is `product.json`. This file allows web interfaces, DB and API calls on the results of the processing.

### Dependencies

This App only requires [singularity](https://www.sylabs.io/singularity/) to run. If you don't have singularity, you will need to install following dependencies.   

- MRTrix3: https://www.mrtrix.org/

#### MIT Copyright (c) 2020 brainlife.io The University of Texas at Austin and Indiana University
