%% LePelly_et_al_2019
% Simulation Code for LePellyu 
rng('shuffle');
addpath('../../helper_function');
addpath('../../');

%% Experiment Data
ExperimentData.HighDistractor.Mean = 22.08;
ExperimentData.HighDistractor.SD = 3;
ExperimentData.LowDistractor.Mean = 16.14;
ExperimentData.LowDistractor.SD = 3;
ExperimentData.NPDistractor.Mean = 17.67;
ExperimentData.NPDistractor.SD = 3;

%% Experiment Schedule
% +--------+--------+--------+--------+---------------------------+
% | CS1    | CS2    | CS3    | US     | US intensity(reward size) |
% +--------+--------+--------+--------+---------------------------+
% | 1 or 0 | 1 or 0 | 1 or 0 | 1 or 0 | float                     |
% +--------+--------+--------+--------+---------------------------+
high_reward = 1; %500 point
low_reward = 0.02; %10 point

schedule = struct();
schedule.schedule{1} = repmat([...
    repmat([1,0,0,1,high_reward],12,1);... % high
    repmat([0,1,0,1,low_reward],12,1);... % low
    repmat([0,0,1,1,high_reward],6,1);... % NP-high
    repmat([0,0,1,1,low_reward],6,1);... % NP-low
    ],5,1); % 36 trials x 5 blocks
schedule.schedule{2} = repmat([...
    repmat([1,0,0,1,high_reward],10,1);... % High
    repmat([0,1,0,1,low_reward],10,1);... % Low
    repmat([0,0,1,1,high_reward],5,1);... % NP : high
    repmat([0,0,1,1,low_reward],5,1);... % NP : low
    repmat([1,1,0,1,high_reward],1,1);... % High+Low : high
    repmat([1,1,0,1,low_reward],1,1);... % High+Low : low 
    repmat([1,0,1,1,high_reward],2,1);... % High+NP -> High
    repmat([0,1,1,1,low_reward],2,1);... % Low+NP -> Low
    ],8,1); % 36 trials x 8 blocks
schedule.N = 36*5 + 36*8;

%% parameters
mode = 'alpha';
num_repeat = 200;

CC.high = [231,124,141]./255; % stimulus condition where the RT should be longer than the low condition
CC.low = [94,165,197]./255; % stimulus condition where the RT should be shorter than the high condition
CC.np = [0,0,0];CC.high = [231,124,141]./255; % stimulus condition where the RT should be longer than the low condition

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
    
    %% Linear Transformation Parameter
    % experiment specific range for matching V to RT or score difference from the experiment
    fitLowerbound = [-40, -40];
    fitUpperbound = [+40, +40];
    x0 = [0, 30]; % rule of thumb 
    
    %% Setup initial parameters and ranges of the parameter for optimization
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
    fitfunction = @(X) evalModel(X, schedule, model, num_repeat, ExperimentData, mode);

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
    [likelihood, V, alpha, SimulationResult, ExperimentResult] = fitfunction(output_result.(model).x);
    fig = figure('name', model, 'Position', [200, 120, 1200, 800]);
    ax1 = subplot(2,4,1:3);
    if strcmp(mode, 'V')
        [~,plot_1] = plot_shade(ax1, mean(V(:,1,:),3), std(V(:,1,:),0,3),'Color',CC.high,'LineWidth',2.3,'Shade',true);
        [~,plot_2] = plot_shade(ax1, mean(V(:,2,:),3), std(V(:,2,:),0,3),'Color',CC.low,'LineWidth',2,'Shade',true);
        [~,plot_3] = plot_shade(ax1, mean(V(:,3,:),3), std(V(:,3,:),0,3),'Color',CC.np,'LineWidth',1.7,'Shade',true);
    elseif strcmp(mode, 'alpha')
        [~,plot_1] = plot_shade(ax1, mean(alpha(:,1,:),3), std(alpha(:,1,:),0,3),'Color',CC.high,'LineWidth',2.3,'Shade',true);
        [~,plot_2] = plot_shade(ax1, mean(alpha(:,2,:),3), std(alpha(:,2,:),0,3),'Color',CC.low,'LineWidth',2,'Shade',true);
        [~,plot_3] = plot_shade(ax1, mean(alpha(:,3,:),3), std(alpha(:,3,:),0,3),'Color',CC.np,'LineWidth',1.7,'Shade',true);
    end
    ylim([0,1]);
    legend([plot_1{1}, plot_2{1}, plot_3{1}], {'high reward distractor', 'low reward distractor', 'np distractor'});
    
    ax2 = subplot(2,4,4);
    bar((1:30)-0.5*2/3, SimulationResult.HighDistractor.Distribution, 'FaceColor', CC.high, 'BarWidth',0.3);
    hold on;
    bar((1:30), SimulationResult.LowDistractor.Distribution, 'FaceColor', CC.low, 'BarWidth',0.3);
    bar((1:30)+0.5*2/3, SimulationResult.NPDistractor.Distribution, 'FaceColor', CC.np, 'BarWidth', 0.3);
    ax2.View = [90, -90];
    
    ax3 = subplot(2,4,5:6);
    hold on;
    bar((1:30)-0.5*2/3, SimulationResult.HighDistractor.Distribution, 'FaceColor', CC.high, 'BarWidth',0.5);
    bar((1:30), SimulationResult.LowDistractor.Distribution, 'FaceColor', CC.low, 'BarWidth',0.5);
    bar((1:30)+0.5*2/3, SimulationResult.NPDistractor.Distribution, 'FaceColor', CC.np, 'BarWidth',0.5);
    plot(ExperimentResult.HighDistractor.Distribution, 'Color', CC.high);
    plot(ExperimentResult.LowDistractor.Distribution, 'Color', CC.low);
    plot(ExperimentResult.NPDistractor.Distribution, 'Color', CC.np);
    
    ax4 = subplot(2,4,7:8);
    cla;
    axis off;
    text(0.05, 1, strcat("Model : ", model), 'FontSize', 20);
    text(0.05, 0.8, strcat("Negative Log-Likelihood : ", num2str(output_result.(model).fval)), 'FontSize', 20);
    text(0.05, 0.6, strcat("Parameters : ", num2str(output_result.(model).x(1)), " ", num2str(output_result.(model).x(2))), 'FontSize', 20);
    text(0.05, 0.4, num2str(output_result.(model).x(3:end), ' %.2f'), 'FontSize', 15);
    
    savefig(fig,strcat(model,'_LePelly_et_al_2019_',mode,'_result.fig'));
end
save(strcat('LePelly_et_al_2019_',mode,'_result.mat'),'output_result');

