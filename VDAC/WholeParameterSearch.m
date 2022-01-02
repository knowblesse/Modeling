%% WholeParameterSearch
% Parameter Fitting Script

%% parameters

addpath('..');
addpath('../helper_function');
addpath('./experiments');

num_repeat = 200;

%% Load Experiment
Anderson_2011;

%% Optimization parameters
opts = optimoptions('fmincon',...
    'Display', 'none',...
    'StepTolerance', 1e-3,... % smaller is best ? but takes a bit more time. 1e-3 : rule of thumb
    'Algorithm', 'sqp',... % default (int. point) is faster, but tend to be not accurate near constraints. 
    'MaxFunctionEvaluations', 10000,... % usually this means nothing
    'MaxIterations', 5000,... % this too. 
    'PlotFcn', 'optimplotfvalconstr',...
    'FiniteDifferenceType', 'central',... % when calculating the gradient, calculate both sides
    'FiniteDifferenceStepSize', 1e-2); % 1e-2 was the best

%% Run Through Models
%models = {'RW', 'M', 'SPH', 'EH'};
models = {'SPH'};
for model = models
    %% Load Parameters
    [param, opt_option] = getDefaultParam();
    fitLowerbound = ltp_lowerbound;
    fitUpperbound = ltp_upperbound;
    x0 = ltp_x0;
    model = model{1};
    modelParam = eval(strcat('param.',model));
    fnames = fieldnames(modelParam);
    for fn = 1 : numel(fieldnames(modelParam))
        struct_param = modelParam.(fnames{fn});
        struct_param_range = struct_param.range;
        fitLowerbound = [fitLowerbound, struct_param_range(1)];
        fitUpperbound = [fitUpperbound, struct_param_range(end)];
        x0 = [x0, struct_param.value];
    end

    A_temp = opt_option.(model).A;
    A = zeros(1 + size(A_temp,1), 2 + size(A_temp,2));
    A(1,1:2) = [1,-1];
    A(2:end,3:end) = A_temp;

    b = [0,opt_option.(model).b]'; 
    
    %% Run Optimization
    fitfunction = @(X) evalWholeModel(X, schedule, model, num_repeat, Exp_high_mean, Exp_high_sd, Exp_low_mean, Exp_low_sd);

    [x, fval, exitflag, output] = fmincon(fitfunction, x0, A, b, [], [], fitLowerbound, fitUpperbound, [], opts);
                        
    %% Print result
    fprintf('-----------%5s------------\n', model);
    fprintf('Negative Log Likelihood : %f\n', fval);
    fprintf('Best Param :\n');
    fprintf('Lin param : %.3f , %.3f\n', x(1), x(2));  
    for fn = 1 : numel(fieldnames(modelParam))
        fprintf('%10s : %.3f\n', fnames{fn}, x(2+fn));
    end
end
