# Behavioral Data Preprocessing

Behavioral data were collected using either video recordings or a piezoelectric sensor placed under the animal’s front paw.

- **Video recordings:**  
  The script **`FramebyFrameVideoAna_ST`** processes the recordings and outputs **`freezing.m`**, located in the `BehavioralDataProcessing` folder.

- **Piezoelectric signals:**  
  The script **`H5ToMat`** processes raw **`.h5`** ThorSync output files and generates **`Episode001.mat`**, also located in the `BehavioralDataProcessing` folder.

Results are presented in the main figures and in **Figure S1**. For methodological details, please refer to *Wang et al.* (2025).
