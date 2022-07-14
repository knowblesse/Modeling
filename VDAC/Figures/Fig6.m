%% Fig6
% Draw figure 6
% LePelly EH-alpha (best) M-alpha (worst)
% Cho Exp2 SPH-alpha (best) M-alpha (worst)

%% parameters
rng('shuffle');
addpath('../..');
addpath('../');
addpath('../../helper_function');
addpath('../experiments');
addpath('../Cho & Cho (2021)');

CC.high = [0.8902,0.3176,0.3569]; % stimulus condition where the RT should be longer than the low condition
CC.low = [0.3608,0.6510,0.7137]; % stimulus condition where the RT should be shorter than the high condition
num_repeat = 500;

%% Experiment Data
RT_P = 15.76;
RT_NP = 19.05;

Exp_high_mean = RT_NP;
Exp_low_mean = RT_P;

high_reward = 1; % 100 points
low_reward = 0.5; % 50 points

%% Experiment Schedule - LePelly Exp2
% +--------+--------+--------+--------+---------------------------+
% | CS1    | CS2    | CS3    | US     | US intensity(reward size) |
% +--------+--------+--------+--------+---------------------------+
% | 1 or 0 | 1 or 0 | 1 or 0 | 1 or 0 | float                     |
% +--------+--------+--------+--------+---------------------------+
schedule = struct();
schedule.schedule_testing{1} = [...
    repmat([1,0,0,1,high_reward],9,1);... % NP-high
    repmat([1,0,0,0,0],9,1);... % NP-low    
    repmat([0,1,0,1,low_reward],18,1);... % P
    ]; % 36 trials x 5 blocks
