%% WholeParameterSearch
% Parameter Fitting Script

%% parameters
rng('shuffle');
addpath('..');
addpath('../helper_function');
addpath('./experiments');

num_repeat = 200;

CC.high = [1,0.3,0.3];
CC.low = [0.3,1,0.3];

%% Load Experiment
%Anderson_2011;
Anderson_Halpern_2017;
%% Optimization parameters
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
    
    ms = MultiStart;
    problem = createOptimProblem('fmincon',...
        'objective', fitfunction,...
        'x0', x0,...
        'Aineq', A,...
        'bineq', b,...
        'lb', fitLowerbound,...
        'ub', fitUpperbound,...
        'options', opts);
    
    [x, fval] = run(ms, problem, 20);
                        
    %% Print result
    fprintf('-----------%5s------------\n', model);
    fprintf('Negative Log Likelihood : %f\n', fval);
    fprintf('Best Param :\n');
    fprintf('Lin param : %.3f , %.3f\n', x(1), x(2));  
    for fn = 1 : numel(fieldnames(modelParam))
        fprintf('%10s : %.3f\n', fnames{fn}, x(2+fn));
    end
    
    %% Draw Result
    [likelihood, V, alpha, V_high, V_low, Exp_high, Exp_low] = fitfunction(x);
    fig = figure('name', model, 'Position', [200, 120, 1200, 800]);
    ax1 = subplot(2,4,1:3);
    [~,v_plot_1] = plot_shade(ax1, mean(V(:,1,:),3), std(V(:,1,:),0,3),'Color',CC.high,'LineWidth',2.3,'Shade',true);
    [~,v_plot_2] = plot_shade(ax1, mean(V(:,2,:),3), std(V(:,2,:),0,3),'Color',CC.low,'LineWidth',2,'Shade',true);
    ylim([0,1]);
    legend([v_plot_1{1}, v_plot_2{1}], {'high reward', 'low reward'});
    
    ax2 = subplot(2,4,4);
    bar((1:30)-0.25, V_high, 'FaceColor', CC.high, 'BarWidth',0.5);
    hold on;
    bar((1:30)+0.25, V_low, 'FaceColor', CC.low, 'BarWidth', 0.5);
    ax2.View = [90, -90];
    
    ax3 = subplot(2,4,5:6);
    hold on;
    bar((1:30)-0.25, V_high, 'FaceColor', CC.high, 'BarWidth',0.5);
    bar((1:30)+0.25, V_low, 'FaceColor', CC.low, 'BarWidth', 0.5);
    plot(Exp_high, 'Color', CC.high);
    plot(Exp_low, 'Color', CC.low);
    
    ax4 = subplot(2,4,7:8);
    cla;
    axis off;
    text(0.05, 1, strcat("Model : ", model), 'FontSize', 20);
    text(0.05, 0.8, strcat("Negative Log-Likelihood : ", num2str(fval)), 'FontSize', 20);
    text(0.05, 0.6, strcat("Parameters : ", num2str(x(1)), " ", num2str(x(2))), 'FontSize', 20);
    text(0.05, 0.4, num2str(x(3:end), ' %.2f'), 'FontSize', 15);
end
