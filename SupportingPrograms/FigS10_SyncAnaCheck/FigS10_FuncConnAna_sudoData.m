%% Evaluate the Reliability of Functional Connectivity Analysis
% Generate simulated data for 2 neurons
% Control the spike firing rate
% Control the level of synchronous firing

clc
clear
% close all

%% Parameter settings
% *************************
para_Len = 1000;            % Length of the sequence (number of time points)
para_spikeRatio = 0.01;     % Proportion of time points with spikes (firing ratio)
para_synchRatio = 0.05:0.05:0.8;   % Proportion of synchronous spikes (synchrony ratio)
para_repeatNum = 10;        % Number of repetitions for the whole experiment
para_randNum = 100;         % Number of randomizations for calculating random cospike count
% *************************

%% Testing synchronous spike count vs. synchRatio

% Calculate the true number of synchronous spikes based on parameters
cospike_true = round(para_Len * para_spikeRatio * para_synchRatio);
cospike_cal = zeros(para_repeatNum, length(para_synchRatio)); % Store calculated cospike counts

for si = 1:length(para_synchRatio)
    for ri = 1:para_repeatNum
        % Generate spike trains spike1 and spike2 based on parameters

        % Randomly permute indices for the full length
        indrand = randperm(para_Len);

        % Indices for synchronous spikes (shared spikes)
        indCospike = indrand(1:cospike_true(si));

        % Remaining indices (non-synchronous spikes)
        indOther = indrand(cospike_true(si)+1:end);

        % Number of non-synchronous spikes per neuron
        num_nonCospike = para_Len * para_spikeRatio - cospike_true(si);

        % Assign some indices to only neuron 1
        indOnly1 = indOther(1:num_nonCospike);

        % Shuffle remaining indices again and assign to neuron 2
        indOther = indOther(randperm(length(indOther)));
        indOnly2 = indOther(1:num_nonCospike);

        % Initialize spike vectors
        spike1 = zeros(para_Len,1);
        spike1([indCospike indOnly1]) = 1; % neuron 1 spikes: synchronous + unique

        spike2 = zeros(para_Len,1);
        spike2([indCospike indOnly2]) = 1; % neuron 2 spikes: synchronous + unique

        % Calculate actual number of synchronous spikes
        conn_true = sum(spike1 + spike2 == 2);

        % Calculate synchronous spikes in randomized spike trains to estimate baseline
        conn_rand = zeros(para_randNum,1);
        for rand_i = 1:para_randNum
            spike1_rand = spike1(randperm(length(spike1)));
            spike2_rand = spike1(randperm(length(spike2)));
            conn_rand(rand_i,1) = sum(spike1_rand + spike2_rand == 2);
        end

        % Store the corrected cospike count (subtracting mean random baseline)
        cospike_cal(ri,si) = conn_true - mean(conn_rand);
    end
end

%% Visualization of synchronous spike counts and errors
figure
tiledlayout(1,3)

% Plot calculated cospike counts and true counts
nexttile; hold on; grid on
b = boxchart(cospike_cal);
b.JitterOutliers = 'on'; 
b.MarkerStyle = '.';
plot(cospike_true, 'r-', 'LineWidth', 2)
set(gca, 'XTickLabel', para_synchRatio)
xlabel('Synchrony ratio')
ylabel('Cospike count')
legend('Calculated', 'True')

% Calculate error values and error ratios
errValue = cospike_cal - repmat(cospike_true, para_repeatNum, 1);
errRatio = errValue ./ repmat(cospike_true, para_repeatNum, 1);

% Plot error values
nexttile; hold on; grid on
b = boxchart(errValue);
b.JitterOutliers = 'on'; 
b.MarkerStyle = '.';
set(gca, 'XTickLabel', para_synchRatio)
xlabel('Synchrony ratio')
ylabel('Error value')

% Plot error ratios
nexttile; hold on; grid on
b = boxchart(errRatio);
b.JitterOutliers = 'on'; 
b.MarkerStyle = '.';
set(gca, 'XTickLabel', para_synchRatio)
xlabel('Synchrony ratio')
ylabel('Error ratio')

set(gcf, 'Position', [100 100 750 250])


%% Control firing rate (spike ratio) effects
% 2024-02-08

clc
clear
% close all

%% Parameter settings for firing rate control
% *************************
para_Len = 1000;                % Sequence length (time points)
para_spikeRatio = 0.001:0.002:0.05;  % Range of firing ratios to test
para_repeatNum = 10;            % Number of repetitions per condition
para_randNum = 100;             % Number of randomizations (not used here, but kept)
% *************************

%% Testing effect of firing ratio on cospike count
cospike_cal = zeros(para_repeatNum, length(para_spikeRatio));

for si = 1:length(para_spikeRatio)
    cospike_true = round(para_Len * para_spikeRatio(si));
    for ri = 1:para_repeatNum
        % Generate spike trains with given firing ratio (random spikes)
        spike1 = zeros(para_Len,1);
        spike1(randperm(para_Len, cospike_true)) = 1;
        spike2 = zeros(para_Len,1);
        spike2(randperm(para_Len, cospike_true)) = 1;

        % Calculate number of synchronous spikes (overlap)
        cospike_cal(ri,si) = sum(spike1 + spike2 == 2);

        % % Random analysis commented out here
        % conn_rand = zeros(para_randNum,1);
        % for rand_i = 1:para_randNum
        %     spike1_rand = spike1(randperm(length(spike1)));
        %     spike2_rand = spike1(randperm(length(spike2)));
        %     conn_rand(rand_i,1) = sum(spike1_rand + spike2_rand == 2);
        % end
        % cospike_rnd(ri,si) = conn_true - mean(conn_rand);
    end
end

%% Visualization of cospike counts as function of firing ratio
figure
tiledlayout(1,3)

nexttile; hold on; grid on
plot(mean(cospike_cal,1), '-o');
% b.JitterOutliers = 'on'; b.MarkerStyle = '.';
% legend('calculated','true')

set(gca, 'XTickLabel', para_spikeRatio)
xlabel('Firing ratio')
ylabel('Cospike count')

% Error analysis commented out, can be added similarly if needed
% errValue = cospike_cal - repmat(cospike_true, para_repeatNum, 1);
% errRatio = errValue ./ repmat(cospike_true, para_repeatNum, 1);
% nexttile; hold on; grid on
% b = boxchart(errValue);
% b.JitterOutliers = 'on'; b.MarkerStyle = '.';
% set(gca, 'XTickLabel', para_synchRatio)
% xlabel('synch ratio')
% ylabel('error value')
% nexttile; hold on; grid on
% b = boxchart(errRatio);
% b.JitterOutliers = 'on'; b.MarkerStyle = '.';
% set(gca, 'XTickLabel', para_synchRatio)
% xlabel('synch ratio')
% ylabel('error ratio')

set(gcf, 'Position', [100 100 750 250])
