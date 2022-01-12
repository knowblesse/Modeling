%% WholeParameterSearch
% Parameter Fitting Script

%% parameters
rng('shuffle');
addpath('..');
addpath('../helper_function');
addpath('./experiments');

mode = 'alpha';
num_repeat = 200;

CC.high = [231,124,141]./255;
CC.low = [94,165,197]./255;

%% Load Experiment
%exp = 'Anderson_2011';
exp = 'Anderson_Halpern_2017';
% exp = 'Cho_Cho_Exp1_2021';
eval(exp);

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
models = {'RW', 'M', 'SPH', 'EH'};
output_result = struct();
for model = models
    tic;
    %% Load Parameters
    [param, opt_option] = getDefaultParam();
    
    %% Setup initial parameters and ranges of the parameter for optimization
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
    
    %% Setup Constraints
    A_temp = opt_option.(model).A;
    A = zeros(1 + size(A_temp,1), 2 + size(A_temp,2));
    A(1,1:2) = [1,-1];
    A(2:end,3:end) = A_temp;

    b = [0,opt_option.(model).b]'; 
    %% Optimization Model
    fitfunction = @(X) evalWholeModel(X, schedule, model, num_repeat, Exp_high_mean, Exp_high_sd, Exp_low_mean, Exp_low_sd, mode);

    %% Global Optimizer Options
    problem = createOptimProblem('fmincon',...
            'objective', fitfunction,...
            'x0', x0,...
            'Aineq', A,...
            'bineq', b,...
            'lb', fitLowerbound,...
            'ub', fitUpperbound,...
            'options', opts);
    %gs = GlobalSearch('MaxTime',180);
    ms = MultiStart('MaxTime', 180, 'UseParallel', true);
    
    %[x, fval, ~, output_result.(model).output, output_result.(model).solutions] = run(gs, problem);
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
    [likelihood, V, alpha, V_high, V_low, alpha_high, alpha_low, Exp_high, Exp_low] = fitfunction(output_result.(model).x);
    fig = figure('name', model, 'Position', [200, 120, 1200, 800]);
    ax1 = subplot(2,4,1:3);
    [~,v_plot_1] = plot_shade(ax1, mean(alpha(:,1,:),3), std(alpha(:,1,:),0,3),'Color',CC.high,'LineWidth',2.3,'Shade',true, 'LineStyle', '--');
    [~,v_plot_2] = plot_shade(ax1, mean(alpha(:,2,:),3), std(alpha(:,2,:),0,3),'Color',CC.low,'LineWidth',2,'Shade',true, 'LineStyle', '--');
    ylim([0,1]);
    legend([v_plot_1{1}, v_plot_2{1}], {'high reward', 'low reward'});
    
    ax2 = subplot(2,4,4);
    bar((1:30)-0.25, alpha_high, 'FaceColor', CC.high, 'BarWidth',0.5);
    hold on;
    bar((1:30)+0.25, alpha_low, 'FaceColor', CC.low, 'BarWidth', 0.5);
    ax2.View = [90, -90];
    
    ax3 = subplot(2,4,5:6);
    hold on;
    bar((1:30)-0.25, alpha_high, 'FaceColor', CC.high, 'BarWidth',0.5);
    bar((1:30)+0.25, alpha_low, 'FaceColor', CC.low, 'BarWidth', 0.5);
    plot(Exp_high, 'Color', CC.high);
    plot(Exp_low, 'Color', CC.low);
    
    ax4 = subplot(2,4,7:8);
    cla;
    axis off;
    text(0.05, 1, strcat("Model : ", model), 'FontSize', 20);
    text(0.05, 0.8, strcat("Negative Log-Likelihood : ", num2str(output_result.(model).fval)), 'FontSize', 20);
    text(0.05, 0.6, strcat("Parameters : ", num2str(output_result.(model).x(1)), " ", num2str(output_result.(model).x(2))), 'FontSize', 20);
    text(0.05, 0.4, num2str(output_result.(model).x(3:end), ' %.2f'), 'FontSize', 15);
    
    savefig(fig,strcat(model,'_',exp,'_',mode,'_result.fig'));
end
save(strcat(exp,'_',mode,'_result.mat'),'output_result');
