%% Fig4
% Draw figure 4
% EH-V model, RW-V : ext + acq
% EH-a model, SPH-a : acq


%% parameters
rng('shuffle');
addpath('../..');
addpath('../');
addpath('../../helper_function');
addpath('../experiments');
addpath('../Liao et al (2020)');

CC.high = [0.8902,0.3176,0.3569]; % stimulus condition where the RT should be longer than the low condition
CC.low = [0.3608,0.6510,0.7137]; % stimulus condition where the RT should be shorter than the high condition
num_repeat = 500;

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

testBlocks = {[90, 186], [276, 372], [462, 558], [648, 744]};

%% Make Figure
fig = figure(4);
clf(fig);
fig.Position = [-1572,229,1265,671];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Figure 4a          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'EH';
mode = 'V';
Liao_et_al_2020_result = load('../result_nll/Liao_et_al_2020/V/Liao_et_al_2020_V_result.mat');
X = Liao_et_al_2020_result.output_result.EH.x;

[negativeloglikelihood, V, alpha, SimulationResult, ExperimentResult, Model_element_number] = computeNLL3(X, schedule, model, num_repeat, ExperimentData, mode);

% Plot
ax1 = subplot(2,2,1);
hold on;
[~,plot_1] = plot_shade(ax1, mean(V(:,1,:),3), std(V(:,1,:),0,3),'Color',CC.high,'LineWidth',2,'Shade',true);
[~,plot_2] = plot_shade(ax1, mean(V(:,3,:),3), std(V(:,3,:),0,3),'Color',CC.low,'LineWidth',2.3,'Shade',true);
patch([testBlocks{1}(1), testBlocks{1}(2), testBlocks{1}(2), testBlocks{1}(1)], [0,0,0.3,0.3], 'k', 'FaceAlpha', 0.05, 'EdgeColor', 'None')
patch([testBlocks{2}(1), testBlocks{2}(2), testBlocks{2}(2), testBlocks{2}(1)], [0,0,0.3,0.3], 'k', 'FaceAlpha', 0.05, 'EdgeColor', 'None')
patch([testBlocks{3}(1), testBlocks{3}(2), testBlocks{3}(2), testBlocks{3}(1)], [0,0,0.3,0.3], 'k', 'FaceAlpha', 0.05, 'EdgeColor', 'None')
patch([testBlocks{4}(1), testBlocks{4}(2), testBlocks{4}(2), testBlocks{4}(1)], [0,0,0.3,0.3], 'k', 'FaceAlpha', 0.05, 'EdgeColor', 'None')

axis tight

% Axis
xticks(100:100:700);
ylim([0,0.3]);
xlabel('Trials');
ylabel('V');

