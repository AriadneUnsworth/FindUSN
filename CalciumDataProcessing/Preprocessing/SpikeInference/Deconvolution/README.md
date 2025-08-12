## Deconvolution

Deconvolution is performed using the `constrained_foopsi` module from [CaImAn]. To run the script `deconv_multi`, run the script in your `caiman` environment. The script reads a folder containing all `.xlsx` files processed in previous steps and outputs a MATLAB file containing the discrete spike probability distributions.

### Installation Instructions for CaImAn

CaImAn (Calcium Imaging Analysis) can be installed via Anaconda. Follow these steps:

1. **Install Anaconda** (if not already installed):  
   Download from [https://www.anaconda.com/products/distribution](https://www.anaconda.com/products/distribution) and follow the installation instructions for your operating system.

2. **Create a new Conda environment for CaImAn:**  
   Open a terminal or Anaconda Prompt and run:
   ```bash
   conda create -n caiman python=3.8
   conda activate caiman
