clc; clear;

addpath("E:\Data Analysis\2P Imaging\Programs\Fiji.app\scripts");
addpath('D:\Git\FindUSN\CalciumDataProcessing\Preprocessing\MotionCorrection');

% Select the root folder to process
rootFolder = uigetdir(pwd, 'Select Root Folder to Process');
if rootFolder == 0
    error('Folder selection canceled.');
end
fprintf('Selected folder: %s\n', rootFolder);

% Start MIJ once
Miji(false);

% Use a queue to hold folders to process (start with root)
foldersToProcess = {rootFolder};
processedFolders = {};  % To avoid repeated processing if needed

while ~isempty(foldersToProcess)
    currentFolder = foldersToProcess{1};
    foldersToProcess(1) = [];  % Dequeue
    
    % Check if folder contains any .raw files
    rawFiles = dir(fullfile(currentFolder, '*.raw'));
    hasRaw = ~isempty(rawFiles);
    
    % Check if folder contains Image.tif (skip if yes)
    tifFiles = dir(fullfile(currentFolder, 'Image.tif'));
    hasTif = ~isempty(tifFiles);
    
    if hasRaw && ~hasTif
        fprintf('Processing folder: %s\n', currentFolder);
        
        % Use the first .raw file found
        rawFileName = rawFiles(1).name;
        rawFilePath = fullfile(currentFolder, rawFileName);
        
        % Open raw file in MIJ
        openRawInMIJ(rawFilePath);
        
        % Get reference frame (first frame)
        img = uint8(MIJ.getCurrentImage);
        ref = img(:,:,1);
        
        % Save Reference.tif in current folder
        imwrite(ref, fullfile(currentFolder, 'Reference.tif'));
        
        % Load Reference.tif back for registration
        imref = mijread(fullfile(currentFolder, 'Reference.tif'));
        
        % Perform motion correction and processing
        performMotionCorrection(rawFilePath, currentFolder);
        
        % Clear variables before next iteration
        clear img ref imref;
    end
    
    % Enqueue subfolders to process
    subItems = dir(currentFolder);
    % Remove '.' and '..' and files (keep folders only)
    subFolders = subItems([subItems.isdir] & ~ismember({subItems.name}, {'.','..'}));
    
    for i = 1:length(subFolders)
        foldersToProcess{end+1} = fullfile(currentFolder, subFolders(i).name);
    end
end

% Exit MIJ once after all processing
MIJ.exit;

disp('All folders processed.');

%% --- Subfunctions ---

function openRawInMIJ(rawPath)
    % Opens raw file in MIJ with fixed parameters (modify if needed)
    [folder, fileName, ext] = fileparts(rawPath);
    fprintf('Opening raw file in MIJ: %s\n', rawPath);
    MIJ.run('Raw...', ['open=', fileName, ext, ' image=[16-bit Unsigned] width=512 height=512 offset=0 number=2800 gap=0 little-endian']);
    MIJ.run('Size...', 'width=256 height=256 depth=2800 constrain average interpolation=None');
    MIJ.run('8-bit');
end

function performMotionCorrection(rawFilePath, currentFolder)
    % Perform motion correction steps in MIJ
    
    [~, rawFileName, ext] = fileparts(rawFilePath);
    
    % Open raw file again for registration
    MIJ.run('Raw...', ['open=', rawFileName, ext, ' image=[16-bit Unsigned] width=512 height=512 offset=0 number=2800 gap=0 little-endian']);
    MIJ.run('Size...', 'width=256 height=256 depth=2800 constrain average interpolation=None');
    MIJ.run('8-bit');
    
    % Concatenate all open images
    MIJ.run('Concatenate...', 'all_open title=[Corrected]');
    
    % Run StackReg rigid body registration
    MIJ.run('StackReg Ming', 'transformation=[Rigid Body]');
    
    % Get corrected image stack
    temp = uint8(MIJ.getCurrentImage);
    
    % Max intensity projection
    MIJ.run('Z Project...', 'projection=[Max Intensity]');
    AVG = uint8(MIJ.getCurrentImage);
    
    % Close all open images in MIJ
    MIJ.run('Close All');
    
    % Save processed images in current folder
    IMG = temp(:,:,2:end); % skip first image (reference)
    imwrite(IMG(:,:,1), fullfile(currentFolder, 'Image.tif'));
    for k = 2:size(IMG,3)
        imwrite(IMG(:,:,k), fullfile(currentFolder, 'Image.tif'), 'WriteMode', 'append');
    end
    imwrite(AVG, fullfile(currentFolder, 'Average.tif'));
    
    fprintf('Motion correction done for folder: %s\n', currentFolder);
end
