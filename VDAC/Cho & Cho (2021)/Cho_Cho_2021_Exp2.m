%% Cho_Cho_Exp2_2021
% Cho & Cho 2021 Experiment 2 simulation
experiment = 'Cho_Cho_2021_Exp2';
value = 'V';
models = {'RW', 'M', 'SPH', 'EH'};

rng('shuffle');
addpath('../');
addpath('../../helper_function');

%% Experiment Data
% all mean RT values are subtracted from RT of corresponding neutral condition
ExperimentData.UncertaintyDistractor.Mean = [621 - 589, 581 - 581];
ExperimentData.UncertaintyDistractor.SD = 3;
ExperimentData.CertaintyDistractor.Mean = [604 - 589, 598 - 581]; 
ExperimentData.CertaintyDistractor.SD = 3;

%% Experiment Schedule
% +--------+--------+--------+--------+---------------------------+
% | CS1    | CS2    | CS3    | US     | US intensity(reward size) |
% +--------+--------+--------+--------+---------------------------+
% | 1 or 0 | 1 or 0 | 1 or 0 | 1 or 0 | float                     |
% +--------+--------+--------+--------+---------------------------+
schedule = struct();
schedule.schedule_training = [...
    repmat([1,0,0,1,0.90],1,1);... % uncertain 1
    repmat([1,0,0,1,0.75],1,1);... % uncertain 2
    repmat([1,0,0,1,0.25],1,1);... % uncertain 3
    repmat([1,0,0,1,0.10],1,1);... % uncertain 4
    repmat([0,1,0,1,0.50],4,1);...
    ]; % thesis : 192 trials x 3 blocks = 576 trials --> 8 trial set * 72 
schedule.schedule_training_repeat = 72;
schedule.schedule_training_N = size(schedule.schedule_training,1) * schedule.schedule_training_repeat;

schedule.schedule_testing = [...
    [1,0,0,0,0];
    [0,1,0,0,0];
    [0,0,0,0,0];
    [0,0,0,0,0];
    ]; % thesis : 144 trials x 2 blocks = 288 trials --> 4 trial set * 72 
schedule.schedule_testing_repeat = 72;
schedule.schedule_testing_N = size(schedule.schedule_testing,1) * schedule.schedule_testing_repeat;

schedule.N = schedule.schedule_training_N + schedule.schedule_testing_N;

%% parameters
num_repeat = 200;

CC.uncertainty = [231,124,141]./255;
CC.certainty = [94,165,197]./255;

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
for model = models
    tic;
    %% Load Parameters
    [param, opt_option] = getDefaultParam();
    
    %% Linear Transformation Parameter
    % experiment specific range for matching V to RT or score difference from the experiment
    fitLowerbound = [0, -1];
    fitUpperbound = [100, 1];
    x0 = [40, -0.2]; % rule of thumb 
    
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

    %% Manual Initial parameter setting for increased accuracy
    if strcmp(value, 'alpha') && strcmp(model, 'EH')
        x0 = [45, -0.1, 0.602, 0.364, 0.087, 0.005, 0.487, 0.082];
        fprintf('Test');
    end 

    %% Setup Constraints
    % no constraints for the linear transformation factors
    A = [zeros(size(opt_option.(model).A,1),2), opt_option.(model).A];
    b = [opt_option.(model).b]';
    
    %% Optimization Model
    fitfunction = @(X) computeNLL_Cho(X, schedule, model, num_repeat, ExperimentData, value);

    %% Global Optimizer Options
    problem = createOptimProblem('fmincon',...
            'objective', fitfunction,...
            'x0', x0,...
            'Aineq', A,...
            'bineq', b,...
            'lb', fitLowerbound,...
            'ub', fitUpperbound,...
            'options', opts);
    ms = MultiStart('MaxTime', 600, 'UseParallel', true, 'StartPointsToRun', 'bounds');
    
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
    [negativeloglikelihood, V, alpha, SimulationResult, ExperimentResult, Model_element_number] = fitfunction(output_result.(model).x);
    output_result.(model).Model_element_number = Model_element_number;
    fig = figure('name', model, 'Position', [98,509,981,358]);
    ax1 = subplot(2,4,1:4);
    if strcmp(value, 'V')
        [~,plot_1] = plot_shade(ax1, mean(V(:,1,:),3), std(V(:,1,:),0,3),'Color',CC.uncertainty,'LineWidth',2.3,'Shade',true);
        [~,plot_2] = plot_shade(ax1, mean(V(:,2,:),3), std(V(:,2,:),0,3),'Color',CC.certainty,'LineWidth',2,'Shade',true);
    elseif strcmp(value, 'alpha')
        [~,plot_1] = plot_shade(ax1, mean(alpha(:,1,:),3), std(alpha(:,1,:),0,3),'Color',CC.uncertainty,'LineWidth',2.3,'Shade',true);
        [~,plot_2] = plot_shade(ax1, mean(alpha(:,2,:),3), std(alpha(:,2,:),0,3),'Color',CC.certainty,'LineWidth',2,'Shade',true);
    end
    ylim([0,1]);
    xlim([0, schedule.N]);
    legend([plot_1{1}, plot_2{1}], {'uncertainty', 'certainty'});

    ax2 = subplot(2,4,5:6);
    bar((1:50)-0.25, SimulationResult.UncertaintyDistractor.Distribution{1}, 'FaceColor', CC.uncertainty, 'BarWidth',0.5, 'EdgeAlpha', 0);
    hold on;
    bar((1:50)+0.25, SimulationResult.CertaintyDistractor.Distribution{1}, 'FaceColor', CC.certainty, 'BarWidth', 0.5, 'EdgeAlpha', 0);
    plot(ExperimentResult.UncertaintyDistractor.Distribution{1}, 'Color', CC.uncertainty);
    plot(ExperimentResult.CertaintyDistractor.Distribution{1}, 'Color', CC.certainty);
    
    ax3 = subplot(2,4,7:8);
    bar((1:50)-0.25, SimulationResult.UncertaintyDistractor.Distribution{2}, 'FaceColor', CC.uncertainty, 'BarWidth',0.5, 'EdgeAlpha', 0);
    hold on;
    bar((1:50)+0.25, SimulationResult.CertaintyDistractor.Distribution{2}, 'FaceColor', CC.certainty, 'BarWidth', 0.5, 'EdgeAlpha', 0);
    plot(ExperimentResult.UncertaintyDistractor.Distribution{2}, 'Color', CC.uncertainty);
    plot(ExperimentResult.CertaintyDistractor.Distribution{2}, 'Color', CC.certainty);
    
    savefig(fig,strcat('../result_nll', filesep, experiment, filesep, value, filesep, model,'_',experiment,'_',value,'_result.fig'));
end
save(strcat('../result_nll', filesep, experiment, filesep, value, filesep, experiment,'_',value,'_result.mat'),'output_result');
