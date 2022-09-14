%% Liao_et_al_2020
% Simulation Code for Liao et al. (2020)
experiment = 'Liao_et_al_2020';
value = 'alpha';
models = {'RW', 'M', 'SPH', 'EH'};

rng('shuffle');
addpath('../../helper_function');
addpath('../');

%% Experiment Data
% all mean RT values are subtracted from RT of corresponding neutral condition
ExperimentData.OldHighDistractor.Mean = [0.178, 6.320, 19.496, 2.849];
ExperimentData.OldHighDistractor.SD = 3;
ExperimentData.LowDistractor.Mean = [-10.415, -6.588, -9.436, 6.142]; 
ExperimentData.LowDistractor.SD = 3;
ExperimentData.NewHighDistractor.Mean = [0.445, -1.424, -0.712, 13.086]; 
ExperimentData.NewHighDistractor.SD = 3;

%% Experiment Schedule
% +--------+--------+--------+--------+---------------------------+
% | CS1    | CS2    | CS3    | US     | US intensity(reward size) |
% +--------+--------+--------+--------+---------------------------+
% | 1 or 0 | 1 or 0 | 1 or 0 | 1 or 0 | float                     |
% +--------+--------+--------+--------+---------------------------+
high_reward = 1; %8 cents
low_reward = 0.25; %2 cents

schedule = struct();
%-------------------- Block 1 Training ---------------------------%
schedule.schedule{1} = repmat([...
    repmat([1,0,0,1,high_reward],4,1);... % OldHigh : 80% high
    repmat([1,0,0,1,low_reward],1,1);... % OldHigh : 20% low
    repmat([0,1,0,1,high_reward],1,1);... % low : 20% high
    repmat([0,1,0,1,low_reward],4,1);... % low : 80% low
    repmat([0,0,1,0,0],5,1);... % NewHigh no reward
    ],6,1); % thesis : 96 trials. simulation : 15 trials x 6 blocks = 90 trials
%--------------------- Block 1 Testing ---------------------------%
schedule.schedule{2} = repmat([...
    repmat([1,0,0,0,0],1,1);... % OldHigh
    repmat([0,1,0,0,0],1,1);... % low
    repmat([0,0,1,0,0],1,1);... % NewHigh
    repmat([0,0,0,0,0],1,1);... % distractor-absent
    ],24,1); % thesis : 96 trials. simulation : 4 trials * 24 blocks = 96 trials
    % The thesis never mention about the proportions of each trials in the testing phase. 
    % I considered all trial type has the equal proportions.
schedule.schedule{3} = schedule.schedule{1};
schedule.schedule{4} = schedule.schedule{2};
schedule.schedule{5} = repmat([...
    repmat([0,0,1,1,high_reward],4,1);... % NewHigh : 80% high
    repmat([0,0,1,1,low_reward],1,1);... % NewHigh : 20% low
    repmat([0,1,0,1,high_reward],1,1);... % low : 20% high
    repmat([0,1,0,1,low_reward],4,1);... % low : 80% low
    repmat([1,0,0,0,0],5,1);... % OldHigh : no reward
    ],6,1); % thesis : 96 trials. simulation : 15 trials x 6 blocks = 90 trials
schedule.schedule{6} = repmat([...
    repmat([1,0,0,0,0],1,1);... % OldHigh
    repmat([0,1,0,0,0],1,1);... % low
    repmat([0,0,1,0,0],1,1);... % NewHigh
    repmat([0,0,0,0,0],1,1);... % distractor-absent
    ],24,1); % thesis : 96 trials. simulation : 4 trials * 24 blocks = 96 trials
schedule.schedule{7} = schedule.schedule{5};
schedule.schedule{8} = schedule.schedule{6};

schedule.N = (90 + 96) * 4;

%% parameters
num_repeat = 200;

CC.oldhigh = [231,124,141]./255; % initially high reward - later no reward
CC.low = [0,0,0]; % low reward 
CC.newhigh = [94,165,197]./255; % initially no reward - later high reward

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
    fitfunction = @(X) computeNLL_Liao(X, schedule, model, num_repeat, ExperimentData, value);

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
        [~,plot_1] = plot_shade(ax1, mean(V(:,1,:),3), std(V(:,1,:),0,3),'Color',CC.oldhigh,'LineWidth',2.3,'Shade',true);
        [~,plot_2] = plot_shade(ax1, mean(V(:,2,:),3), std(V(:,2,:),0,3),'Color',CC.low,'LineWidth',2,'Shade',true);
        [~,plot_3] = plot_shade(ax1, mean(V(:,3,:),3), std(V(:,3,:),0,3),'Color',CC.newhigh,'LineWidth',1.7,'Shade',true);
    elseif strcmp(value, 'alpha')
        [~,plot_1] = plot_shade(ax1, mean(alpha(:,1,:),3), std(alpha(:,1,:),0,3),'Color',CC.oldhigh,'LineWidth',2.3,'Shade',true);
        [~,plot_2] = plot_shade(ax1, mean(alpha(:,2,:),3), std(alpha(:,2,:),0,3),'Color',CC.low,'LineWidth',2,'Shade',true);
        [~,plot_3] = plot_shade(ax1, mean(alpha(:,3,:),3), std(alpha(:,3,:),0,3),'Color',CC.newhigh,'LineWidth',1.7,'Shade',true);
    end
    ylim([0,1]);
    xlim([0, schedule.N]);
    legend([plot_1{1}, plot_2{1}, plot_3{1}], {'old high reward distractor', 'low reward distractor', 'new high distractor'});
    
    for i = 1 : 4
        subplot(2,4,4+i);
        title(strcat("Block ", num2str(i)));
        hold on;
        bar((1:50)-0.5*2/3, SimulationResult.OldHighDistractor.Distribution{i}, 'FaceColor', CC.oldhigh, 'BarWidth',0.5, 'EdgeAlpha', 0);
        bar((1:50), SimulationResult.LowDistractor.Distribution{i}, 'FaceColor', CC.low, 'BarWidth',0.5, 'EdgeAlpha', 0);
        bar((1:50)+0.5*2/3, SimulationResult.NewHighDistractor.Distribution{i}, 'FaceColor', CC.newhigh, 'BarWidth',0.5, 'EdgeAlpha', 0);
        plot(ExperimentResult.OldHighDistractor.Distribution{i}, 'Color', CC.oldhigh);
        plot(ExperimentResult.LowDistractor.Distribution{i}, 'Color', CC.low);
        plot(ExperimentResult.NewHighDistractor.Distribution{i}, 'Color', CC.newhigh);
    end
    savefig(fig,strcat('../result_nll', filesep, experiment, filesep, value, filesep, model,'_',experiment,'_',value,'_result.fig'));
end
save(strcat('../result_nll', filesep, experiment, filesep, value, filesep, experiment,'_',value,'_result.mat'),'output_result');
