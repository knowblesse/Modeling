function [likelihood, V, alpha, SimulationResult, ExperimentResult] = evalModel(X, schedule, model, num_repeat, ExperimentData, mode)
% Using the fitting variables, simulate the model and compare with the experiment result
% The X is the fitting variable
% The first two X values are for the linear fitting of gaussian distributions
% Rest of the X values are for the model specific parameters.

%% Parameters
numBinModel = 30; % number of bins to divide the V or alpha

% Load Parameters from X(3:end) to param
param = getDefaultParam();
fnames = fieldnames(param.(model));
for fn = 1 : numel(fieldnames(param.(model)))
    param.(model).(fnames{fn}).value = X(2+fn);
end

%% Run
V = zeros(schedule.N,3,num_repeat);
alpha = zeros(schedule.N,3,num_repeat);

for r = 1 : num_repeat
    % Shuffle schedule for repeated simulation
    schedule_shuffled = [
        shuffle1D(schedule.schedule{1});...
        shuffle1D(schedule.schedule{2});...
        ];

    [outV, outAlpha] = SimulateModel(schedule_shuffled, model, param);

    V(:,:,r) = outV; % [trial, cs type, repeat]
    alpha(:,:,r) = outAlpha;
end

%% Generate Experiment Distribution
ExperimentResult.HighDistractor.Distribution = normpdf(linspace(X(1), X(2), 30), ExperimentData.HighDistractor.Mean, ExperimentData.HighDistractor.SD);
ExperimentResult.LowDistractor.Distribution = normpdf(linspace(X(1), X(2), 30), ExperimentData.LowDistractor.Mean, ExperimentData.LowDistractor.SD);
ExperimentResult.NPDistractor.Distribution = normpdf(linspace(X(1), X(2), 30), ExperimentData.NPDistractor.Mean, ExperimentData.NPDistractor.SD);

if strcmp(mode, 'V')
    SimulationResult.HighDistractor = histcounts(V(:,1,:),linspace(0,1,numBinModel + 1))/numel(V(:,1,:));
    SimulationResult.LowDistractor = histcounts(V(:,2,:),linspace(0,1,numBinModel + 1))/numel(V(:,2,:));
    SimulationResult.NPDistractor = histcounts(V(:,3,:),linspace(0,1,numBinModel + 1))/numel(V(:,3,:));
elseif strcmp(mode, 'alpha')
    SimulationResult.HighDistractor = histcounts(alpha(:,1,:),linspace(0,1,numBinModel + 1))/numel(alpha(:,1,:));
    SimulationResult.LowDistractor = histcounts(alpha(:,2,:),linspace(0,1,numBinModel + 1))/numel(alpha(:,2,:));
    SimulationResult.NPDistractor = histcounts(alpha(:,3,:),linspace(0,1,numBinModel + 1))/numel(alpha(:,3,:));
else
    error('wrong mode');
end

likelihood = - (...
    ExperimentResult.HighDistractor.Distribution * SimulationResult.HighDistractor' + ...
    ExperimentResult.LowDistractor.Distribution * SimulationResult.LowDistractor' + ...
    ExperimentResult.NPDistractor.Distribution * SimulationResult.NPDistractor' ... 
    );
end
