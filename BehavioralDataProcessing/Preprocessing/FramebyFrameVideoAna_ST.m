clear; clc;

% Prompt a file selection dialog to choose the video
[filename, pathname] = uigetfile({'*.avi', 'AVI Video Files (*.avi)'; '*.*', 'All Files'}, ...
                                 'Select the training video');
if isequal(filename,0)
    error('No video file selected.');
end

% Construct full file path
f = fullfile(pathname, filename);

% Read the video file
obj = VideoReader(f);

% Get total number of frames
numFrames = obj.NumFrames;   % NOTE: NumFrames is not supported in newer MATLAB; use obj.Duration * obj.FrameRate

% Get frame rate
FramesRate = obj.FrameRate;

% Comparison interval (in seconds)
SecComp = 4/30;               % compare every ~0.133 seconds
framesComp = round(30 * SecComp); % number of frames between comparisons

Cssimval = [];

% Loop through video frames at set intervals
for k = 1:framesComp:numFrames
    img = read(obj, k);       % Read frame k
    img = rgb2gray(img);      % Convert to grayscale
    
    if k == 1
        % Store the first frame for initial comparison
        temp = img;
    else
        % Calculate structural similarity (SSIM) between current and previous frame
        [Cssimval(floor(k/framesComp)), ~] = ssim(img, temp);
        
        % Update comparison frame
        temp = img;
    end
end

% Convert SSIM similarity to "difference" percentage
Cssimval0 = 100 - 100 * Cssimval;

% Keep only relevant variables
clearvars -except Cssimval Cssimval0 f FramesRate numFrames

% Plot the frame difference over time
plot(Cssimval0');
xlabel('Frame Comparison Index');
ylabel('Difference (%)');
title('Frame-to-Frame Difference');

% Define time limit for analysis (use full range if unchanged)
Timelim = [1 length(Cssimval0)];

% Count frames considered as "freezing" (difference < min + 0.8)
A = sum(Cssimval0(Timelim(1):Timelim(2)) < (min(Cssimval0) + 0.8));

% Calculate freezing percentage
timeA = A / length(Cssimval0);

fprintf('Freezing percentage: %.2f%%\n', timeA * 100);
