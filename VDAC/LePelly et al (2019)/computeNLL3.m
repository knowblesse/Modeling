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
    schedule_shuffled = [
        shuffle1D(schedule.schedule{1});...
        shuffle1D(schedule.schedule{2});...
        ];

    [outV, outAlpha] = SimulateModel(schedule_shuffled, model, param);

    V(:,:,r) = outV; % [trial, cs type, repeat]
    alpha(:,:,r) = outAlpha;
end

%% Generate Experiment & Model Distribution for plotting
% Generate Experiment Distribution
ExperimentResult.HighDistractor.Distribution = normpdf(X(1)*(linspace(0, 1, numBinModel)+X(2)), ExperimentData.HighDistractor.Mean, ExperimentData.HighDistractor.SD);
ExperimentResult.LowDistractor.Distribution = normpdf(X(1)*(linspace(0, 1, numBinModel)+X(2)), ExperimentData.LowDistractor.Mean, ExperimentData.LowDistractor.SD);
ExperimentResult.NPDistractor.Distribution = normpdf(X(1)*(linspace(0, 1, numBinModel)+X(2)), ExperimentData.NPDistractor.Mean, ExperimentData.NPDistractor.SD);

% Concatenate Simulation Result
if strcmp(value, 'V')
    SimulationResult.HighDistractor.Result = V(:,1,:);
    SimulationResult.LowDistractor.Result = V(:,2,:);
    SimulationResult.NPDistractor.Result = V(:,3,:);
elseif strcmp(value, 'alpha')
    SimulationResult.HighDistractor.Result = alpha(:,1,:);
    SimulationResult.LowDistractor.Result = alpha(:,2,:);
    SimulationResult.NPDistractor.Result = alpha(:,3,:);
else
    error('wrong mode');
end

% Generate Simulation Distribution
Model_element_number = (schedule.N * num_repeat);
SimulationResult.HighDistractor.Distribution = histcounts(SimulationResult.HighDistractor.Result, linspace(0,1,numBinModel + 1))/Model_element_number;
SimulationResult.LowDistractor.Distribution = histcounts(SimulationResult.LowDistractor.Result, linspace(0,1,numBinModel + 1))/Model_element_number;
SimulationResult.NPDistractor.Distribution = histcounts(SimulationResult.NPDistractor.Result, linspace(0,1,numBinModel + 1))/Model_element_number;

%% Calculate Negative Log Likelihood
negativeloglikelihood = - (...
    sum(log(normpdf(X(1)*(reshape(SimulationResult.HighDistractor.Result, [], 1)+X(2)), ExperimentData.HighDistractor.Mean, ExperimentData.HighDistractor.SD))) + ...
    sum(log(normpdf(X(1)*(reshape(SimulationResult.LowDistractor.Result, [], 1)+X(2)), ExperimentData.LowDistractor.Mean, ExperimentData.LowDistractor.SD))) + ...
    sum(log(normpdf(X(1)*(reshape(SimulationResult.NPDistractor.Result, [], 1)+X(2)), ExperimentData.NPDistractor.Mean, ExperimentData.NPDistractor.SD))) ...
    );
end
