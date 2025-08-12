# Preprocessing

The preprocessing workflow consists of five key steps. All related code is available here except for Step 2, which is performed in ImageJ. For customized ImageJ acquisition, please refer to the paper:  
*An Excitatory Neural Assembly Encodes Short-Term Memory in the Prefrontal Cortex* (Cell Reports 22, 1734-1744, 2018; DOI: [10.1016/j.celrep.2018.01.050](https://doi.org/10.1016/j.celrep.2018.01.050)).

1. **Motion Correction**  
   Motion correction utilizes scripts located in the `FiJi.app\scripts` folder. This is found in the customized ImageJ folder.

2. **ROI Selection, Signal Extraction, and cross-day Quality Check**  
   These steps are performed in ImageJ to enable cross-day identification of the same neurons. Detailed methods can be found in Wang et al. (2025).

3. **Spike Inference**
   We utilized two methods to infer neuronal spiking activities from raw calcium trace: Deconvolution and DeepSpike. Results were reported in the main Figures.

4. **ΔF/F Calculation**
   This step calculate the ΔF/F values from raw signals. Detailed methods can be found in Wang et al. (2025). Results were reported in **`Fig.1&2`**.

5. **Calcium Power Calculation Based on ΔF/F**  
   This step is used to determine neuronal activity potentiation levels. Results were reported in **`Fig.1&Fig.S5`**. The `DataVisualization` scripts accepts raw calcium or ΔF/F values stored in `excel` files and highlight neurons with potentiated calcium power.
