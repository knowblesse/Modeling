%% WholeParameterSearch
% Parameter Fitting Script

%% parameters

addpath('..');
addpath('../helper_function');
addpath('./experiments');

Anderson_2011;
param = getDefaultParam();
model = 'M';
num_repeat = 100;

%% optimization parameters
opts = optimoptions('fmincon', 'Display', 'none', 'Algorithm', 'sqp', 'StepTolerance', 1e-2, 'MaxFunctionEvaluations', 10000, 'MaxIterations', 5000);

fitLowerbound = ltp_lowerbound;
fitUpperbound = ltp_upperbound;
x0 = ltp_x0;

modelParam = eval(strcat('param.',model));
for fn = 1 : numel(fieldnames(modelParam))
    fnames = fieldnames(modelParam);
    struct_param = getfield(modelParam, fnames{fn});
    struct_param_range = getfield(struct_param, 'range');
    fitLowerbound = [fitLowerbound, struct_param_range(1)];
    fitUpperbound = [fitUpperbound, struct_param_range(end)];
    x0 = [x0, getfield(struct_param, 'value')];
end

%fitLowerbound = [ltp_lowerbound, 0.01, 0.01, 0.01, 0.01];
%fitUpperbound = [ltp_upperbound, 0.1, 0.1, 0.30, 0.30];
%x0 =            [6.4639,    23.9473, 0.08, 0.04, 0.20, 0.02];

%% Repeat with parameter
param = getDefaultParam();
minLogLikelihood = 0;
bestParam = [];
                    
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
