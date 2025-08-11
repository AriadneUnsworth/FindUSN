%% Performs k-means clustering to classify the datasets into 2 groups based on their mean and variability

clearvars -except Fig3Ddata highsync lowsync;  
% Clear all variables except those needed: Fig3Ddata, highsync, lowsync

% Copy data for manipulation to avoid overwriting original variables
ftemp = Fig3Ddata;   
hstemp = highsync;   
lstemp = lowsync;


% Calculate differences between consecutive rows (2-3, 3-4, 4-5) for each dataset
for i = 2:4
    ftempD(i-1,:) = ftemp(i,:) - ftemp(i+1,:);   % Differences in Fig3Ddata
    hstempD(i-1,:) = hstemp(i,:) - hstemp(i+1,:); % Differences in highsync
    lstempD(i-1,:) = lstemp(i,:) - lstemp(i+1,:); % Differences in lowsync
end

% Compute mean values across all rows for original datasets
ftempMean = mean(ftemp);
hstempMean = mean(hstemp);
lstempMean = mean(lstemp);

% Compute standard deviation of the differences (variability measure)
ftempSD = std(ftempD);
hstempSD = std(hstempD);
lstempSD = std(lstempD);

% Plot mean vs. standard deviation for Fig3Ddata with markers (no lines)
plot(ftempMean, ftempSD, 'LineStyle', 'none', 'Marker', 'o');
hold on

% Plot mean vs. standard deviation for highsync
plot(hstempMean, hstempSD, 'LineStyle', 'none', 'Marker', 'o');

% Plot mean vs. standard deviation for lowsync
plot(lstempMean, lstempSD, 'LineStyle', 'none', 'Marker', 'o');

hold off

% Set axis limits for better visualization
xlim([0, 1]);
ylim([0, 0.3]);

% Prepare data matrix X combining means and standard deviations for clustering
% Each row corresponds to a dataset (Fig3Ddata, lowsync, highsync)
X = [ftempMean, lstempMean, hstempMean;  % Means
     ftempSD,   lstempSD,   hstempSD]';   % Standard deviations

% Configure k-means options to display final output
opts = statset('Display','final');

% Perform k-means clustering with 2 clusters on the data matrix X
[idx, C] = kmeans(X, 2, 'Distance', 'sqeuclidean', 'Replicates', 5, 'Options', opts);

% Plot clustering results
figure;

% Plot points assigned to cluster 1 in red circles
plot(X(idx==1,1), X(idx==1,2), 'r.', 'Marker', 'o')
hold on

% Plot points assigned to cluster 2 in blue circles
plot(X(idx==2,1), X(idx==2,2), 'b.', 'Marker', 'o')

% Plot cluster centroids as black crosses
plot(C(:,1), C(:,2), 'kx', 'MarkerSize', 15, 'LineWidth', 3)

% Add legend and title
legend('Cluster 1', 'Cluster 2', 'Centroids', 'Location', 'NW')
title('Cluster Assignments and Centroids')

hold off

% Set axis limits for the cluster plot
xlim([0, 1]);
ylim([0, 0.3]);
