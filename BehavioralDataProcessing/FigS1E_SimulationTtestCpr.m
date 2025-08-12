% Create a normal distribution with mean=0, std=0.26
pd = makedist('Normal','mu',0,'sigma',0.26);

% Draw 1000 random samples from the distribution
r = random(pd,[1000 1]);

% Plot histogram of the samples to visualize distribution
hist(r);

% Perform paired t-test between two columns of behav data
[h,p] = ttest(behav(:,1),behav(:,2));

% Copy the first two columns of behav data for manipulation
tbehav(:,1) = behav(:,1); 
tbehav(:,2) = behav(:,2);

% Create a new normal distribution with mean=0, std=0.2 for simulation noise
pd = makedist('Normal','mu',0,'sigma',0.2);

temp11 = [];  % Initialize array to store test results
Nt = 1000;    % Number of simulations

for i = 1:Nt
    % Generate random scaling factors (6x2 matrix) from pd, add 1 (to keep near original scale)
    r = random(pd,[6 2]) + 1;   
    
    % Multiply original behavioral data by random factors to simulate variability
    tempbh(:,1:2) = tbehav(:,1:2) .* r;
    
    % Perform paired t-test on simulated data columns
    [h,p] = ttest(tempbh(:,1),tempbh(:,2));
    
    % Store test outcome h (0 or 1 for reject null) and p-value
    temp11(i,1) = h; 
    temp11(i,2) = p;
end

% Count how many simulated tests rejected the null hypothesis (h==1)
rtemp = length(find(temp11(:,1) == 1)); 

% Calculate match rate: proportion of simulations showing significance
matchrate = rtemp / Nt;

% Perform t-test between column 1 and column 3 of original behav data (not used in loop)
[hk,pk] = ttest(behav(:,1),behav(:,3));

% Prepare X-axis values for plotting (all set to 1 for violin plot positioning)
xais1 = zeros(1000,1) + 1;

% Plot violin plot of all simulated p-values (distribution shape + density)
violin(temp11(:,2));

% Set Y-axis limits to focus on p-values range of interest (0 to 0.1)
ylim([0 0.1]);

% The violin plot visualizes the distribution of 1000 simulated p-values from paired t-tests
% performed on fidgeting scores under simulated noise conditions.
%
% Remote memory retrieval induced significantly higher fidgeting compared to before, 
% even for these simulated p-values, with 99.6% of the values < 0.05.
%
% The X-axis (width) represents the density of p-values at each value on the Y-axis.
% The shape indicates that most simulated p-values cluster near zero, supporting the
% robustness of the significant behavioral effect observed in the real data.

