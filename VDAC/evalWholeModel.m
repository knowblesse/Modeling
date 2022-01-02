function likelihood = evalWholeModel(X, schedule, model, num_repeat, Exp_high_mean, Exp_high_sd, Exp_low_mean, Exp_low_sd)

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

V_high = histcounts(V(schedule_training_N+1:end,1,:),linspace(0,1,numBinModel + 1))/numel(V(schedule_training_N+1:end,1,:));
V_low  = histcounts(V(schedule_training_N+1:end,2,:),linspace(0,1,numBinModel + 1))/numel(V(schedule_training_N+1:end,2,:));

Exp_high = normpdf(linspace(X(1), X(2), 30), Exp_high_mean, Exp_high_sd);
Exp_low  = normpdf(linspace(X(1), X(2), 30), Exp_low_mean, Exp_low_sd);

likelihood = - (V_high * Exp_high' + V_low * Exp_low');

end
