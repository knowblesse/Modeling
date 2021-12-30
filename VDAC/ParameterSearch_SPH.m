%% ParameterSearch_SPH
% Parameter Fitting Script for SPH Model
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
% +--------+--------+--------+--------+---------------------------+
% | CS1    | CS2    | CS3    | US     | US intensity(reward size) |
% +--------+--------+--------+--------+---------------------------+
% | 1 or 0 | 1 or 0 | 1 or 0 | 1 or 0 | float                     |
% +--------+--------+--------+--------+---------------------------+
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
for beta_ex = 1 : numel(param.SPH.beta_ex.range)
    param.SPH.beta_ex.value = param.SPH.beta_ex.range(beta_ex);
    
    for beta_in = 1 : numel(param.SPH.beta_in.range)
        param.M.lr_ext.value = param.SPH.beta_in.range(beta_in);
        
        if param.SPH.beta_in.value >= param.SPH.beta_ex.value
            % check acquisition learning rate is always greater than the extinction learning rate
            continue;
        else
            for gamma = 1 : numel(param.SPH.gamma.range)
                param.SPH.gamma.value = param.SPH.gamma.range(gamma);

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



param = bestParam;


V = zeros(1490,3,num_repeat);
alpha = zeros(1490,3,num_repeat);

for r = 1 : num_repeat
    % Shuffle schedule for repeated simulation
    schedule_shuffled = [shuffle1D(repmat(schedule_training,101,1)); shuffle1D(repmat(schedule_testing,120,1))];

    [outV, outAlpha] = SimulateModel(schedule_shuffled,model, param);

    V(:,:,r) = outV; % [trial, cs type, repeat]
    alpha(:,:,r) = outAlpha;
end

V_high = histcounts(V(1011:end,1,:),linspace(0,1,numBinModel + 1))/numel(V(1011:end,1,:));
V_low = histcounts(V(1011:end,2,:),linspace(0,1,numBinModel + 1))/numel(V(1011:end,2,:));


figure(3);
clf(3);
plot(V_high,'r');
hold on;
plot(V_low,'b');
plot(normpdf(linspace(fittedLinearTransform(1), fittedLinearTransform(2), 30), Exp_high_mean, Exp_high_sd),'r--');
plot(normpdf(linspace(fittedLinearTransform(1), fittedLinearTransform(2), 30), Exp_low_mean, Exp_low_sd),'b--');

plot(normpdf(linspace(x(1), x(2), 30), Exp_high_mean, Exp_high_sd),'r--');
plot(normpdf(linspace(x(1), x(2), 30), Exp_low_mean, Exp_low_sd),'b--');

% t = text('log likelihood = -0.2519',25,0.15)
title('fmincon');
