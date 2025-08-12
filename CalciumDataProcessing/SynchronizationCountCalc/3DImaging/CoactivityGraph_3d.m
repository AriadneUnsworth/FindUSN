clc
clear
% Load intensity data from Excel files into raster
raster{1,1} = xlsread('intensity-s21_01.xlsx');
raster{1,2} = xlsread('intensity-s21_02.xlsx');
raster{1,3} = xlsread('intensity-s21_03.xlsx');
save original_data

%%
ExpT = length(raster); % Number of experiments/time points
[~, CellNum] = size(raster{1,1});

% Load 3D positions (x, y, z) from Excel and flip Y and Z axes for plotting
position_xy_0 = xlsread('position.xlsx');
position_xyz = position_xy_0';
position_xyz(2,:) = -position_xyz(2,:); % Flip y-axis
position_xyz(3,:) = -position_xyz(3,:); % Flip z-axis

Line_Cell = zeros(CellNum);       % Matrix to store co-activation counts
Line_Cell_rand = zeros(CellNum);  % Matrix to store randomized co-activation counts
N_rand = 10;                      % Number of random permutations for null model
ind_1 = 1:CellNum;                % Indices of cells

for ci = 1:ExpT
    disp(['Processing experiment: ', num2str(ci)]);
    tic
    for cell_i = 1:length(ind_1)-1
        for cell_j = cell_i+1:length(ind_1)
            DR1 = raster{1,ci}(:, ind_1(cell_i)); % Data for cell i
            DR2 = raster{1,ci}(:, ind_1(cell_j)); % Data for cell j
            
            SR1 = DR1 + DR2; % Sum at each timepoint
            SR_ind = find(SR1 == 2); % Timepoints where both cells active
            
            if ~isempty(SR_ind)
                % Update co-activation counts
                Line_Cell(cell_i, cell_j) = Line_Cell(cell_i, cell_j) + length(SR_ind);
                Line_Cell(cell_j, cell_i) = Line_Cell(cell_i, cell_j);
                
                Line_Cell_rand_T = zeros(1, N_rand);
                for ri = 1:N_rand
                    % Shuffle each spike train independently to get randomized co-activation
                    DR1_r = DR1(randperm(500));
                    DR2_r = DR2(randperm(500));
                    SR1_r = DR1_r + DR2_r;
                    Line_Cell_rand_T(ri) = length(find(SR1_r == 2));
                end
                
                % Average randomized co-activation count
                Line_Cell_rand(cell_i, cell_j) = Line_Cell_rand(cell_i, cell_j) + mean(Line_Cell_rand_T);
                Line_Cell_rand(cell_j, cell_i) = Line_Cell_rand(cell_i, cell_j);
            end
        end
    end
    toc
end

save Graph_rand_data

%%
% The following two lines were commented out to avoid overwriting the actual positions with random data
% position_xy=rand(2,37);
% position_z=rand(3,37);

% Adjust thickness of cell connection lines
% Method 1: linear scaling with max line width of 32
LineRatio = 1;
LineMax = 32;
Line_CellVisual = Line_Cell.^LineRatio;
Line_CellVisual(Line_CellVisual > LineMax) = LineMax;

% % Alternative Method 2: nonlinear scaling to emphasize strong connections
% LineRatio = 0.8;
% LineMax = 20;
% Line_CellVisual = Line_Cell.^LineRatio;
% Line_CellVisual(Line_CellVisual > LineMax) = LineMax;

% Calculate difference between actual and randomized co-activation
Line_Cell_1 = Line_Cell - Line_Cell_rand;
Line_Cell_sum = sum(Line_Cell_1);

% 3D plot of connections (lines) between cells
figure; hold on; grid on
for cell_i = 1:length(ind_1)-1
    for cell_j = cell_i+1:length(ind_1)
        if Line_Cell_1(cell_j, cell_i) > 1 % Threshold to plot connection
            LineW = Line_Cell_1(cell_i, cell_j)^1;
            cellx = [position_xyz(1, ind_1(cell_i)) position_xyz(1, ind_1(cell_j))];
            celly = [position_xyz(2, ind_1(cell_i)) position_xyz(2, ind_1(cell_j))];
            cellz = [position_xyz(3, ind_1(cell_i)) position_xyz(3, ind_1(cell_j))];
            
            p = plot3(cellx, celly, cellz, 'LineWidth', Line_CellVisual(cell_j, cell_i)^3/300, 'Color', [0.8 0.2 0.2]);
            p.Color(4) = 0.5; % Set transparency of the line
        end
    end
end

% Plot 3D scatter of cell positions, size scaled by total co-activation strength
K = 2;
ind_0 = ind_1;
c = parula(24);

s = scatter3(position_xyz(1, ind_0), position_xyz(2, ind_0), position_xyz(3, ind_0), Line_Cell_sum(ind_0)*K + K);
s.MarkerEdgeColor = [0.6 0.6 0.6];
s.MarkerFaceColor = [0 0 1]';
s.MarkerFaceAlpha = 0.7;

% Set viewing angle for 3D plot
view(-150, 15)

colormap(c)

% Heatmap of co-activation matrix difference
figure; hold on
imagesc(Line_Cell_1)
