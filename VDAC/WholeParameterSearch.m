%% WholeParameterSearch
% Parameter Fitting Script

%% parameters

addpath('..');
addpath('../helper_function');

model = 'M';
num_repeat = 100;

%% optimization parameters

opts = optimoptions('fmincon', 'Display', 'none', 'StepTolerance', 1e-2, 'MaxFunctionEvaluations', 10000, 'MaxIterations', 5000);

fitLowerbound = [ltp_lowerbound, 0.01, 0.01, 0.01, 0.01];
fitUpperbound = [ltp_upperbound, +30, 0.1, 0.1, 0.30, 0.30];
x0 =            [6.4639,    23.9473, 0.08, 0.04, 0.20, 0.02];


%% Repeat with parameter
param = getDefaultParam();
minLogLikelihood = 0;
bestParam = [];
model = 'M';
                    
fitfunction = @(X) evalWholeModel(X, schedule, model, Exp_high_mean, Exp_high_sd, Exp_low_mean, Exp_low_sd);

[x, fval] = fmincon(fitfunction, x0, [1,-1,0,0,0,0;0,0,-1,1,0,0], [0,0], [], [], fitLowerbound, fitUpperbound, [], opts);
                    
bestParam = getDefaultParam();
bestParam.M.lr_acq.value = x(3);
bestParam.M.lr_ext.value = x(4);
bestParam.M.k.value = x(5);
bestParam.M.epsilon.value = x(6);

param = bestParam;

%% Print result
fprintf('Negative Log Likelihood : %f\n', fval);
fprintf('Best Param : %f, %f, %f, %f\n', param.M.lr_acq.value, param.M.lr_ext.value, param.M.k.value, param.M.epsilon.value);
