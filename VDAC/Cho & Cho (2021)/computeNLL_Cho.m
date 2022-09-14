function [negativeloglikelihood, V, alpha, SimulationResult, ExperimentResult, Model_element_number] = computeNLL_Cho(X, schedule, model, num_repeat, ExperimentData, value)
%% computeNLL_Cho
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
    schedule_shuffled = [...
        shuffle1D(repmat(schedule.schedule_training, schedule.schedule_training_repeat,1));...
        shuffle1D(repmat(schedule.schedule_testing, schedule.schedule_testing_repeat,1))];

    [outV, outAlpha] = SimulateModel(schedule_shuffled, model, param);

    V(:,:,r) = outV; % [trial, cs type, repeat]
    alpha(:,:,r) = outAlpha;
end

%% Generate Experiment Distribution
BlockSeparator = {576+1:576+144, 576+144+1:576+144+144};
negativeloglikelihood = 0;
for i = 1 : 2
    % Generate Experiment Distribution
    ExperimentResult.UncertaintyDistractor.Distribution{i} = normpdf(X(1)*(linspace(0,1,numBinModel)+X(2)), ExperimentData.UncertaintyDistractor.Mean(i), ExperimentData.UncertaintyDistractor.SD);
    ExperimentResult.CertaintyDistractor.Distribution{i} = normpdf(X(1)*(linspace(0,1,numBinModel)+X(2)), ExperimentData.CertaintyDistractor.Mean(i), ExperimentData.CertaintyDistractor.SD);

    % Concatenate Simulation Result
    if strcmp(value, 'V')
        SimulationResult.UncertaintyDistractor.Result{i} = V(BlockSeparator{i},1,:); 
        SimulationResult.CertaintyDistractor.Result{i} = V(BlockSeparator{i},2,:); 
    elseif strcmp(value, 'alpha')
        SimulationResult.UncertaintyDistractor.Result{i} = alpha(BlockSeparator{i},1,:);
        SimulationResult.CertaintyDistractor.Result{i} = alpha(BlockSeparator{i},2,:);
    else
        error('wrong mode');
    end

    %Generate Simulation Distribution
    Model_element_number = (schedule.N * num_repeat);
    SimulationResult.UncertaintyDistractor.Distribution{i} = histcounts(SimulationResult.UncertaintyDistractor.Result{i}, linspace(0,1,numBinModel + 1))/(numel(BlockSeparator{i})*num_repeat);
    SimulationResult.CertaintyDistractor.Distribution{i} = histcounts(SimulationResult.CertaintyDistractor.Result{i}, linspace(0,1,numBinModel + 1))/(numel(BlockSeparator{i})*num_repeat);

    %% Calculate Negative Log Likelihood
    negativeloglikelihood = negativeloglikelihood - (...
        sum(log(normpdf(X(1)*(reshape(SimulationResult.UncertaintyDistractor.Result{i}, [], 1)+X(2)), ExperimentData.UncertaintyDistractor.Mean(i), ExperimentData.UncertaintyDistractor.SD))) + ...
        sum(log(normpdf(X(1)*(reshape(SimulationResult.CertaintyDistractor.Result{i}, [], 1)+X(2)), ExperimentData.CertaintyDistractor.Mean(i), ExperimentData.CertaintyDistractor.SD))) ...
        );
end
end
