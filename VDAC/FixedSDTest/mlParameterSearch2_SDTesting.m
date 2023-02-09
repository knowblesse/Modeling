function mlParameterSearch2_SDTesting(experiment, value, models, sd) 
%% mlParameterSearch2 : maximum likelihood parameter search function
% Load the experiment data (exp) and run MultiStart optimization function to find parameters
% that make the lowest negative log-likelihood (= the maximum log-likelihood)
% This functions draws on two conditions
% Param
%   experiment : str : name of the experiment script
%   value : str : either 'V' or 'alph'             
%   models : cell : model lists. ex. {'RW', 'M'}
% 22 MAR 07
% 2022 Knowblesse

%% parameters
rng('shuffle');
addpath('../../helper_function');
addpath('../experiments');

num_repeat = 200;

CC.high = [231,124,141]./255; % stimulus condition where the RT should be longer than the low condition
CC.low = [94,165,197]./255; % stimulus condition where the RT should be shorter than the high condition

%% Load Experiment
if iscell(experiment)
    experiment = experiment{1};
end
eval(experiment);

if iscell(value)
    value = value{1};
end


%% Local Optimizer Options
opts = optimoptions('fmincon',...
    'Display', 'none',...
    'StepTolerance', 1e-3,... % smaller is best ? but takes a bit more time. 1e-3 : rule of thumb
    'Algorithm', 'sqp',... % default (int. point) is faster, but tend to be not accurate near constraints. 
    'MaxFunctionEvaluations', 10000,... % usually this means nothing
    'MaxIterations', 5000,... % this too. 
    'PlotFcn', [],... %'optimplotfvalconstr'
    'FiniteDifferenceType', 'central',... % when calculating the gradient, calculate both sides
    'FiniteDifferenceStepSize', 1e-2); % 1e-2 was the best

%% Run Through Models
output_result = struct();
if ~iscell(models)
    models = {models};
end
for model = models
    tic;
    %% Load Parameters
    [param, opt_option] = getDefaultParam();
    
    %% Setup initial parameters and ranges of the parameter for optimization
    fitLowerbound = [0, -1];
    fitUpperbound = [100, 1];
    x0 = [30, 0.2];
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
    
    %% Setup Constraints
    % no constraints for the linear transformation factors
    A = [zeros(size(opt_option.(model).A,1),2), opt_option.(model).A];
    b = [opt_option.(model).b]'; 

    %% Optimization Model
    fitfunction = @(X) computeNLL(X, schedule, model, num_repeat, Exp_high_mean, sd, Exp_low_mean, sd, value);

    %% Global Optimizer Options
    problem = createOptimProblem('fmincon',...
            'objective', fitfunction,...
            'x0', x0,...
            'Aineq', A,...
            'bineq', b,...
            'lb', fitLowerbound,...
            'ub', fitUpperbound,...
            'options', opts);
    ms = MultiStart('MaxTime', 1200, 'UseParallel', true);
    
    [output_result.(model).x, output_result.(model).fval, ~, output_result.(model).output, output_result.(model).solutions] = run(ms, problem, 12*5);
                        
    %% Print result
    fprintf('-----------%5s------------\n', model);
    fprintf('Negative Log Likelihood : %f\n', output_result.(model).fval);
    fprintf('Best Param :\n');
    fprintf('Lin param : %.3f , %.3f\n', output_result.(model).x(1), output_result.(model).x(2));  
    for fn = 1 : numel(fieldnames(modelParam))
        fprintf('%10s : %.3f\n', fnames{fn}, output_result.(model).x(2+fn));
    end
    fprintf('Time : %d sec \n',floor(toc))

end
save(strcat('.', filesep, experiment,'_',value,'_', num2str(sd), '_result.mat'),'output_result');
