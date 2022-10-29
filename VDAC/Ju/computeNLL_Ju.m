function [negativeloglikelihood, V, alpha, SimulationResult, ExperimentResult, Model_element_number] = computeNLL_Ju(X, schedule, model, num_repeat, ExperimentData, value)
%% Parameters
numBinModel = 50; % number of bins to divide the V or alpha
param = getDefaultParam();
fnames = fieldnames(param.(model));
for fn = 1 : numel(fieldnames(param.(model)))
    param.(model).(fnames{fn}).value = X(2+fn);
end

%% Parse schedule
scheduleA = schedule{1};
scheduleB = schedule{2};

%% Parse ExperimentData
ExperimentAData = ExperimentData{1};
ExperimentBData = ExperimentData{2};

%% Run
V_A = zeros(scheduleA.schedule_training_N,3,num_repeat);
alpha_A = zeros(scheduleA.schedule_training_N,3,num_repeat);
V_B = zeros(scheduleB.schedule_training_N,3,num_repeat);
alpha_B = zeros(scheduleB.schedule_training_N,3,num_repeat);

for r = 1 : num_repeat
    % Shuffle schedule for repeated simulation
    scheduleA_shuffled = [shuffle1D(repmat(scheduleA.schedule_training, scheduleA.schedule_training_repeat,1))];
    scheduleB_shuffled = [shuffle1D(repmat(scheduleB.schedule_training, scheduleB.schedule_training_repeat,1))];

    [outV_A, outAlpha_A] = SimulateModel(scheduleA_shuffled, model, param);
    [outV_B, outAlpha_B] = SimulateModel(scheduleB_shuffled, model, param);

    V_A(:,:,r) = outV_A; % [trial, cs type, repeat]
    V_B(:,:,r) = outV_B; % [trial, cs type, repeat]
    alpha_A(:,:,r) = outAlpha_A;
    alpha_B(:,:,r) = outAlpha_B;
end

%% Generate Experiment Distribution
negativeloglikelihood = 0;

% Generate Experiment Distribution
ExperimentAResult.HighPred.Distribution = normpdf(X(1)*(linspace(0,1,numBinModel)+X(2)), ExperimentAData.High_Predictiveness_mean, 3);
ExperimentAResult.HighUnct.Distribution = normpdf(X(1)*(linspace(0,1,numBinModel)+X(2)), ExperimentAData.High_Uncertainty_mean, 3);
ExperimentBResult.HighPred.Distribution = normpdf(X(1)*(linspace(0,1,numBinModel)+X(2)), ExperimentBData.High_Predictiveness_mean, 3);
ExperimentBResult.HighUnct.Distribution = normpdf(X(1)*(linspace(0,1,numBinModel)+X(2)), ExperimentBData.High_Uncertainty_mean, 3);

% Concatenate Simulation Result
if strcmp(value, 'V')
    SimulationAResult.HighPred.Result = V_A(:,1,:); 
    SimulationAResult.HighUnct.Result = V_A(:,2,:); 
    SimulationBResult.HighPred.Result = V_B(:,1,:); 
    SimulationBResult.HighUnct.Result = V_B(:,2,:); 
elseif strcmp(value, 'alpha')
    SimulationAResult.HighPred.Result = alpha_A(:,1,:); 
    SimulationAResult.HighUnct.Result = alpha_A(:,2,:); 
    SimulationBResult.HighPred.Result = alpha_B(:,1,:); 
    SimulationBResult.HighUnct.Result = alpha_B(:,2,:); 
else
    error('wrong mode');
end

%Generate Simulation Distribution
Model_element_number = (scheduleA.schedule_training_N + scheduleB.schedule_training_N) * num_repeat * 2; % multiple 2 for two types of distractor
SimulationAResult.HighPred.Distribution = histcounts(SimulationAResult.HighPred.Result, linspace(0,1,numBinModel + 1))/(scheduleA.schedule_training_N*num_repeat);
SimulationAResult.HighUnct.Distribution = histcounts(SimulationAResult.HighUnct.Result, linspace(0,1,numBinModel + 1))/(scheduleA.schedule_training_N*num_repeat);
SimulationBResult.HighPred.Distribution = histcounts(SimulationBResult.HighPred.Result, linspace(0,1,numBinModel + 1))/(scheduleB.schedule_training_N*num_repeat);
SimulationBResult.HighUnct.Distribution = histcounts(SimulationBResult.HighUnct.Result, linspace(0,1,numBinModel + 1))/(scheduleB.schedule_training_N*num_repeat);

%% Calculate Negative Log Likelihood
negativeloglikelihood = negativeloglikelihood - (...
    sum(log(normpdf(X(1)*(reshape(SimulationAResult.HighPred.Result, [], 1)+X(2)), ExperimentAData.High_Predictiveness_mean, 3))) + ...
    sum(log(normpdf(X(1)*(reshape(SimulationAResult.HighUnct.Result, [], 1)+X(2)), ExperimentAData.High_Uncertainty_mean, 3))) + ...
    sum(log(normpdf(X(1)*(reshape(SimulationBResult.HighPred.Result, [], 1)+X(2)), ExperimentBData.High_Predictiveness_mean, 3))) + ...
    sum(log(normpdf(X(1)*(reshape(SimulationBResult.HighUnct.Result, [], 1)+X(2)), ExperimentBData.High_Uncertainty_mean, 3))) ...
    );

SimulationResult = {SimulationAResult, SimulationBResult};
ExperimentResult = {ExperimentAResult, ExperimentBResult};
V = {V_A, V_B};
alpha = {alpha_A, alpha_B};

end
