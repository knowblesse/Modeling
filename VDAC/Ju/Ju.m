%% Ju

%% Experiment Data
ExperimentAData.High_Predictiveness_mean = -0.778;
ExperimentAData.High_Uncertainty_mean = 12.752;

ExperimentBData.High_Predictiveness_mean = 11.106;
ExperimentBData.High_Uncertainty_mean = 0.93782;

ExperimentData = {ExperimentAData, ExperimentBData};

%% Experiment Schedule
% +--------+--------+--------+--------+---------------------------+
% | CS1    | CS2    | CS3    | US     | US intensity(reward size) |
% +--------+--------+--------+--------+---------------------------+
% | 1 or 0 | 1 or 0 | 1 or 0 | 1 or 0 | float                     |
% +--------+--------+--------+--------+---------------------------+
scheduleA = struct();
scheduleA.schedule_training = [...
    repmat([1,0,0,0,0],5,1);...
    repmat([1,0,0,1,0.5],15,1);...
    repmat([0,1,0,0,0],8,1);...
    repmat([0,1,0,1,0.25],3,1);...
    repmat([0,1,0,1,0.5],3,1);...
    repmat([0,1,0,1,0.75],3,1);...
    repmat([0,1,0,1,1],3,1);...
    ]; 
scheduleA.schedule_training_repeat = 50;
scheduleA.schedule_training_N = size(scheduleA.schedule_training,1) * scheduleA.schedule_training_repeat;

scheduleB = struct();
scheduleB.schedule_training = [...
    repmat([1,0,0,0,0],2,1);...
    repmat([1,0,0,1,0.5],8,1);...
    repmat([0,1,0,0,0],5,1);...
    repmat([0,1,0,1,0.6],1,1);...
    repmat([0,1,0,1,0.7],1,1);...
    repmat([0,1,0,1,0.8],1,1);...
    repmat([0,1,0,1,0.9],1,1);...
    repmat([0,1,0,1,1.0],1,1);...
    ]; 
scheduleB.schedule_training_repeat = 100;
scheduleB.schedule_training_N = size(scheduleB.schedule_training,1) * scheduleB.schedule_training_repeat;

schedule = {scheduleA, scheduleB};

%% parameters
num_repeat = 200;
value = 'V';
models = {'RW', 'M', 'SPH', 'EH'};

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
    %% Load Parameters
    [param, opt_option] = getDefaultParam();
    
    %% Linear Transformation Parameter
    % experiment specific range for matching V to RT or score difference from the experiment
    fitLowerbound = [0, -1];
    fitUpperbound = [100, 10];
    x0 = [20, 1]; % rule of thumb 
    
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
    % no constraints for the linear transformation factors
    A = [zeros(size(opt_option.(model).A,1),2), opt_option.(model).A];
    b = [opt_option.(model).b]';
    
    %% Optimization Model
    fitfunction = @(X) computeNLL_Ju(X, schedule, model, num_repeat, ExperimentData, value)

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