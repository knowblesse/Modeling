function [negativeloglikelihood, V, alpha, SimulationResult, ExperimentResult, Model_element_number] = computeNLL_Liao(X, schedule, model, num_repeat, ExperimentData, value)
%% computeNLL_Liao
% Generate Experiment Distribution and calculate negative log likelihood. 
% Param 
% X : The first two factors are for the linear transformation of the V or alpha value.
%     X(1) * (V + X(2)) = Experiment Result factor (ex. RT, accuracy)

%% Parameters
numBinModel = 50; % number of bins to divide the V or alpha
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
negativeloglikelihood = 0;
for i = 1 : 4
    % Generate Experiment Distribution
    ExperimentResult.OldHighDistractor.Distribution{i} = normpdf(X(1)*(linspace(0,1,numBinModel)+X(2)), ExperimentData.OldHighDistractor.Mean(i), ExperimentData.OldHighDistractor.SD);
    ExperimentResult.LowDistractor.Distribution{i} = normpdf(X(1)*(linspace(0,1,numBinModel)+X(2)), ExperimentData.LowDistractor.Mean(i), ExperimentData.LowDistractor.SD);
    ExperimentResult.NewHighDistractor.Distribution{i} = normpdf(X(1)*(linspace(0,1,numBinModel)+X(2)), ExperimentData.NewHighDistractor.Mean(i), ExperimentData.NewHighDistractor.SD);

    % Concatenate Simulation Result
    if strcmp(value, 'V')
        SimulationResult.OldHighDistractor.Result{i} = V(BlockSeparator{i},1,:); 
        SimulationResult.LowDistractor.Result{i} = V(BlockSeparator{i},2,:); 
        SimulationResult.NewHighDistractor.Result{i} = V(BlockSeparator{i},3,:); 
    elseif strcmp(value, 'alpha')
        SimulationResult.OldHighDistractor.Result{i} = alpha(BlockSeparator{i},1,:);
        SimulationResult.LowDistractor.Result{i} = alpha(BlockSeparator{i},2,:);
        SimulationResult.NewHighDistractor.Result{i} = alpha(BlockSeparator{i},3,:);
    else
        error('wrong mode');
    end

    %Generate Simulation Distribution
    Model_element_number = (schedule.N * num_repeat);
    SimulationResult.OldHighDistractor.Distribution{i} = histcounts(SimulationResult.OldHighDistractor.Result{i}, linspace(0,1,numBinModel + 1))/(numel(BlockSeparator{i})*num_repeat);
    SimulationResult.LowDistractor.Distribution{i} = histcounts(SimulationResult.LowDistractor.Result{i}, linspace(0,1,numBinModel + 1))/(numel(BlockSeparator{i})*num_repeat);
    SimulationResult.NewHighDistractor.Distribution{i} = histcounts(SimulationResult.NewHighDistractor.Result{i}, linspace(0,1,numBinModel + 1))/(numel(BlockSeparator{i})*num_repeat);

    %% Calculate Negative Log Likelihood
    negativeloglikelihood = negativeloglikelihood - (...
        sum(log(normpdf(X(1)*(reshape(SimulationResult.OldHighDistractor.Result{i}, [], 1)+X(2)), ExperimentData.OldHighDistractor.Mean(i), ExperimentData.NewHighDistractor.SD))) + ...
        sum(log(normpdf(X(1)*(reshape(SimulationResult.LowDistractor.Result{i}, [], 1)+X(2)), ExperimentData.LowDistractor.Mean(i), ExperimentData.LowDistractor.SD))) + ...
        sum(log(normpdf(X(1)*(reshape(SimulationResult.NewHighDistractor.Result{i}, [], 1)+X(2)), ExperimentData.NewHighDistractor.Mean(i), ExperimentData.NewHighDistractor.SD))) ...
        );
end
end
