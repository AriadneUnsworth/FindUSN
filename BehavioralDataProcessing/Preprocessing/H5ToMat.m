clc
clear

% Navigate to the target folder containing all .h5 files
ds = imageDatastore(pwd, "IncludeSubfolders", true, 'FileExtensions', '.h5');
dsFiles = ds.Files;

for di = 1:length(dsFiles)
    tarFile = dsFiles{di};

    % Load h5 file info and data
    info = h5info(tarFile);
    data_PiezoMonitor = h5read(tarFile, '/AI/PiezoMonitor');
    data_Pockels1Monitor = h5read(tarFile, '/AI/Pockels1Monitor');
    data_PiezoMonitor = single(data_PiezoMonitor);
    data_Pockels1Monitor = single(data_Pockels1Monitor);

    % Save the loaded data as a .mat file with the same base name
    matfile = [tarFile(1:end-3) '.mat'];
    save(matfile, 'data_PiezoMonitor', 'data_Pockels1Monitor');

    % Other datasets (commented out because they seem irrelevant or empty):
    % data_GCtr = h5read(tarFile, '/Global/GCtr');       % uint64 integer, apparently meaningless?
    % data_Line5 = h5read(tarFile, '/DI/Line5');         % All zeros
    % data_Hz = h5read(tarFile, '/Freq/Hz');             % All zeros
    % data_FrameOut = h5read(tarFile, '/DI/FrameOut');   % All zeros
    % data_FitHz = h5read(tarFile, '/Freq/FitHz');       % All zeros
end
