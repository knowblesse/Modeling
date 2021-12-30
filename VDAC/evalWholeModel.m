function likelihood = evalWholeModel(X, schedule, model, Exp_high_mean, Exp_high_sd, Exp_low_mean, Exp_low_sd)
%+---+---+--------+--------+---+---------+
%| 1 | 2 | 3      | 4      | 5 | 6       |
%+---+---+--------+--------+---+---------+
%| a | b | lr_acq | lr_ext | k | epsilon |
%+---+---+--------+--------+---+---------+
%% Schedule
schedule_training = schedule.schedule_training;
schedule_training_repeat = schedule.schedule_training_repeat;
schedule_training_N = schedule.schedule_training_N;

schedule_testing = schedule.schedule_testing;
schedule_testing_repeat = schedule.schedule_testing_repeat;
schedule_testing_N = schedule.schedule_testing_N;

%% Parameters
num_repeat = 100;
numBinModel = 30; % number of bins to divide the V or alpha
param = getDefaultParam();
param.M.lr_acq.value = X(3);
param.M.lr_ext.value = X(4);
param.M.k.value = X(5);
param.M.epsilon.value = X(6);

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

V_high = histcounts(V(schedule_training_N+1:end,1,:),linspace(0,1,numBinModel + 1))/numel(V(schedule_training_N+1:end,1,:));
V_low  = histcounts(V(schedule_training_N+1:end,2,:),linspace(0,1,numBinModel + 1))/numel(V(schedule_training_N+1:end,2,:));

Exp_high = normpdf(linspace(X(1), X(2), 30), Exp_high_mean, Exp_high_sd);
Exp_low  = normpdf(linspace(X(1), X(2), 30), Exp_low_mean, Exp_low_sd);

likelihood = - (V_high * Exp_high' + V_low * Exp_low');

end
