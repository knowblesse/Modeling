function mlParameterSearch2(experiment, value, models) 
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
addpath('../helper_function');
addpath('./experiments');

num_repeat = 200;

CC.high = [231,124,141]./255; % stimulus condition where the RT should be longer than the low condition
CC.low = [94,165,197]./255; % stimulus condition where the RT should be shorter than the high condition

%% Load Experiment
if iscell(experiment)
    experiment = experiment{1};
end
eval(experiment);

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
    x0 = [20, 0];
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
    fitfunction = @(X) computeNLL(X, schedule, model, num_repeat, Exp_high_mean, 3, Exp_low_mean, 3, value);

    %% Global Optimizer Options
    problem = createOptimProblem('fmincon',...
            'objective', fitfunction,...
            'x0', x0,...
            'Aineq', A,...
            'bineq', b,...
            'lb', fitLowerbound,...
            'ub', fitUpperbound,...
            'options', opts);
    ms = MultiStart('MaxTime', 600, 'UseParallel', true);
    
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

    %% Draw Result
    [~, V, alpha, Model_high, Model_low, Exp_high, Exp_low, Model_element_number] = fitfunction(output_result.(model).x);
    output_result.(model).Model_element_number = Model_element_number;
    fig = figure('name', model, 'Position', [200, 120, 1200, 800]);
    ax1 = subplot(2,4,1:3);
    if strcmp(value, 'V')
        [~,plot_1] = plot_shade(ax1, mean(V(:,1,:),3), std(V(:,1,:),0,3),'Color',CC.high,'LineWidth',2.3,'Shade',true);
        [~,plot_2] = plot_shade(ax1, mean(V(:,2,:),3), std(V(:,2,:),0,3),'Color',CC.low,'LineWidth',2,'Shade',true);
    elseif strcmp(value, 'alpha')
        [~,plot_1] = plot_shade(ax1, mean(alpha(:,1,:),3), std(alpha(:,1,:),0,3),'Color',CC.high,'LineWidth',2.3,'Shade',true);
        [~,plot_2] = plot_shade(ax1, mean(alpha(:,2,:),3), std(alpha(:,2,:),0,3),'Color',CC.low,'LineWidth',2,'Shade',true);
    end
    ylim([0,1]);
    legend([plot_1{1}, plot_2{1}], {'high reward', 'low reward'});
    
    ax2 = subplot(2,4,4);
    bar((1:50)-0.25, Model_high, 'FaceColor', CC.high, 'BarWidth',0.5, 'EdgeAlpha', 0);
    hold on;
    bar((1:50)+0.25, Model_low, 'FaceColor', CC.low, 'BarWidth', 0.5, 'EdgeAlpha', 0);
    ax2.View = [90, -90];
    
    ax3 = subplot(2,4,5:6);
    hold on;
    bar((1:50)-0.25, Model_high, 'FaceColor', CC.high, 'BarWidth',0.5, 'EdgeAlpha', 0);
    bar((1:50)+0.25, Model_low, 'FaceColor', CC.low, 'BarWidth', 0.5, 'EdgeAlpha', 0);
    plot(Exp_high, 'Color', CC.high);
    plot(Exp_low, 'Color', CC.low);
    
    ax4 = subplot(2,4,7:8);
    cla;
    axis off;
    text(0.05, 1, strcat("Model : ", model), 'FontSize', 18);
    text(0.05, 0.8, strcat("Negative Log-Likelihood : ", num2str(output_result.(model).fval)), 'FontSize', 18);
    text(0.05, 0.6, "Parameters : ", 'FontSize', 20);
    text(0.05, 0.45, strcat("a : ", num2str(output_result.(model).x(1)), " b : ", num2str(output_result.(model).x(2))), 'FontSize', 15);
    for ip = 1 : numel(fieldnames(modelParam))
        text(0.05, 0.45-(0.1*ip), strcat(fnames{ip}, " : ", num2str(output_result.(model).x(ip+2), ' %.3f')), 'FontSize', 15);
    end
    if iscell(value)
        value = value{1};
    end
    savefig(fig,strcat('./result_nll', filesep, experiment, filesep, value, filesep, model,'_',experiment,'_',value,'_result.fig'));
end
save(strcat('./result_nll', filesep, experiment, filesep, value, filesep, experiment,'_',value,'_result.mat'),'output_result');
