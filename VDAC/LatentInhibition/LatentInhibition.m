%% LatentInhibition
% Script for simulationg latent inhibition phenomenon
%% Parameters
experiment = 'LatentInhibition';
models = {'M', 'SPH', 'EH'};

rng('shuffle');
addpath('../../helper_function');
addpath('../../');

%% Experiment Schedule
% +--------+--------+--------+--------+---------------------------+
% | CS1    | CS2    | CS3    | US     | US intensity(reward size) |
% +--------+--------+--------+--------+---------------------------+
% | 1 or 0 | 1 or 0 | 1 or 0 | 1 or 0 | float                     |
% +--------+--------+--------+--------+---------------------------+
% There are three stimulus types and two phases in the hypothetical experiment.
% Phase 1 : A-      C+(1.0)
% Phase 2 : A+(0.5) B+(0.5)
% The simplest design for the latent inhibition is A- -> A+ & B+, and the expected result is 
% higher value to the B compared to the A. 
% However, I included an other stimulus, C, in the first phase to eliminate a criticism, that 
% the no-rewarding phase directly effect the behavior performance. 
% In this new design, the expected result is C >> B > A.

high_reward = 1; 
low_reward = 0.5;
no_reward = 0;

schedule = struct();
schedule.schedule{1} = repmat([...
    [1,0,0,0,no_reward];...
    [0,0,1,1,high_reward];...
    ],200,1); % 2 trials x 200 blocks
schedule.schedule{2} = repmat([...
    [1,0,0,1,low_reward];...
    [1,1,0,1,low_reward];
    ],200,1); % 2 trials x 200 blocks
schedule.N = 800;

%% parameters
num_repeat = 200;

CC.high = [231,124,141]./255; % CS 3 which was paired with lambda = 1
CC.new = [94,165,197]./255; % CS2 which was presented from the second phase
CC.old = [20,165,40]./255; % CS1 which was presented from the beginning

%% Run Through Models
output_result = struct();
for model = models
    %% Load Parameters
    model = model{1};
    load('../result_nll/Liao_et_al_2020/V/Liao_et_al_2020_V_result.mat');
    [param, opt_option] = getDefaultParam();
    fnames = fieldnames(param.(model));
    for fn = 1 : numel(fieldnames(param.(model)))
        param.(model).(fnames{fn}).value = output_result.(model).x(fn+2);
    end
    
    %% Run Simulation
    numBinModel = 50; % number of bins to divide the v or alpha

    V = zeros(schedule.N,3,num_repeat);
    alpha = zeros(schedule.N,3,num_repeat);

    for r = 1 : num_repeat
        % Shuffle schedule for repeated simulation
        schedule_shuffled = [
            shuffle1D(schedule.schedule{1});...
            shuffle1D(schedule.schedule{2});...
            ];

        [outV, outAlpha] = SimulateModel(schedule_shuffled, model, param);

        V(:,:,r) = outV; % [trial, cs type, repeat]
        alpha(:,:,r) = outAlpha;
    end

    %% Generate Experiment & Model Distribution for plotting

    % Concatenate Simulation Result
    Old_V = V(:,1,:);
    New_V = V(:,2,:);
    High_V = V(:,3,:);

    Old_alpha = alpha(:,1,:);
    New_alpha = alpha(:,2,:);
    High_alpha = alpha(:,3,:);

    % Generate Simulation Distribution
    Model_element_number = (schedule.N * num_repeat);

    Old_V_dist = histcounts(Old_V, linspace(0,1,numBinModel + 1))/Model_element_number;
    New_V_dist = histcounts(New_V, linspace(0,1,numBinModel + 1))/Model_element_number;
    High_V_dist = histcounts(High_V, linspace(0,1,numBinModel + 1))/Model_element_number;

    Old_alpha_dist = histcounts(Old_alpha, linspace(0,1,numBinModel + 1))/Model_element_number;
    New_alpha_dist = histcounts(New_alpha, linspace(0,1,numBinModel + 1))/Model_element_number;
    High_alpha_dist = histcounts(High_alpha, linspace(0,1,numBinModel + 1))/Model_element_number;

    %% Draw Plot
    fig = figure('name', model, 'Position', [200, 120, 1200, 800]);
    ax1 = subplot(2,4,1:3);
    [~,plot_1] = plot_shade(ax1, mean(V(:,1,:),3), std(V(:,1,:),0,3),'Color',CC.old,'LineWidth',2.3,'Shade',true);
    [~,plot_2] = plot_shade(ax1, mean(V(:,2,:),3), std(V(:,2,:),0,3),'Color',CC.new,'LineWidth',2,'Shade',true);
    [~,plot_3] = plot_shade(ax1, mean(V(:,3,:),3), std(V(:,3,:),0,3),'Color',CC.high,'LineWidth',1.7,'Shade',true);
    ylim([0,1]);
    legend([plot_1{1}, plot_2{1}, plot_3{1}], {'old distractor', 'new distractor', 'high distractor'});

    ax2 = subplot(2,4,4);
    bar((1:50)-0.5*2/3, Old_V_dist, 'FaceColor', CC.old, 'BarWidth',0.3, 'EdgeAlpha',0);
    hold on;
    bar((1:50), New_V_dist, 'FaceColor', CC.new, 'BarWidth',0.3, 'EdgeAlpha',0);
    bar((1:50)+0.5*2/3, High_V_dist, 'FaceColor', CC.high, 'BarWidth', 0.3, 'EdgeAlpha',0);
    ax2.View = [90, -90];

    ax3 = subplot(2,4,5:7);
    [~,plot_1] = plot_shade(ax3, mean(alpha(:,1,:),3), std(alpha(:,1,:),0,3),'Color',CC.old,'LineWidth',2.3,'Shade',true);
    [~,plot_2] = plot_shade(ax3, mean(alpha(:,2,:),3), std(alpha(:,2,:),0,3),'Color',CC.new,'LineWidth',2,'Shade',true);
    [~,plot_3] = plot_shade(ax3, mean(alpha(:,3,:),3), std(alpha(:,3,:),0,3),'Color',CC.high,'LineWidth',1.7,'Shade',true);
    ylim([0,1]);
    legend([plot_1{1}, plot_2{1}, plot_3{1}], {'old distractor', 'new distractor', 'high distractor'});
    
    ax4 = subplot(2,4,8);
    bar((1:50)-0.5*2/3, Old_alpha_dist, 'FaceColor', CC.old, 'BarWidth',0.3);
    hold on;
    bar((1:50), New_alpha_dist, 'FaceColor', CC.new, 'BarWidth',0.3);
    bar((1:50)+0.5*2/3, High_alpha_dist, 'FaceColor', CC.high, 'BarWidth', 0.3);
    ax4.View = [90, -90];
    
    %savefig(fig,strcat('../result_nll', filesep, experiment, filesep, value, filesep, model,'_',experiment,'_',value,'_result.fig'));
end
%save(strcat('../result_nll', filesep, experiment, filesep, value, filesep, experiment,'_',value,'_result.mat'),'output_result');
