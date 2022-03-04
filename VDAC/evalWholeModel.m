function [negativeloglikelihood, V, alpha, Model_high, Model_low, Exp_high, Exp_low, Model_element_number] = evalWholeModel(X, schedule, model, num_repeat, Exp_high_mean, Exp_high_sd, Exp_low_mean, Exp_low_sd, mode)
%% evalWholeModel
% Generate Experiment and Model Distribution and calculate negative log likelihood. 
% Param 
% X : The first two factors are for the linear transformation of the V or alpha value.
%     X(1) * V + X(2) = Experiment Result factor (ex. RT, accuracy)

%% Schedule
schedule_training = schedule.schedule_training;
schedule_training_repeat = schedule.schedule_training_repeat;
schedule_training_N = schedule.schedule_training_N;

schedule_testing = schedule.schedule_testing;
schedule_testing_repeat = schedule.schedule_testing_repeat;
schedule_testing_N = schedule.schedule_testing_N;

%% Parameters
numBinModel = 30; % number of bins to divide the V or alpha
param = getDefaultParam();
fnames = fieldnames(param.(model));
for fn = 1 : numel(fieldnames(param.(model)))
    param.(model).(fnames{fn}).value = X(2+fn);
end

%% Run
V = zeros(schedule_training_N + schedule_testing_N,3,num_repeat);
alpha = zeros(schedule_training_N + schedule_testing_N,3,num_repeat);

for r = 1 : num_repeat
    % Shuffle schedule for repeated simulation
    schedule_shuffled = [shuffle1D(repmat(schedule_training,schedule_training_repeat,1)); shuffle1D(repmat(schedule_testing,schedule_testing_repeat,1))];

    [outV, outAlpha] = SimulateModel(schedule_shuffled,model, param);

    V(:,:,r) = outV; % [trial, cs type, repeat]
    alpha(:,:,r) = outAlpha;
end

%% Generate Experiment & Model Distribution for plotting
Exp_high = normpdf(X(1)*linspace(0, 1, 30)+X(2), Exp_high_mean, 3);
Exp_low  = normpdf(X(1)*linspace(0, 1, 30)+X(2), Exp_low_mean, 3);
if strcmp(mode, 'V')
    Model_high_result = V(schedule_training_N+1:end,1,:);
    Model_low_result = V(schedule_training_N+1:end,2,:);
elseif strcmp(mode, 'alpha')
    Model_high_result = alpha(schedule_training_N+1:end,1,:);
    Model_low_result = alpha(schedule_training_N+1:end,2,:);
else
    error('wrong mode');
end

Model_element_number = (num_repeat * schedule_testing_N);
Model_high = histcounts(Model_high_result,linspace(0,1,numBinModel + 1))/Model_element_number;
Model_low  = histcounts(Model_low_result,linspace(0,1,numBinModel + 1))/Model_element_number;

%% Calculate Negative Log Likelihood
negativeloglikelihood = -(...
    sum(log(normpdf(X(1)*reshape(Model_high_result, [], 1)+X(2), Exp_high_mean, 3))) + ...
    sum(log(normpdf(X(1)*reshape(Model_low_result, [], 1)+X(2), Exp_low_mean, 3)))...
    );
end
