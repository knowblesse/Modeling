function [negativeloglikelihood, V, alpha, SimulationResult, ExperimentResult, Model_element_number] = computeNLL3(X, schedule, model, num_repeat, ExperimentData, value)
%% computeNLL3
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
    for s = 1 : 10
        schedule_shuffled = [schedule_shuffled; shuffle1D(schedule.schedule)];
    end

    [outV, outAlpha] = SimulateModel(schedule_shuffled, model, param);

    V(:,:,r) = outV; % [trial, cs type, repeat]
    alpha(:,:,r) = outAlpha;
end

%% Generate Experiment Distribution
negativeloglikelihood = 0;
for i = 1 : 10
    % Generate Experiment Distribution
    ExperimentResult.HighDistractor.Distribution{i} = normpdf(X(1)*(linspace(0,1,numBinModel)+X(2)), ExperimentData.HighDistractor.Mean(i), ExperimentData.HighDistractor.SD);
    ExperimentResult.LowDistractor.Distribution{i} = normpdf(X(1)*(linspace(0,1,numBinModel)+X(2)), ExperimentData.LowDistractor.Mean(i), ExperimentData.LowDistractor.SD);

    % Concatenate Simulation Result
    if strcmp(value, 'V')
        SimulationResult.HighDistractor.Result{i} = V(100*(i-1)+1:100*i,1,:); 
        SimulationResult.LowDistractor.Result{i} = V(100*(i-1)+1:100*i,2,:); 
    elseif strcmp(value, 'alpha')
        SimulationResult.HighDistractor.Result{i} = alpha(100*(i-1)+1:100*i,1,:);
        SimulationResult.LowDistractor.Result{i} = alpha(100*(i-1)+1:100*i,2,:);
    else
        error('wrong mode');
    end

    %Generate Simulation Distribution
    Model_element_number = (schedule.N * num_repeat);
    SimulationResult.HighDistractor.Distribution{i} = histcounts(SimulationResult.HighDistractor.Result{i}, linspace(0,1,numBinModel + 1))/(100*num_repeat);
    SimulationResult.LowDistractor.Distribution{i} = histcounts(SimulationResult.LowDistractor.Result{i}, linspace(0,1,numBinModel + 1))/(100*num_repeat);

    %% Calculate Negative Log Likelihood
    negativeloglikelihood = negativeloglikelihood - (...
        sum(log(normpdf(X(1)*(reshape(SimulationResult.HighDistractor.Result{i}, [], 1)+X(2)), ExperimentData.HighDistractor.Mean(i), ExperimentData.HighDistractor.SD))) + ...
        sum(log(normpdf(X(1)*(reshape(SimulationResult.LowDistractor.Result{i}, [], 1)+X(2)), ExperimentData.LowDistractor.Mean(i), ExperimentData.LowDistractor.SD)))  ...
        );
end
end
