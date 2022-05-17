%% Cho_Cho_Exp2_2021
% Cho & Cho 2021 Experiment 2 simulation
experiment = 'Cho_Cho_2021_Exp2';
value = 'alpha';
model = 'EH';

rng('shuffle');
addpath('../../helper_function');
addpath('../..');

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
high_reward = 1; %100 points
low_reward = 0.25; %25 points

schedule = struct();
schedule.schedule_training = [...
    repmat([1,0,0,1,high_reward],1,1);...
    repmat([1,0,0,0,0],3,1);...
    repmat([0,1,0,1,low_reward],4,1);...
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

%% Load Parameters
[param, opt_option] = getDefaultParam();

X = [45.9,-0.17, ...%
    0.602, 0.364, ... % lr1 acq lr2 acq
    0.087, 0.005, ... % lr1 ext lr2 ext
    0.487, 0.082]; % k lr_pre

%% Draw Result
[negativeloglikelihood, V, alpha, SimulationResult, ExperimentResult, Model_element_number] = ...
    computeNLLCho(X, schedule, model, num_repeat, ExperimentData, value);

%% Print result
fprintf('-----------%5s------------\n', model);
fprintf('Negative Log Likelihood : %f\n', negativeloglikelihood);
fprintf('Best Param :\n');

fig = figure('name', model, 'Position', [-1650, 346, 1140, 546]);
ax1 = subplot(2,4,1:4);
if strcmp(value, 'V')
[~,plot_1] = plot_shade(ax1, mean(V(:,1,:),3), std(V(:,1,:),0,3),'Color',CC.uncertainty,'LineWidth',2.3,'Shade',true);
[~,plot_2] = plot_shade(ax1, mean(V(:,2,:),3), std(V(:,2,:),0,3),'Color',CC.certainty,'LineWidth',2,'Shade',true);
elseif strcmp(value, 'alpha')
[~,plot_1] = plot_shade(ax1, mean(alpha(:,1,:),3), std(alpha(:,1,:),0,3),'Color',CC.uncertainty,'LineWidth',2.3,'Shade',true);
[~,plot_2] = plot_shade(ax1, mean(alpha(:,2,:),3), std(alpha(:,2,:),0,3),'Color',CC.certainty,'LineWidth',2,'Shade',true);
end
ylim([0,2]);
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

