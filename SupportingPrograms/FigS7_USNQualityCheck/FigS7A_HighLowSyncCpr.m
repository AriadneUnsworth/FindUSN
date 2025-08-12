% High-Low Synchrony Heatmap Analysis
clear;  % Clear workspace variables

% Load dataset 'HLsync.mat' containing matrices 'gaba' and 'nongaba'
load('HLsync.mat');

% --- Process gaba matrix ---
for i = 1 : length(gaba(1,:))  % Loop through each column (cell) in gaba
    
    % Count how many entries in rows 4 to 7 are equal to 1 for column i
    gaba(8,i) = length(find(gaba(4:7,i) == 1));
    
    % Find indices of entries equal to 0 in rows 4 to 7 for column i
    temp1 = find(gaba(4:7,i) == 0);
    
    if isempty(temp1) 
        % If no zero found, assign 0 to gaba(9,i)
        gaba(9,i) = 0;
    else
        % Otherwise, assign the first zero index to gaba(9,i)
        gaba(9,i) = temp1(1);
    end   
end

% --- Sort gaba columns by criteria ---
% Sort gaba columns first by descending count of ones (gaba(8,:))
% If counts equal, sort by ascending first zero index (gaba(9,:))
for i = 1: length(gaba(1,:))-1
    for j = i+1 : length(gaba(1,:))
        if gaba(8,i) < gaba(8,j)
            % Swap columns i and j if column j has more ones
            temp1 = gaba(:,i); gaba(:,i) = gaba(:,j); gaba(:,j) = temp1;
        elseif (gaba(8,i) == gaba(8,j)) && (gaba(9,i) > gaba(9,j))
            % If equal ones count, swap if column j has earlier zero index
            temp1 = gaba(:,i); gaba(:,i) = gaba(:,j); gaba(:,j) = temp1;
        end
    end
end

% --- Process nongaba matrix (same steps as gaba) ---
for i = 1 : length(nongaba(1,:))
    % Count of ones in rows 4 to 7 for nongaba column i
    nongaba(8,i) = length(find(nongaba(4:7,i) == 1));
    
    % Find zero indices in rows 4 to 7 for nongaba column i
    temp1 = find(nongaba(4:7,i) == 0);
    
    if isempty(temp1)
        nongaba(9,i) = 0;
    else
        nongaba(9,i) = temp1(1);
    end   
end

% Sort nongaba columns similarly as gaba
for i = 1: length(nongaba(1,:))-1
    for j = i+1 : length(nongaba(1,:))
        if nongaba(8,i) < nongaba(8,j)
            temp1 = nongaba(:,i); nongaba(:,i) = nongaba(:,j); nongaba(:,j) = temp1;
        elseif (nongaba(8,i) == nongaba(8,j)) && (nongaba(9,i) > nongaba(9,j))
            temp1 = nongaba(:,i); nongaba(:,i) = nongaba(:,j); nongaba(:,j) = temp1;
        end
    end
end

% --- Visualization ---

% Plot heatmap of rows 4 to 7 of gaba matrix (transposed for visualization)
figure
imagesc(gaba(4:7,:)');  % Show image with color representing values
colorbar               % Add color scale legend
colormap parula        % Use 'parula' colormap for better color mapping

% Plot heatmap of rows 4 to 7 of nongaba matrix (transposed)
figure
imagesc(nongaba(4:7,:)');
colorbar
colormap parula