% Texts
t = title('EH-V');
t.Position(2) = 1.05*0.3; % slightly move up
t.FontSize = 13;
set(ax1, 'FontName', 'Times New Roman Bold');
set(ax1, 'FontSize', 13);
legend([plot_1{1}, plot_2{1}], {'old high-rewareded', 'new high-rewarded'}, 'FontSize', 10);
text(-50,250,'A', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');

% Extend 
ax1.Position = [ax1.Position(1)-0.07, ax1.Position(2), ax1.Position(3)+0.10, ax1.Position(4)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Figure 4b          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'RW';
mode = 'V';
Liao_et_al_2020_result = load('../result_nll/Liao_et_al_2020/V/Liao_et_al_2020_V_result.mat');
X = Liao_et_al_2020_result.output_result.RW.x;

[negativeloglikelihood, V, alpha, SimulationResult, ExperimentResult, Model_element_number] = computeNLL3(X, schedule, model, num_repeat, ExperimentData, mode);

% Plot
ax2 = subplot(2,2,2);
hold on;
[~,plot_1] = plot_shade(ax2, mean(V(:,1,:),3), std(V(:,1,:),0,3),'Color',CC.high,'LineWidth',2,'Shade',true);
[~,plot_2] = plot_shade(ax2, mean(V(:,3,:),3), std(V(:,3,:),0,3),'Color',CC.low,'LineWidth',2.3,'Shade',true);
patch([testBlocks{1}(1), testBlocks{1}(2), testBlocks{1}(2), testBlocks{1}(1)], [0,0,1,1], 'k', 'FaceAlpha', 0.05, 'EdgeColor', 'None')
patch([testBlocks{2}(1), testBlocks{2}(2), testBlocks{2}(2), testBlocks{2}(1)], [0,0,1,1], 'k', 'FaceAlpha', 0.05, 'EdgeColor', 'None')
patch([testBlocks{3}(1), testBlocks{3}(2), testBlocks{3}(2), testBlocks{3}(1)], [0,0,1,1], 'k', 'FaceAlpha', 0.05, 'EdgeColor', 'None')
patch([testBlocks{4}(1), testBlocks{4}(2), testBlocks{4}(2), testBlocks{4}(1)], [0,0,1,1], 'k', 'FaceAlpha', 0.05, 'EdgeColor', 'None')
axis tight

% Axis
xticks(100:100:700);
ylim([0,1]);
xlabel('Trials');
ylabel('V');

% Texts
t = title('RW-V', 'FontSize', 12);
t.Position(2) = 1.05;
t.FontSize = 13;
set(ax2, 'FontName', 'Times New Roman Bold');
set(ax2, 'FontSize', 13);
text(-50,250,'B', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');

% Extend
ax2.Position = [ax2.Position(1)-0.03, ax2.Position(2), ax2.Position(3)+0.10, ax2.Position(4)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Figure 4c          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'EH';
mode = 'alpha';
Liao_et_al_2020_result = load('../result_nll/Liao_et_al_2020/alpha/Liao_et_al_2020_alpha_result.mat');
X = Liao_et_al_2020_result.output_result.EH.x;

[negativeloglikelihood, V, alpha, SimulationResult, ExperimentResult, Model_element_number] = computeNLL3(X, schedule, model, num_repeat, ExperimentData, mode);

% Plot
ax3 = subplot(2,2,3);
hold on;
[~,plot_1] = plot_shade(ax3, mean(alpha(:,1,:),3), std(alpha(:,1,:),0,3),'Color',CC.high,'LineWidth',2,'Shade',true);
[~,plot_2] = plot_shade(ax3, mean(alpha(:,3,:),3), std(alpha(:,3,:),0,3),'Color',CC.low,'LineWidth',2.3,'Shade',true);
patch([testBlocks{1}(1), testBlocks{1}(2), testBlocks{1}(2), testBlocks{1}(1)], [0,0,2,2], 'k', 'FaceAlpha', 0.05, 'EdgeColor', 'None')
patch([testBlocks{2}(1), testBlocks{2}(2), testBlocks{2}(2), testBlocks{2}(1)], [0,0,2,2], 'k', 'FaceAlpha', 0.05, 'EdgeColor', 'None')
patch([testBlocks{3}(1), testBlocks{3}(2), testBlocks{3}(2), testBlocks{3}(1)], [0,0,2,2], 'k', 'FaceAlpha', 0.05, 'EdgeColor', 'None')
patch([testBlocks{4}(1), testBlocks{4}(2), testBlocks{4}(2), testBlocks{4}(1)], [0,0,2,2], 'k', 'FaceAlpha', 0.05, 'EdgeColor', 'None')
axis tight

% Axis
xticks(100:100:700);
ylim([0,2]);
xlabel('Trials');
ylabel('alpha');

% Texts
t = title('EH-alpha');
t.Position(2) = 2.1;
t.FontSize = 13;
set(ax3, 'FontName', 'Times New Roman Bold');
set(ax3, 'FontSize', 13);
text(-50,250,'C', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');

% Extend
ax3.Position = [ax3.Position(1)-0.07, ax3.Position(2), ax3.Position(3)+0.10, ax3.Position(4)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Figure 4d          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'SPH';
mode = 'alpha';
Liao_et_al_2020_result = load('../result_nll/Liao_et_al_2020/alpha/Liao_et_al_2020_alpha_result.mat');
X = Liao_et_al_2020_result.output_result.SPH.x;

[negativeloglikelihood, V, alpha, SimulationResult, ExperimentResult, Model_element_number] = computeNLL3(X, schedule, model, num_repeat, ExperimentData, mode);

% Plot
ax4 = subplot(2,2,4);
hold on;
[~,plot_1] = plot_shade(ax4, mean(alpha(:,1,:),3), std(alpha(:,1,:),0,3),'Color',CC.high,'LineWidth',2,'Shade',true);
[~,plot_2] = plot_shade(ax4, mean(alpha(:,3,:),3), std(alpha(:,3,:),0,3),'Color',CC.low,'LineWidth',2.3,'Shade',true);
patch([testBlocks{1}(1), testBlocks{1}(2), testBlocks{1}(2), testBlocks{1}(1)], [0,0,1,1], 'k', 'FaceAlpha', 0.05, 'EdgeColor', 'None')
patch([testBlocks{2}(1), testBlocks{2}(2), testBlocks{2}(2), testBlocks{2}(1)], [0,0,1,1], 'k', 'FaceAlpha', 0.05, 'EdgeColor', 'None')
patch([testBlocks{3}(1), testBlocks{3}(2), testBlocks{3}(2), testBlocks{3}(1)], [0,0,1,1], 'k', 'FaceAlpha', 0.05, 'EdgeColor', 'None')
patch([testBlocks{4}(1), testBlocks{4}(2), testBlocks{4}(2), testBlocks{4}(1)], [0,0,1,1], 'k', 'FaceAlpha', 0.05, 'EdgeColor', 'None')
axis tight

% Axis
xticks(100:100:700);
xlabel('Trials');
ylabel('alpha');

% Texts
t = title('SPH-alpha');
t.Position(2) = 1.05;
t.FontSize = 13;
set(ax4, 'FontName', 'Times New Roman Bold');
set(ax4, 'FontSize', 13);
text(-50,250,'D', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');

% Extend
ax4.Position = [ax4.Position(1)-0.03, ax4.Position(2), ax4.Position(3)+0.10, ax4.Position(4)];

saveas(fig, 'Fig4.png');
