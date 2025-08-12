# Preprocessing

The preprocessing workflow consists of five key steps. All related code is available here, except for Step 2, which is performed in ImageJ. For customized ImageJ acquisition, please refer to the paper:  
*An Excitatory Neural Assembly Encodes Short-Term Memory in the Prefrontal Cortex*  
Cell Reports 22, 1734–1744 (2018). DOI: [10.1016/j.celrep.2018.01.050](https://doi.org/10.1016/j.celrep.2018.01.050)

1. **Motion Correction**  
   Motion correction uses scripts located in the `FiJi.app\scripts` folder within the customized ImageJ environment. To run motion correction, directly execute `DriftCorrection.m` and select the folder containing `.raw` Thorlab files. To address reviewer requests, we also employed an alternative method, [NeuroPixelAI][def]. Since this did not affect our main conclusions, those results were not included in the final paper.

2. **ROI Selection, Signal Extraction, and Cross-Day Quality Check**  
   These steps are performed in ImageJ to facilitate identification of the same neurons across multiple days (code not included). Detailed methods can be found in Wang et al. (2025).

3. **Spike Inference**  
   Neuronal spiking activities were inferred from raw calcium traces using two methods: Deconvolution and DeepSpike. Results are presented in the main figures. Please refer to the `readme` files in each folder for specific dependencies and instructions.  
   The deconvolution method is based on [CaImAn][def2].  
   The DeepSpike method is based on [DeepSpike][def3]. We used an RNN model.

4. **ΔF/F Calculation**  
   This step calculates ΔF/F values from raw signals. Detailed methods are described in Wang et al. (2025). Results are shown in **Figures 1 and 2**. To prepare files from ImageJ, ensure they are saved in `.xlsx` format, then run `Excel_Batch.m` to extract the correct columns containing mean raw signals from ROIs. To calculate ΔF/F values, run `DeltaF_calculate2manualwindow.m` and select the processed `.xlsx` files. The `DataVisualization` scripts accept ΔF/F values stored in `.xlsx` files and highlight neurons with potentiated calcium power.

5. **Calcium Power Calculation Based on ΔF/F**  
   This analysis determines neuronal activity potentiation levels. Results are presented in **Figures 1 and S5**. To run the program, select the respective ΔF/F `.xlsx` files using `wy_readdata.m` and then execute `main.m`.

[def]: https://github.com/Yourswear/NeuroPixelAI  
[def2]: https://github.com/flatironinstitute/CaImAn  
[def3]: https://github.com/mackelab/DeepSpike  
