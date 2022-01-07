%% ParameterSearch_SPH
% Parameter Fitting Script for SPH Model
% 

%% parameters

addpath('..');
addpath('../helper_function');
addpath('./experiments');

Anderson_2011;

model = 'SPH';
numBinModel = 30; % number of bins to divide the V or alpha
num_repeat = 100;

%% optimization parameters
opts = optimoptions('fmincon',...
    'Display', 'none',...
    'StepTolerance', 1e-3,... % smaller is best ? but takes a bit more time. 1e-3 : rule of thumb
    'Algorithm', 'sqp',... % default (int. point) is faster, but tend to be not accurate near constraints. 
    'MaxFunctionEvaluations', 10000,... % usually this means nothing
    'MaxIterations', 5000,... % this too. 
    'FiniteDifferenceType', 'central',... % when calculating the gradient, calculate both sides
    'FiniteDifferenceStepSize', 1e-2); % 1e-2 was the best

%% Repeat with parameter
param = getDefaultParam();
minLogLikelihood = 0;
bestParam = [];
for S = 1 : numel(param.SPH.S.range)
    param.SPH.S.value = param.SPH.S.range(S);
    for beta_ex = 1 : numel(param.SPH.beta_ex.range)
        param.SPH.beta_ex.value = param.SPH.beta_ex.range(beta_ex);
        
        for beta_in = 1 : numel(param.SPH.beta_in.range)
            param.SPH.beta_in.value = param.SPH.beta_in.range(beta_in);
            
            if param.SPH.beta_in.value >= param.SPH.beta_ex.value
                % check acquisition learning rate is always greater than the extinction learning rate
                continue;
            else
                for gamma = 1 : numel(param.SPH.gamma.range)
                    param.SPH.gamma.value = param.SPH.gamma.range(gamma);

                    %% Run
                    V = zeros(schedule.schedule_training_N + schedule.schedule_testing_N,3,num_repeat);
                    alpha = zeros(schedule.schedule_training_N + schedule.schedule_testing_N,3,num_repeat);

                    for r = 1 : num_repeat
                        % Shuffle schedule for repeated simulation
                        schedule_shuffled = [shuffle1D(repmat(schedule.schedule_training,schedule.schedule_training_repeat,1)); shuffle1D(repmat(schedule.schedule_testing,schedule.schedule_testing_repeat,1))];

                        [outV, outAlpha] = SimulateModel(schedule_shuffled,model, param);

                        V(:,:,r) = outV; % [trial, cs type, repeat]
                        alpha(:,:,r) = outAlpha;
                    end

                    V_high = histcounts(V(schedule.schedule_training_N+1:end,1,:),linspace(0,1,numBinModel + 1))/numel(V(schedule.schedule_training_N+1:end,1,:));
                    V_low = histcounts(V(schedule.schedule_training_N+1:end,2,:),linspace(0,1,numBinModel + 1))/numel(V(schedule.schedule_training_N+1:end,2,:));

                    %a1 = histcounts(alpha(1011:end,1,:),linspace(0,1,numBinModel + 1));
                    %a2 = histcounts(alpha(1011:end,2,:),linspace(0,1,numBinModel + 1));
                    
                    fitfunction = @(X) evalModel(X, V_high, V_low, Exp_high_mean, Exp_high_sd, Exp_low_mean, Exp_low_sd);
                    
                    [x, fval] = fmincon(fitfunction, ltp_x0, [1,-1], [1], [], [], ltp_lowerbound, ltp_upperbound, [], opts);
                    
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


param = bestParam;


V = zeros(1490,3,num_repeat);
alpha = zeros(1490,3,num_repeat);

for r = 1 : num_repeat
    % Shuffle schedule for repeated simulation
    schedule_shuffled = [shuffle1D(repmat(schedule.schedule_training,101,1)); shuffle1D(repmat(schedule.schedule_testing,120,1))];

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

plot(normpdf(linspace(x(1), x(2), 30), Exp_high_mean, Exp_high_sd),'r--');
plot(normpdf(linspace(x(1), x(2), 30), Exp_low_mean, Exp_low_sd),'b--');

% t = text('log likelihood = -0.2519',25,0.15)
title('fmincon');
