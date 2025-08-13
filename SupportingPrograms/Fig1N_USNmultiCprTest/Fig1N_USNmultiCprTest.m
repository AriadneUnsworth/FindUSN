clc
clear

% -------------------------------------------------------------------------
% Script description:
% This script compares neural activity values at different time point 
% combinations against a baseline time point, and calculates the number of 
% neurons whose activity exceeds baseline for each combination.
%
% Input file requirement:
% Excel file (.xlsx) with dimensions:
%   Rows    = time points (first row is baseline)
%   Columns = neurons
% Example:
%   Row 1   = baseline activity values for each neuron
%   Row 2+  = activity values at subsequent time points
%
% Output:
%   - Mean and standard deviation of neurons above baseline for each number 
%     of sessions chosen
%   - Visualization of results with shaded standard deviation area
% -------------------------------------------------------------------------

% Read neural activity data from Excel file
TR_data = xlsread('activity test data(ramdomly).xlsx'); 

% Baseline neural activity (first row)
neural_baseline = TR_data(1,:);

% Neural activity data excluding the baseline
neural_data = TR_data(2:end,:);

% Number of neurons and time points (excluding baseline)
numCell = size(neural_data, 2);
numTime = size(neural_data, 1);

% Initialize result matrix
% Columns: [mean number of neurons > baseline, std, number of combinations]
statCellNum = zeros(numTime, 3);

% Maximum number of random samples
numRandMax = 10000;

for ci = 1:numTime
    % Generate combinations of time points
    % If number of combinations is small enough, enumerate all
    if nchoosek(numTime, ci) < numRandMax * 10  
        TR_ind = nchoosek(1:numTime, ci); % all possible combinations
        if size(TR_ind, 1) > numRandMax
            % Randomly sample if too many combinations
            TR_ind = TR_ind(randperm(size(TR_ind, 1), numRandMax), :);
        end
    else
        % If too large to enumerate, generate random combinations
        TR_ind = zeros(numRandMax, ci);
        for cj = 1:numRandMax
            TR_ind(cj, :) = randperm(numTime, ci);
        end
    end
    
    % Store counts of neurons exceeding baseline
    TR1 = [];
    for cj = 1:size(TR_ind, 1)
        % Minimum activity across selected time points for each neuron
        min_activity = min(neural_data(TR_ind(cj, :), :), [], 1);
        
        % Logical array: whether neuron’s activity > baseline
        above_baseline = min_activity > neural_baseline;
        
        % Count neurons above baseline
        TR1 = [TR1; sum(above_baseline)];
    end
    
    % Mean, standard deviation, and number of samples
    statCellNum(ci, :) = [mean(TR1), std(TR1), length(TR1)];
end

% Convert to ratio (relative to number of neurons)
statCellNum_ratio = statCellNum;
statCellNum_ratio(:, 1:2) = statCellNum_ratio(:, 1:2) / numCell;

% Visualization
figure; hold on
y = statCellNum(:, 1); 
e = statCellNum(:, 2);

% Plot standard deviation as shaded area
h = area(1:numTime, [y - e, 2 * e]);
set(h(1), 'Visible', 'off');
set(h(2), 'EdgeColor', 'none', 'FaceColor', [0.7, 0.7, 1]);

% Plot mean number of neurons above baseline
plot(1:numTime, y, 'k', 'LineWidth', 1.2);

xlabel('Number of sessions')
ylabel('Number of neurons')
set(gcf, 'Position', [50, 50, 300, 250])
