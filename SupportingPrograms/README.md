## Supporting Programs

This folder contains various programs required to regenerate results reported in the supplementary figures. These scripts perform a range of statistical tests on the results.

Each subfolder is named using the format `AnalysisName_FigNo`. We provide two versions of all code: one in English and one in Chinese.

- The folder `FigS10_SyncAnaCheck` contains code for regenerating **Figure S10: Assessment of synchronization normalization method by simulation experiment**.  
  For English annotations, please refer to the file `FuncConnAna_sudoData_FigS10.m`.

- The folder `FigS7_USNQualityCheck` contains data and code required to regenerate **Figure S7**.

- The folder `FigS5_USNTestBootstrap` contains code for regenerating **Figure S5F&G**

- The folder `Fig1N_USNmultiCprTest` contains code for regenerating **Figure 1N**

The scripts `GetIntensity` and `GetSpike` were used to extract intensity and spike values from `.mat` files and save them in `.xlsx` format, which is the required input format for some of the analysis scripts.
