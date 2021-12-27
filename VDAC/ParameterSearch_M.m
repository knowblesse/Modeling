%% ParameterSearch_M
% Parameter Fitting Script for Mackintosh Model
% 

%% Experiment Data
RT_none.T1008 = 665;
RT_low.T1008 = 673;
RT_high.T1008 = 681;

Exp_high_mean = RT_high.T1008 - RT_none.T1008;
Exp_high_sd = 2.8;
Exp_low_mean = RT_low.T1008 - RT_none.T1008;
Exp_low_sd = 2.8;

exp1_high_reward = 1; %5 cents
exp1_low_reward = 0.2; %1 cents

%% Experiment Schedule
schedule_training = [...
    repmat([1,0,0,1,exp1_high_reward],4,1);...
    repmat([1,0,0,1,exp1_low_reward],1,1);...
    repmat([0,1,0,1,exp1_high_reward],1,1);...
    repmat([0,1,0,1,exp1_low_reward],4,1);...
    ]; % thesis : 1008 trials vs Modeling : 1010 trials (10 trial set * 101)
schedule_training_repeat = 101;
schedule_training_N = size(schedule_training,1) * schedule_training_repeat;

schedule_testing = [...
    [1,0,0,0,0];
    [0,1,0,0,0];
    [0,0,0,0,0];
    [0,0,0,0,0];
    ]; % * 120 
schedule_testing_repeat = 120;
schedule_testing_N = size(schedule_testing,1) * schedule_testing_repeat;

%% parameters

addpath('..');
addpath('../helper_function');

model = 'M';
numBinModel = 30; % number of bins to divide the V or alpha
num_repeat = 100;

%% optimization parameters

opts = optimoptions('fmincon','Display', 'off');

fitLowerbound = [-30, -30];
fitUpperbound = [+30, +30];


%% Repeat with parameter
param = getDefaultParam();
minLogLikelihood = 0;
bestParam = [];
for lr_acq = 1 : numel(param.M.lr_acq.range)
    param.M.lr_acq.value = param.M.lr_acq.range(lr_acq);
    
    for lr_ext = 1 : numel(param.M.lr_ext.range)
        param.M.lr_ext.value = param.M.lr_ext.range(lr_ext);
        
        if param.M.lr_ext.value >= param.M.lr_acq.value
            % check acquisition learning rate is always greater than the extinction learning rate
            continue
        else
            for k = 1 : numel(param.M.k.range)
                param.M.k.value = param.M.k.range(k);

                for epsilon = 1 : numel(param.M.epsilon.range)
                    param.M.epsilon.value = param.M.epsilon.range(epsilon);
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
                    V_low = histcounts(V(schedule_training_N+1:end,2,:),linspace(0,1,numBinModel + 1))/numel(V(schedule_training_N+1:end,2,:));

                    %a1 = histcounts(alpha(1011:end,1,:),linspace(0,1,numBinModel + 1));
                    %a2 = histcounts(alpha(1011:end,2,:),linspace(0,1,numBinModel + 1));
                    
                    fitfunction = @(X) evalModel(X, V_high, V_low, Exp_high_mean, Exp_high_sd, Exp_low_mean, Exp_low_sd);
                    
                    [x, fval] = fmincon(fitfunction, [0,30], [1,-1], [1], [], [], fitLowerbound, fitUpperbound, [], opts);
                    
                    if fval < minLogLikelihood
                        minLogLikelihood = fval;
                        bestParam = param;
                        fittedLinearTransform = x;
                    end
                    fprintf('log-likelihood = %f\n', fval);
                end
               
            end
        end
    end
end

