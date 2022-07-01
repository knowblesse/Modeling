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
% Phase 1 : A-      C+(0.5)
% Phase 2 : A+(0.5) B+(0.5)
% The simplest design for the latent inhibition is A- -> A+ & B+, and the expected result is 
% higher value to the B compared to the A. 
% However, I included an other stimulus, C, in the first phase to eliminate a criticism, that 
% the no-rewarding phase directly effect the behavior performance. 
% In this new design, the expected result is C = B > A.

high_reward = 1; 
low_reward = 0.5;
no_reward = 0;

schedule = struct();
schedule.schedule{1} = repmat([...
    [1,0,0,0,no_reward];...
    [0,0,1,1,low_reward];...
    ],200,1); % 2 trials x 200 blocks
schedule.schedule{2} = repmat([...
    [1,0,0,1,low_reward];...
    [0,1,0,1,low_reward];
    ],200,1); % 2 trials x 200 blocks
schedule.N = 800;

%% parameters
num_repeat = 200;

CC.old = [231,124,141]./255; % CS1 which was presented from the beginning
CC.new = [94,165,197]./255; % CS2 which was presented from the second phase
CC.high = [20,165,40]./255; % CS 3 which was paired with lambda = 0.5

%% Load Parameters
[param, opt_option] = getDefaultParam();
param.M.lr_acq.value = 0.08;
param.M.lr_ext.value = 0.04;
param.M.k.value = 0.06;
param.M.epsilon.value = 0.03;
param.SPH.S.value = 0.1;
param.SPH.beta_ex.value = 0.2;
param.SPH.beta_in.value = 0.1;
param.SPH.gamma.value = 0.03;
param.EH.lr1_acq.value = 0.04;
param.EH.lr2_acq.value = 0.03; 
param.EH.lr1_ext.value = 0.04;
param.EH.lr2_ext.value = 0.02;
param.EH.k.value = 0.4;
param.EH.lr_pre.value = 0.01;
%% Run Through Models
output_result = struct();
for model = models
    model = model{1};
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
    Old_V = squeeze(V(:,1,:));
    New_V = squeeze(V(:,2,:));
    High_V = squeeze(V(:,3,:));

    Old_alpha = squeeze(alpha(:,1,:));
    New_alpha = squeeze(alpha(:,2,:));
    High_alpha = squeeze(alpha(:,3,:));

    % Generate Simulation Distribution
    Old_V_dist_b1 = histcounts(Old_V(401:600,:), linspace(0,1,numBinModel + 1))/(200 * num_repeat);
    Old_V_dist_b2 = histcounts(Old_V(601:800,:), linspace(0,1,numBinModel + 1))/(200 * num_repeat);
    New_V_dist_b1 = histcounts(New_V(401:600,:), linspace(0,1,numBinModel + 1))/(200 * num_repeat);
    New_V_dist_b2 = histcounts(New_V(601:800,:), linspace(0,1,numBinModel + 1))/(200 * num_repeat);

    Old_alpha_dist_b1 = histcounts(Old_alpha(401:600,:), linspace(0,1,numBinModel + 1))/(200 * num_repeat);
    Old_alpha_dist_b2 = histcounts(Old_alpha(601:800,:), linspace(0,1,numBinModel + 1))/(200 * num_repeat);
    New_alpha_dist_b1 = histcounts(New_alpha(401:600,:), linspace(0,1,numBinModel + 1))/(200 * num_repeat);
    New_alpha_dist_b2 = histcounts(New_alpha(601:800,:), linspace(0,1,numBinModel + 1))/(200 * num_repeat);

    %% Draw Plot
    fig = figure('name', model, 'Position', [200, 120, 1200, 800]);
    ax1 = subplot(4,4,[1:3,5:7]);
    [~,plot_1] = plot_shade(ax1, mean(V(:,1,:),3), std(V(:,1,:),0,3),'Color',CC.old,'LineWidth',2.3,'Shade',true);
    [~,plot_2] = plot_shade(ax1, mean(V(:,2,:),3), std(V(:,2,:),0,3),'Color',CC.new,'LineWidth',2,'Shade',true, 'x', 401:800);
    [~,plot_3] = plot_shade(ax1, mean(V(:,3,:),3), std(V(:,3,:),0,3),'Color',CC.high,'LineWidth',1.7,'Shade',true, 'x', 1:400);
    ylim([0,1]);
    legend([plot_1{1}, plot_2{1}, plot_3{1}], {'old distractor', 'new distractor', 'control distractor'});

    ax21 = subplot(4,4,4);
    bar((1:50)-0.25, Old_V_dist_b1, 'FaceColor', CC.old, 'BarWidth', 0.5, 'EdgeAlpha', 0);
    hold on;
    bar((1:50)+0.25, New_V_dist_b1, 'FaceColor', CC.new, 'BarWidth', 0.5, 'EdgeAlpha', 0);

    ax22 = subplot(4,4,8);
    bar((1:50)-0.25, Old_V_dist_b2, 'FaceColor', CC.old, 'BarWidth', 0.5, 'EdgeAlpha', 0);
    hold on;
    bar((1:50)+0.25, New_V_dist_b2, 'FaceColor', CC.new, 'BarWidth', 0.5, 'EdgeAlpha', 0);

    ax3 = subplot(4,4,[9:11, 13:15]);
    [~,plot_1] = plot_shade(ax3, mean(alpha(:,1,:),3), std(alpha(:,1,:),0,3),'Color',CC.old,'LineWidth',2.3,'Shade',true);
    [~,plot_2] = plot_shade(ax3, mean(alpha(:,2,:),3), std(alpha(:,2,:),0,3),'Color',CC.new,'LineWidth',2,'Shade',true, 'x', 401:800);
    [~,plot_3] = plot_shade(ax3, mean(alpha(:,3,:),3), std(alpha(:,3,:),0,3),'Color',CC.high,'LineWidth',1.7,'Shade',true, 'x', 1:400);
    ylim([0,1]);
    legend([plot_1{1}, plot_2{1}, plot_3{1}], {'old distractor', 'new distractor', 'control distractor'});
    
    ax41 = subplot(4,4,12);
    bar((1:50)-0.25, Old_alpha_dist_b1, 'FaceColor', CC.old, 'BarWidth', 0.5, 'EdgeAlpha', 0);
    hold on;
    bar((1:50)+0.25, New_alpha_dist_b1, 'FaceColor', CC.new, 'BarWidth',0.5, 'EdgeAlpha', 0);

    ax42 = subplot(4,4,16);
    bar((1:50)-0.25, Old_alpha_dist_b2, 'FaceColor', CC.old, 'BarWidth', 0.5, 'EdgeAlpha', 0);
    hold on;
    bar((1:50)+0.25, New_alpha_dist_b2, 'FaceColor', CC.new, 'BarWidth',0.5, 'EdgeAlpha', 0);
    
    subplot(4,4,[1:3,5:7]);
    text(500,1.1,strcat("Liao a ", model), 'FontSize', 16);
    %savefig(fig,strcat('../result_nll', filesep, experiment, filesep, value, filesep, model,'_',experiment,'_',value,'_result.fig'));
end
%save(strcat('../result_nll', filesep, experiment, filesep, value, filesep, experiment,'_',value,'_result.mat'),'output_result');
