# -*- coding: utf-8 -*-
"""
Created on Thu Nov 11 14:17:10 2021
@author: wyz & yh

Batch processing script for calcium imaging data analysis:
1. Processes multiple Excel files in a directory
2. Applies temporal smoothing to fluorescence traces
3. Performs spike deconvolution using constrained FOOPSI
4. Optionally visualizes results
5. Saves results as MATLAB (.mat) files
"""

import os  # For file/directory operations
import xlrd  # For reading Excel files
import numpy as np  # Numerical computing library
from deconvolution import constrained_foopsi  # Spike inference algorithm
import matplotlib.pyplot as plt  # Plotting library
import scipy.io as scio  # MATLAB file I/O operations

def smooth2nd(x, M):
    """
    Apply moving average smoothing to a 1D signal
    Args:
        x (array): Input 1D signal
        M (int): Smoothing window size (odd numbers preferred)
    Returns:
        y (array): Smoothed signal with same length as input
    """
    K = round(M/2 - 0.1)  # Calculate half-window size (adjusts for even M)
    lenX = len(x)
    if lenX < 2*K + 1:
        print('Warning: Data length smaller than smoothing window')
        return x.copy()  # Return original if window too large
    else:
        y = np.zeros(lenX)
        for NN in range(lenX):
            startInd = max(0, NN - K)  # Handle start boundary
            endInd = min(NN + K + 1, lenX)  # Handle end boundary
            y[NN] = np.mean(x[startInd:endInd])  # Moving average
        return y

# ========================================================================
# MAIN PROCESSING PIPELINE
# ========================================================================
show_plot = False  # Toggle visualization ON/OFF
root_path = r'E:\wwww'  # Root directory containing data files

# Create results directory if doesn't exist
results_dir = os.path.join(root_path, 'Deconvolution_Results')
os.makedirs(results_dir, exist_ok=True)

# Process each Excel file in directory
for f in os.listdir(root_path):
    if not f.endswith('.xlsx'): 
        continue  # Skip non-Excel files
    
    # ====================================================================
    # DATA LOADING SECTION
    # ====================================================================
    file_path = os.path.join(root_path, f)
    print(f'Processing file: {f}')
    
    try:
        wb = xlrd.open_workbook(file_path)
        sheet = wb.sheet_by_name('Sheet1')
        # Create numpy array directly from sheet data
        data = np.array([[sheet.cell(i, j).value for j in range(sheet.ncols)] 
                          for i in range(sheet.nrows)])
        intensity = data  # Each column is a fluorescence trace
    except Exception as e:
        print(f'Error loading {f}: {str(e)}')
        continue

    # ====================================================================
    # SPIKE DECONVOLUTION PROCESSING
    # ====================================================================
    S = np.zeros_like(intensity)  # Initialize spike matrix
    
    for i in range(intensity.shape[1]):
        # Preprocessing: Smooth trace
        intensity[:, i] = smooth2nd(intensity[:, i], 11)  # 11-point window
        
        # Spike deconvolution (AR(2) model)
        _, _, _, _, _, sp, _ = constrained_foopsi(
            intensity[:, i], 
            p=2,        # AR model order (2 for calcium transients)
            lags=20,    # Autocorrelation window size
            s_min=0.2   # Minimum spike amplitude threshold
        )
        
        # Remove initial artifacts
        sp[0:30] = 0
        S[:, i] = sp
        
        # Progress tracking
        print(f'Column {i+1}: Spike count = {np.sum(sp > 0)}')

    # ====================================================================
    # VISUALIZATION (OPTIONAL)
    # ====================================================================
    if show_plot:
        # Apply vertical offsets for visualization
        a = intensity + np.arange(intensity.shape[1]) * 10
        b = S + (np.arange(S.shape[1]) + 1) * 2
        
        plt.figure(figsize=(12, 6))
        plt.subplot(211)
        plt.title(f"Smoothed Fluorescence: {f}")
        plt.plot(a)
        plt.ylabel("Intensity + Offset")
        
        plt.subplot(212)
        plt.title("Detected Spikes")
        plt.plot(b)
        plt.ylabel("Spike Amplitude + Offset")
        plt.tight_layout()
        plt.show()

    # ====================================================================
    # DATA SAVING
    # ====================================================================
    # Create output filename (change extension to .mat)
    output_name = os.path.splitext(f)[0] + '_deconv.mat'
    output_path = os.path.join(results_dir, output_name)
    
    # Save with relevant metadata
    scio.savemat(output_path, {
        'sp': S,
        'intensity': intensity,
        'source_file': f,
        'processing_date': np.datetime64('now')
    })
    print(f'Saved results to: {output_path}\n')

print('Batch processing complete!')