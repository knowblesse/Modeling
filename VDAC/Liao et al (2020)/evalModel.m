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
    schedule_shuffled = [];
    for s = 1 : numel(schedule.schedule)
        schedule_shuffled = [schedule_shuffled; shuffle1D(schedule.schedule{s})];
    end

    [outV, outAlpha] = SimulateModel(schedule_shuffled, model, param);

    V(:,:,r) = outV; % [trial, cs type, repeat]
    alpha(:,:,r) = outAlpha;
end

%% Generate Experiment Distribution
BlockSeparator = {91:186, 277:372, 463:558, 659:744};
likelihood = 0;
for i = 1 : 4
    ExperimentResult.OldHighDistractor.Distribution{i} = normpdf(linspace(X(1), X(2), 30), ExperimentData.OldHighDistractor.Mean(i), ExperimentData.OldHighDistractor.SD);
    ExperimentResult.LowDistractor.Distribution{i} = normpdf(linspace(X(1), X(2), 30), ExperimentData.LowDistractor.Mean(i), ExperimentData.LowDistractor.SD);
    ExperimentResult.NewHighDistractor.Distribution{i} = normpdf(linspace(X(1), X(2), 30), ExperimentData.NewHighDistractor.Mean(i), ExperimentData.NewHighDistractor.SD);

    if strcmp(mode, 'V')
        SimulationResult.OldHighDistractor.Distribution{i} = histcounts(V(BlockSeparator{i},1,:),linspace(0,1,numBinModel + 1))/numel(V(BlockSeparator{i},1,:));
        SimulationResult.LowDistractor.Distribution{i} = histcounts(V(BlockSeparator{i},2,:),linspace(0,1,numBinModel + 1))/numel(V(BlockSeparator{i},2,:));
        SimulationResult.NewHighDistractor.Distribution{i} = histcounts(V(BlockSeparator{i},3,:),linspace(0,1,numBinModel + 1))/numel(V(BlockSeparator{i},3,:));
    elseif strcmp(mode, 'alpha')
        SimulationResult.OldHighDistractor.Distribution{i} = histcounts(alpha(BlockSeparator{i},1,:),linspace(0,1,numBinModel + 1))/numel(alpha(BlockSeparator{i},1,:));
        SimulationResult.LowDistractor.Distribution{i} = histcounts(alpha(BlockSeparator{i},2,:),linspace(0,1,numBinModel + 1))/numel(alpha(BlockSeparator{i},2,:));
        SimulationResult.NewHighDistractor.Distribution{i} = histcounts(alpha(BlockSeparator{i},3,:),linspace(0,1,numBinModel + 1))/numel(alpha(BlockSeparator{i},3,:));
    else
        error('wrong mode');
    end

    % Calculate the likelihood
    likelihood = likelihood - (...
        ExperimentResult.OldHighDistractor.Distribution{i} * SimulationResult.OldHighDistractor.Distribution{i}' + ...
        ExperimentResult.LowDistractor.Distribution{i} * SimulationResult.LowDistractor.Distribution{i}' + ...    
        ExperimentResult.NewHighDistractor.Distribution{i} * SimulationResult.NewHighDistractor.Distribution{i}');
        
end
end
