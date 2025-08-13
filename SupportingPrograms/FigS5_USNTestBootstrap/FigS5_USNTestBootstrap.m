clc
clear
close all

% -------------------------------------------------------------------------
% Script description:
% This script performs a bootstrap analysis comparing multiple time points 
% of neural data between two conditions (e.g., control vs. test).
%
% Input requirements:
% - Two Excel files (one for each group/condition).
% - Each file contains one or more sheets. Each sheet corresponds to a 
%   different feature/metric (e.g., "Metric1", "Metric2").
% - In each sheet:
%     Column 1 = time point labels (e.g., '35d', '39d', '42d')
%     Columns 2+ = activity values for individual neurons
%
% Analysis overview:
% 1. Extract the rows for selected time points from both features.
% 2. Compute the "true" metric: proportion of neurons with activity > 0 
%    across all selected time points and features.
% 3. Perform bootstrap resampling by shuffling activity values within each 
%    feature independently and recomputing the metric.
% 4. Calculate 95% confidence intervals for the bootstrap distribution.
% 5. Plot the bootstrap distribution and the true metric.
% -------------------------------------------------------------------------

% -----------------------------
% Parameters (edit as needed)
% -----------------------------
para_fea = {"Metric1", "Metric2"};   % Names of Excel sheets (features)
para_time = {'35d', '39d', '42d', '45d'};  % Selected time points
para_bootstrap_num = 50000;          % Number of bootstrap samples
% -----------------------------

% Data file list (two groups: control and test)
dataOrigi = [];
dataOrigi(1).type = 'control';
dataOrigi(1).file = 'distribution_control_for_sf_2.xlsx';
dataOrigi(2).type = 'test';
dataOrigi(2).file = 'distribution_test_for_sf_2.xlsx';

% Figure setup
figure(1)
tiledlayout(1, 2);

for fi = 1:2
    % Load all features for this dataset
    TR1_mat0 = [];
    for fea_i = 1:length(para_fea)
        TR1 = readcell(dataOrigi(fi).file, Sheet = para_fea{fea_i});
        TR1_timestr = TR1(:, 1); % Time point labels
        TR1_mat0 = cat(3, TR1_mat0, cell2mat(TR1(:, 2:end)));
    end
    
    % Match requested time points
    flag1 = contains(TR1_timestr, para_time);
    if sum(flag1) ~= length(para_time)
        error('Time point parameter mismatch: check para_time and Excel file labels.');
    end
    TR1_mat = TR1_mat0(flag1, :, :);

    % -----------------------------
    % Compute true metric
    % -----------------------------
    mat1 = min(TR1_mat, [], 3);              % Across features
    mat2 = min(mat1, [], 1);                  % Across selected time points
    metric_true = sum(mat2 > 0) / length(mat2);
    dataOrigi(fi).metric_true = metric_true;

    % -----------------------------
    % Bootstrap analysis
    % -----------------------------
    metric_rand = zeros(para_bootstrap_num, 1);
    sampSize = size(TR1_mat0);
    for ri = 1:para_bootstrap_num
        TR1_mat1 = TR1_mat0;
        for fea_i = 1:length(para_fea)
            mat_tar = TR1_mat1(:, :, fea_i);
            mat_tar = reshape(mat_tar, [], 1);
            mat_tar = mat_tar(randperm(length(mat_tar))); % Shuffle values
            mat_tar = reshape(mat_tar, sampSize(1), sampSize(2));
            TR1_mat1(:, :, fea_i) = mat_tar;
        end
        TR1_mat = TR1_mat1(flag1, :, :);
        mat1 = min(TR1_mat, [], 3);
        mat2 = min(mat1, [], 1);
        metric_rand(ri) = sum(mat2 > 0) / length(mat2);
    end
    dataOrigi(fi).metric_rand = metric_rand;

    % -----------------------------
    % Compute confidence interval
    % -----------------------------
    conf = 0.95;
    alpha = 1 - conf;
    [~, ~, ci2] = ttest(metric_rand, mean(metric_rand), 'Alpha', alpha);

    % Display results
    disp(dataOrigi(fi).file)
    fprintf('Metric true: %.4f\n', dataOrigi(fi).metric_true)
    fprintf('Bootstrap 95%% CI: [%.4f %.4f]\n\n', ci2(1), ci2(2))

    % -----------------------------
    % Visualization
    % -----------------------------
    nexttile; hold on
    hx = 0:0.02:1;
    hy = hist(metric_rand, hx);
    hy(hy == 0) = nan;
    hy = fillmissing(hy, 'movmean', 3);
    hy(isnan(hy)) = 0;
    hy = hy / sum(hy);
    plot(hx, hy, 'LineWidth', 1.2)
    plot([1 1] * metric_true, [0 max(hy)], 'r--', 'LineWidth', 1.2)
    legend('Bootstrap', 'True value')
    xlabel('Metric')
    ylabel('Probability')
    title(dataOrigi(fi).type)
end

set(gcf, 'Position', [100, 100, 700, 250])
