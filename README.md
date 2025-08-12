# Analysis Scripts Overview

This repository contains scripts used in the study to process calcium imaging data, perform statistical and information-theoretic analyses, analyze behavioral data, and support figure reproduction.  
All sections include brief descriptions of functionality, dependencies, and references to relevant figures in *Wang et al.* (2025).

---

## 1. Calcium Data Processing

### Deconvolution
Deconvolution is performed using the `constrained_foopsi` module from [CaImAn].  
To run the script `deconv_multi`:

1. Install CaImAn in your Anaconda environment:
   ```bash
   conda create -n caimans python=3.8
   conda activate caimans
   pip install caiman

2. Place the script in your `caimans` environment directory.
3. Provide a folder containing all `.xlsx` files processed in earlier steps.
4. The script will output a MATLAB `.mat` file containing discrete spike probability distributions.

---

## 2. FindUSN

The script `Find_key_node` processes outputs from `CoactivityGraph` to identify neurons that exhibit persistently higher activity during the remote memory stage compared to pre-training levels.
For methodological details, see the STAR Methods in *Wang et al.* (2025).

The script `KeyNode_CoactivityGraph` analyzes activity patterns of unsilenced cells and generates network topology structures.
Results are reported in **Figure 5C**.

---

## 3. Information Theory Analyses

The following analyses are implemented in the script `CalcInformationTheoryAnalyses.mlx`:

* Ensemble activity cosine similarity calculation
* Joint entropy calculation
* Mutual information calculation
* Mahalanobis distance calculation and clustering analyses
* Community analyses (performed in Gephi; code not included)

**Requirements**
To run the scripts, the [`Neuroscience-Information-Theory-Toolbox`](https://github.com/nmtimme/Neuroscience-Information-Theory-Toolbox) must be added to the MATLAB path.

---

## 4. Behavioral Data Processing

**Synchronization Counts Calculation**
The ensemble synchronization counts analyses are reported in **Figures 3**, **4G**, and **6L**.

* `CoactivityMap_2d`
  Accepts `.xlsx` files and ROI `Location` files from a given time point, producing neuronal synchronization counts (saved as `Line_cell_sum`). Results correspond to **Figures 3A–B**.

* `CoactivityMap_3d`
  Processes results from 3D imaging using a similar logic to `CoactivityMap_2d`.

---

## 5. Supporting Programs

This folder contains additional scripts used to regenerate supplementary figures and conduct various statistical tests.

**Folder Structure**

* Each folder is named in the format `AnalysisName_FigNo`.
* Two versions of each script are provided: English and Chinese.

**Examples**

* **FigS10\_SyncAnaCheck**
  Contains code for simulating and assessing synchronization normalization methods (see `FuncConnAna_sudoData_FigS10.m` for English annotations).
* **FigS7\_USNQualityCheck**
  Contains data and scripts to regenerate Figure S7.

**Utility Scripts**

* `GetIntensity` and `GetSpike`
  Extract intensity and spike values from `.mat` files and save them to `.xlsx` format for use in other analyses.

---

## Dependencies

### Python

The Python scripts in this repository require the following modules:

* **Core Python modules**

  * `sys` – access to system-specific parameters and functions
  * `math` – mathematical functions (log, sqrt, exp)
  * `warnings` – issue warning messages

* **Numerical and scientific computing**

  * `numpy` – array operations and numerical computations
  * `scipy.signal` – signal processing functions
  * `scipy.linalg` – advanced linear algebra routines

* **Compatibility utilities**

  * `from builtins import range` – ensures Python 3 `range` behavior in Python 2 code
  * `from past.utils import old_div` – ensures consistent division behavior across Python 2 and 3

---

### MATLAB

The MATLAB scripts require:

* **MATLAB base environment** (R2020a or later recommended)
* [`Neuroscience-Information-Theory-Toolbox`](https://github.com/nmtimme/Neuroscience-Information-Theory-Toolbox) – for information-theoretic analyses
* Signal Processing Toolbox – for filtering, spectral, and correlation analyses
* Statistics and Machine Learning Toolbox – for statistical testing and clustering
* Image Processing Toolbox – for ROI-based analysis from calcium imaging data

---

### External Software

Some analyses and figure generation require:

* **Gephi** – for community detection and graph visualization
* **ImageJ / Fiji** – for image preprocessing
* **ThorImageLS** – for calcium imaging acquisition
* **GraphPad Prism** – for statistical visualization