schedule.schedule_testing_repeat{1} = 5;
schedule.schedule_testing{2} = [...
    repmat([1,0,0,1,high_reward],7,1);... % NP : high
    repmat([1,0,0,0,0],7,1);... % NP : low
    repmat([0,1,0,1,low_reward],14,1);... % P
    repmat([1,1,0,1,low_reward],8,1);... % P + NP : 50 points(low)
    ]; % 36 trials x (8 blocks(day1) + 13 blocks(day2)
schedule.schedule_testing_repeat{2} = 21;
schedule.schedule_testing_N = 36*5 + 36*21;

%% Make Figure
fig = figure(6);
clf(fig);
fig.Position = [-1572,229,1265,671];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Figure 6a          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'EH';
mode = 'alpha';
LePelly_et_al_2019_Exp2_result = load('../result_nll/LePelly_et_al_2019_Exp2/alpha/LePelly_et_al_2019_Exp2_alpha_result.mat');
X = LePelly_et_al_2019_Exp2_result.output_result.EH.x;

[negativeloglikelihood, V, alpha, Model_high, Model_low, Exp_high, Exp_low, Model_element_number] = computeNLL(X, schedule, model, num_repeat, Exp_high_mean, 3, Exp_low_mean, 3, mode);

% Plot
ax1 = subplot(2,2,1);
hold on;
[~,plot_1] = plot_shade(ax1, mean(alpha(:,1,:),3), std(alpha(:,1,:),0,3),'Color',CC.high,'LineWidth',2,'Shade',true);
[~,plot_2] = plot_shade(ax1, mean(alpha(:,2,:),3), std(alpha(:,2,:),0,3),'Color',CC.low,'LineWidth',2.3,'Shade',true);
patch([0, 936, 936, 0], [0,0,1,1], 'k', 'FaceAlpha', 0.05, 'EdgeColor', 'None')

axis tight

% Axis
xticks(100:100:900);
ylim([0,1]);
xlabel('Trials');
ylabel('alpha');

% Texts
t = title('LePelly et al. Exp2 EH-alpha');
t.Position(2) = 1.05; % slightly move up
t.FontSize = 13;
set(ax1, 'FontName', 'Times New Roman Bold');
set(ax1, 'FontSize', 13);
legend([plot_1{1}, plot_2{1}], {'Non Predictive', 'Predictive'}, 'Location','southeast', 'FontSize', 10);
text(-50,250,'A', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');

% Extend 
ax1.Position = [ax1.Position(1)-0.07, ax1.Position(2), ax1.Position(3)+0.10, ax1.Position(4)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Figure 6b          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'M';
mode = 'alpha';
LePelly_et_al_2019_Exp2_result = load('../result_nll/LePelly_et_al_2019_Exp2/alpha/LePelly_et_al_2019_Exp2_alpha_result.mat');
X = LePelly_et_al_2019_Exp2_result.output_result.M.x;

[negativeloglikelihood, V, alpha, Model_high, Model_low, Exp_high, Exp_low, Model_element_number] = computeNLL(X, schedule, model, num_repeat, Exp_high_mean, 3, Exp_low_mean, 3, mode);

% Plot
ax2 = subplot(2,2,2);
hold on;
[~,plot_1] = plot_shade(ax2, mean(alpha(:,1,:),3), std(alpha(:,1,:),0,3),'Color',CC.high,'LineWidth',2,'Shade',true);
[~,plot_2] = plot_shade(ax2, mean(alpha(:,2,:),3), std(alpha(:,2,:),0,3),'Color',CC.low,'LineWidth',2.3,'Shade',true);
patch([0, 936, 936, 0], [0,0,1,1], 'k', 'FaceAlpha', 0.05, 'EdgeColor', 'None')
axis tight

% Axis
xticks(100:100:900);
ylim([0,1]);
xlabel('Trials');
ylabel('alpha');

% Texts
t = title('LePelly Exp2 M-alpha', 'FontSize', 12);
t.Position(2) = 1.05;
t.FontSize = 13;
set(ax2, 'FontName', 'Times New Roman Bold');
set(ax2, 'FontSize', 13);
text(-50,250,'B', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');

% Extend
ax2.Position = [ax2.Position(1)-0.03, ax2.Position(2), ax2.Position(3)+0.10, ax2.Position(4)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Figure 6c          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

model = 'SPH';
mode = 'alpha';
Cho_Cho_2021_Exp2_result = load('../result_nll/Cho_Cho_2021_Exp2/alpha/Cho_Cho_2021_Exp2_alpha_result.mat');
X = Cho_Cho_2021_Exp2_result.output_result.SPH.x;

[negativeloglikelihood, V, alpha, SimulationResult, ExperimentResult, Model_element_number] = computeNLLCho(X, schedule, model, num_repeat, ExperimentData, mode);

% Plot
ax3 = subplot(2,2,3);
hold on;
[~,plot_1] = plot_shade(ax3, mean(alpha(:,1,:),3), std(alpha(:,1,:),0,3),'Color',CC.high,'LineWidth',2,'Shade',true);
[~,plot_2] = plot_shade(ax3, mean(alpha(:,2,:),3), std(alpha(:,2,:),0,3),'Color',CC.low,'LineWidth',2.3,'Shade',true);
patch([576, 864, 864,576], [0,0,1,1], 'k', 'FaceAlpha', 0.05, 'EdgeColor', 'None')
axis tight

% Axis
xticks(100:100:800);
ylim([0,1]);
xlabel('Trials');
ylabel('alpha');

% Texts
t = title('Cho & Cho Exp2 SPH-alpha');
t.Position(2) = 1.05;
t.FontSize = 13;
set(ax3, 'FontName', 'Times New Roman Bold');
set(ax3, 'FontSize', 13);
legend([plot_1{1}, plot_2{1}], {'uncertainty stimulus', 'certainty stimulus'}, 'FontSize', 10);
text(-50,250,'C', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');

% Extend
ax3.Position = [ax3.Position(1)-0.07, ax3.Position(2), ax3.Position(3)+0.10, ax3.Position(4)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Figure 6d          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'M';
mode = 'alpha';
X = Cho_Cho_2021_Exp2_result.output_result.SPH.x;

[negativeloglikelihood, V, alpha, SimulationResult, ExperimentResult, Model_element_number] = computeNLLCho(X, schedule, model, num_repeat, ExperimentData, mode);

% Plot
ax4 = subplot(2,2,4);
hold on;
[~,plot_1] = plot_shade(ax4, mean(alpha(:,1,:),3), std(alpha(:,1,:),0,3),'Color',CC.high,'LineWidth',2,'Shade',true);
[~,plot_2] = plot_shade(ax4, mean(alpha(:,2,:),3), std(alpha(:,2,:),0,3),'Color',CC.low,'LineWidth',2.3,'Shade',true);
patch([576, 864, 864,576], [0,0,1,1], 'k', 'FaceAlpha', 0.05, 'EdgeColor', 'None')
axis tight

% Axis
xticks(100:100:800);
xlabel('Trials');
ylabel('alpha');

% Texts
t = title('Cho & Cho Exp2 M-alpha');
t.Position(2) = 1.05;
t.FontSize = 13;
set(ax4, 'FontName', 'Times New Roman Bold');
set(ax4, 'FontSize', 13);
text(-50,250,'D', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');

% Extend
ax4.Position = [ax4.Position(1)-0.03, ax4.Position(2), ax4.Position(3)+0.10, ax4.Position(4)];

saveas(fig, 'Fig6.png');
