clc
clear
addpath 'C:\Users\Admin\AppData\Roaming\MathWorks\MATLAB Add-Ons\Functions\Shapiro-Wilk and Shapiro-Francia normality tests'

% Select an .xlsx file
[fileName, filePath] = uigetfile('*.xlsx', 'Select an .xlsx file');
if fileName == 0
    error('No file selected');
end
fullFilePath = fullfile(filePath, fileName);

% Load data
data = readmatrix(fullFilePath);
if isempty(data)
    error(['File ', fileName, ' is empty or has incorrect format']);
end
[timepoints, n] = size(data);

% Initialize variables
selectedFrames = nan(1, n);       % Starting frame selected for each cell
windowSizes = 200 * ones(1, n);   % Baseline window size for each cell (default 200 frames)
F0 = zeros(1, n);                 % Preallocate F0

% Move data to GPU if available
if canUseGPU()
    data = gpuArray(data);
    disp('Using GPU acceleration');
else
    warning('GPU not detected, using CPU for computation');
end

% -----------------------------
% Main loop: select baseline windows
% -----------------------------
for i = 1:n
    currentData = data(:, i);     % Current cell data
    windowSize = windowSizes(i);  % Current window size
    selectedFrame = nan;          % Reset selected frame for this cell
    
    % Interactive baseline window selection
    while true
        hFig = figure;
        set(hFig, 'ToolBar', 'none');
        
        try
            % Plot fluorescence trace
            cla;
            plot(currentData, 'k');
            title(['Cell ', num2str(i), ' - Window size: ', num2str(windowSize), ' frames']);
            xlabel('Frame');
            ylabel('Fluorescence');
            hold on;
            
            % Plot already selected window
            if ~isnan(selectedFrame)
                endFrame = min(selectedFrame + windowSize - 1, timepoints);
                plot(selectedFrame:endFrame, currentData(selectedFrame:endFrame), 'r');
            end
            
            % User interaction instructions
            disp(['Cell ', num2str(i), ': Left-click to select start frame | Right-click to set window size | Press Enter to confirm']);
            
            % Capture user input
            [x, ~, button] = ginput(1);
            
            if isempty(button)  % Enter pressed, confirm selection
                if ~isnan(selectedFrame)
                    selectedFrames(i) = selectedFrame;
                    close(hFig);
                    break;
                else
                    warning('No valid window selected, please continue selecting');
                end
            elseif button == 1  % Left-click to select start frame
                startFrame = round(x(1));
                if (startFrame >= 1) && (startFrame + windowSize - 1 <= timepoints)
                    selectedFrame = startFrame;
                else
                    warning('Selected window is out of data range');
                end
            elseif button == 3  % Right-click to change window size
                answer = inputdlg('Enter new window size (frames):', 'Window size', [1 40], {num2str(windowSize)});
                if ~isempty(answer)
                    newSize = str2double(answer{1});
                    if ~isnan(newSize) && (newSize > 0) && (newSize == floor(newSize))
                        % Update window size and check current selection validity
                        windowSizes(i) = newSize;
                        windowSize = newSize;
                        if ~isnan(selectedFrame) && (selectedFrame + newSize - 1 > timepoints)
                            warning('New window exceeds data range, please reselect start frame');
                            selectedFrame = nan;
                        end
                    else
                        warning('Please enter a positive integer');
                    end
                end
            end
            close(hFig);
            
        catch ME
            close(hFig);
            if contains(ME.message, 'Index exceeds matrix dimensions')
                warning('Window is out of data range, please reselect');
            else
                rethrow(ME);
            end
        end
    end
    
    % Compute F0
    if ~isnan(selectedFrames(i))
        F0(i) = mean(currentData(selectedFrames(i):selectedFrames(i)+windowSizes(i)-1));
    else
        F0(i) = NaN;
        warning(['Cell ', num2str(i), ' did not select a valid baseline window']);
    end
end

% -----------------------------
% Compute delta F over F
% -----------------------------
delta_F_over_F = (data - F0) ./ F0;

% Gather results back to CPU if on GPU
if isgpuarray(delta_F_over_F)
    delta_F_over_F = gather(delta_F_over_F);
    F0 = gather(F0);
end

% -----------------------------
% Shapiro-Wilk normality test
% -----------------------------
disp('---------- Shapiro-Wilk Normality Test ----------');
validF0 = F0(~isnan(F0));
if length(validF0) > 3
    [h, p] = swtest(validF0);
    if h == 0
        disp('F0 values follow a normal distribution');
    else
        disp('F0 values do NOT follow a normal distribution');
    end
    disp(['p-value = ', num2str(p)]);
else
    disp('Not enough data for Shapiro-Wilk test');
end

% -----------------------------
% Plot Q-Q plot
% -----------------------------
figure;
qqplot(validF0);
title('Q-Q Plot of F0');
xlabel('Theoretical Quantiles');
ylabel('Sample Quantiles');
hold on;
plot([min(validF0), max(validF0)], [min(validF0), max(validF0)], '--r');
hold off;

% -----------------------------
% Save results
% -----------------------------
[~, name, ~] = fileparts(fileName);
savePath = fullfile(filePath, [name, '_F.xlsx']);
if exist(savePath, 'file'), delete(savePath); end
writematrix(delta_F_over_F, savePath, 'Sheet', 'DeltaFOverF');
disp(['File saved to: ', savePath]);

% -----------------------------
% Check GPU availability function
% -----------------------------
function tf = canUseGPU()
    try
        gpuArray(1);
        tf = true;
    catch
        tf = false;
    end
end
