# Analysis Scripts Overview

This repository contains scripts used in the study [Unsilenced inhibitory cortical ensemble gates remote memory retrieval](https://www.biorxiv.org/content/10.1101/2024.07.01.601454v2) to process calcium imaging data, perform statistical and information-theoretic analyses, analyze behavioral data, and support figure reproduction.  

All sections include brief descriptions of functionality, dependencies, and references to relevant figures in *Wang et al.* (2025).

All questions may be directed to Shaoli Wang (shaoliwang@fudan.edu.cn) or He Yang (21111520061@m.fudan.edu.cn).

We utilized existing repositories in various parts of the code, including:

1. [CaImAn](https://github.com/flatironinstitute/CaImAn)
2. [Neuroscience Information Theory Toolbox](https://github.com/nmtimme/Neuroscience-Information-Theory-Toolbox)
3. [DeepSpike](https://github.com/mackelab/DeepSpike)

Most MATLAB codes are provided in *.mlx* format. For original code annotated in Chinese, we also offer an English version in *.m* format under the same file name.

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

