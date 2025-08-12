clc
clear

% Load intensity data from Excel files into the raster cell array
raster{1,1} = xlsread('intensity-14_a_1.xlsx');
raster{1,2} = xlsread('intensity-14_a_2.xlsx');
raster{1,3} = xlsread('intensity-14_a_3.xlsx');
save original_data

%%
ExpT = length(raster); % Number of experiments/time points
[~, CellNum] = size(raster{1,1}); % Number of cells (columns)

% Load cell position data; if unavailable, generate random positions
position_xy_0 = rand(2, CellNum);  % If no position coordinates, generate random
position_xy_0 = xlsread('position_a_2.xlsx'); % Read actual position from file
position_xy_0 = position_xy_0'; % Transpose to match expected orientation

% Adjust y-axis to flip sign (if needed)
position_xy(1, :) = position_xy_0(1, :);
position_xy(2, :) = -position_xy_0(2, :);

% Initialize matrices to store co-activation counts and randomized controls
Line_Cell = zeros(CellNum);    
Line_Cell_rand = zeros(CellNum);
N_rand = 1000;  % Number of random permutations for null model

ind_1 = 1:CellNum; % Indices of all cells

% Loop over each experimental condition / timepoint
for ci = 1:ExpT
    disp(['Processing experiment: ', num2str(ci)]);
    tic
    % Compare each unique cell pair (upper triangular matrix)
    for cell_i = 1:length(ind_1)-1
        for cell_j = cell_i+1:length(ind_1)
            % Extract spike trains or event vectors for each cell
            DR1 = raster{1, ci}(:, ind_1(cell_i));
            DR2 = raster{1, ci}(:, ind_1(cell_j));
            
            % Sum of events for both cells at each timepoint
            SR1 = DR1 + DR2;
            SR_ind = find(SR1 == 2); % Time points where both cells are active
            
            if ~isempty(SR_ind)
                % Update actual co-activation count for this cell pair
                Line_Cell(cell_i, cell_j) = Line_Cell(cell_i, cell_j) + length(SR_ind);
                Line_Cell(cell_j, cell_i) = Line_Cell(cell_i, cell_j); % Symmetric matrix
                
                % Randomization to get chance co-activation levels
                Line_Cell_rand_T = zeros(1, N_rand);
                for ri = 1:N_rand
                    % Randomly permute spike trains independently
                    DR1_r = DR1(randperm(500));
                    DR2_r = DR2(randperm(500));
                    SR1_r = DR1_r + DR2_r;
                    % Count co-activation in randomized data
                    Line_Cell_rand_T(ri) = length(find(SR1_r == 2));
                end
                
                % Average randomized co-activation count
                Line_Cell_rand(cell_i, cell_j) = Line_Cell_rand(cell_i, cell_j) + mean(Line_Cell_rand_T);
                Line_Cell_rand(cell_j, cell_i) = Line_Cell_rand(cell_i, cell_j); % Symmetric
            end
        end
    end
    toc
end

% Save the raw and randomized co-activation data
save Graph_rand_data

%%
% Calculate difference matrix by subtracting randomized co-activation from actual
Line_Cell_1 = Line_Cell - Line_Cell_rand;
Line_Cell_sum = sum(Line_Cell_1);

% Define the number of cells per group (modify as needed)
cellNum = [49 10 30 127];  % ************ Set number of cells per group here
cellNumCumsum = cumsum([0 cellNum]);

cellInd = [];
cellLabel = [];
% Assign group labels to cells for coloring and grouping
for ci = 1:4
    Ind_1 = cellNumCumsum(ci) + 1 : cellNumCumsum(ci + 1);
    cellInd = [cellInd Ind_1];
    cellLabel = [cellLabel ones(1, length(Ind_1)) * ci];
end

% Define colors for each group (RGB)
goupColor = [0.8 0.2 0.2;  % Group 1: reddish
             0.2 0.8 0.2;  % Group 2: greenish
             0.2 0.2 0.8;  % Group 3: bluish
             0.2 0.2 0.2]; % Group 4: gray

% Plotting connections between cells
figure; hold on
for cell_i = 1:length(ind_1)-1
    for cell_j = cell_i+1:length(ind_1)
        if Line_Cell_1(cell_j, cell_i) > 1 % Threshold for plotting
            LineW = Line_Cell_1(cell_i, cell_j)^1;
            cellx = [position_xy(1, ind_1(cell_i)) position_xy(1, ind_1(cell_j))];
            celly = [position_xy(2, ind_1(cell_i)) position_xy(2, ind_1(cell_j))];
            if cellLabel(cell_i) == cellLabel(cell_j)
                % Plot edges in group color if same group
                plot(cellx, celly, 'LineWidth', Line_Cell(cell_j, cell_i)^2 / 300, 'Color', goupColor(cellLabel(cell_i), :))
            else
                % Plot edges in gray if between groups
                plot(cellx, celly, 'LineWidth', Line_Cell(cell_j, cell_i)^2 / 300, 'Color', [1 1 1]*0.5)
            end
        end
    end
end

% Plot cells as scatter points sized by their summed connection strength
K = 2; % Scaling factor for marker size
for cell_i = 1:length(ind_1)
    s = scatter(position_xy(1, cell_i), position_xy(2, cell_i), Line_Cell_sum(cell_i)*K + K);
    s.MarkerEdgeColor = 'none';
    s.MarkerFaceColor = goupColor(cellLabel(cell_i), :);
end

% Plot heatmap of the co-activation matrix
cellCounts = length(ind_1);
figure; hold on
imagesc(Line_Cell_1)
axis equal
axis([0 cellCounts 0 cellCounts] + 0.5)
% Draw lines to separate groups on the matrix
plot([cellNumCumsum; cellNumCumsum] + 0.5, repmat([0; cellCounts], 1, 4) + 0.5, 'w-', 'LineWidth', 1)
plot(repmat([0; cellCounts], 1, 4) + 0.5, [cellNumCumsum; cellNumCumsum] + 0.5, 'w-', 'LineWidth', 1)
set(gca, 'YDir', 'reverse')

% Export summed co-activation data to Excel
xlswrite('Line_Cell_sum.xlsx', Line_Cell_sum);
