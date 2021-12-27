%% parameters
tic;
addpath('..');
addpath('../helper_function');

model = 'SPH';
numBinModel = 30; % number of bins to divide the V or alpha
num_repeat = 100;

%% fmincon

opts = optimoptions('fmincon','Display', 'off');

fitLowerbound = [-30, -30];
fitUpperbound = [+30, +30];

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

schedule_testing = [...
    [1,0,0,0,0];
    [0,1,0,0,0];
    [0,0,0,0,0];
    [0,0,0,0,0];
    ]; % * 120 

%% Repeat with parameter
param = getDefaultParam();
minLogLikelihood = 0;
bestParam = [];
for beta_ex = 1 : numel(param.SPH.beta_ex.range)
    param.SPH.beta_ex.value = param.SPH.beta_ex.range(beta_ex);
    
    for beta_in = 1 : numel(param.SPH.beta_in.range)
        param.M.lr_ext.value = param.SPH.beta_in.range(beta_in);
        
        if param.SPH.beta_in.value >= param.SPH.beta_ex.value
            continue;
        else
            for gamma = 1 : numel(param.SPH.gamma.range)
                param.SPH.gamma.value = param.SPH.gamma.range(gamma);

                %% Run
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


figure(2);
clf(2);
plot(V_high,'r');
hold on;
plot(V_low,'b');
plot(normpdf(linspace(fittedLinearTransform(1), fittedLinearTransform(2), 30), Exp_high_mean, Exp_high_sd),'r--');
plot(normpdf(linspace(fittedLinearTransform(1), fittedLinearTransform(2), 30), Exp_low_mean, Exp_low_sd),'b--');
% t = text('log likelihood = -0.2519',25,0.15)
title('SPH');