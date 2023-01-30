%% Fig7
% Draw figure 7
% EH a, M a LePelly Exp1
% EH a, M a LePelly Exp2

%% parameters
addpath('../');
addpath('../../helper_function');
addpath('../LePelly et al (2019)');
addpath('../experiments');

CC.high = [0.8902,0.3176,0.3569]; % stimulus condition where the RT should be longer than the low condition
CC.low = [0.3608,0.6510,0.7137]; % stimulus condition where the RT should be shorter than the high condition
CC.np = [0,0,0]; 
num_repeat = 500;

%% Make Figure
fig = figure(7); 
clf(fig);
fig.Position = [-1572,229,1265,671];

%% Experiment Data & Schedule - LePelly Exp1
% Experiment Data
ExperimentData.HighDistractor.Mean = 22.08;
ExperimentData.HighDistractor.SD = 3;
ExperimentData.LowDistractor.Mean = 16.14;
ExperimentData.LowDistractor.SD = 3;
ExperimentData.NPDistractor.Mean = 17.67;
ExperimentData.NPDistractor.SD = 3;

% Experiment Schedule
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
    ],21,1); % 36 trials x (8 blocks(day1) + 13 blocks(day2)
schedule.N = 36*5 + 36*21;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Figure 7a          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'EH';
value = 'alpha';
LePelly_et_al_2019_result = load('../result_nll/LePelly_et_al_2019/alpha/LePelly_et_al_2019_alpha_result.mat');
X = LePelly_et_al_2019_result.output_result.(model).x;

[~, ~, alpha, SimulationResult, ExperimentResult, ~] = computeNLL_LePelly(X, schedule, model, num_repeat, ExperimentData, value);

P = X(1) * ( alpha + X(2) );
P_test = P(:,1:3,:); % whole trial is used. no training session
P_test_mean = mean(mean(P_test,3),1);
P_test_std = std(reshape(shiftdim(P_test,1), 2, []), 0, 2);

% percentage
data = [...
    ExperimentData.HighDistractor.Mean, ExperimentData.LowDistractor.Mean, ExperimentData.NPDistractor.Mean;...
    P_test_mean];
    
% Plot
ax1 = subplot(2,2,1);

bobject = bar(data', 'FaceColor', 'flat', 'LineStyle', 'none');
bobject(1).CData = [0.4,0.4,0.4];
bobject(2).CData = [CC.high; CC.low; CC.np];

hold on;
line([bobject(1).XEndPoints(1),bobject(1).XEndPoints(1)], ...
    ExperimentData.HighDistractor.Mean + [-3, +3], 'Color', 'k', 'LineWidth', 2);
line([bobject(1).XEndPoints(2),bobject(1).XEndPoints(2)], ...
    ExperimentData.LowDistractor.Mean + [-3, +3], 'Color', 'k', 'LineWidth', 2);
line([bobject(1).XEndPoints(3),bobject(1).XEndPoints(3)], ...
    ExperimentData.NPDistractor.Mean + [-3, +3], 'Color', 'k', 'LineWidth', 2);

% Axis
ylim([0,25]);
ylabel('% trials', 'FontSize', 13);

% Texts
t = title('LePelly et al. (2019) Exp1 EH-alpha');
t.Position(2) = 25 + (25)*0.02; % slightly move up
t.FontSize = 13;
set(ax1, 'FontName', 'Times New Roman Bold');
set(ax1, 'FontSize', 13);
text(-40,250,'A', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');
xticklabels({'High Reward', 'Low Reward', 'Non-Predictable'});

% Extend 
ax1.Position = [ax1.Position(1)-0.07, ax1.Position(2), ax1.Position(3)+0.10, ax1.Position(4)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Figure 7b          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'M';
value = 'alpha';
X = LePelly_et_al_2019_result.output_result.(model).x;

[~, ~, alpha, SimulationResult, ExperimentResult, ~] = computeNLL_LePelly(X, schedule, model, num_repeat, ExperimentData, value);

P = X(1) * ( alpha + X(2) );
P_test = P(:,1:3,:); % whole trial is used. no training session
P_test_mean = mean(mean(P_test,3),1);
P_test_std = std(reshape(shiftdim(P_test,1), 2, []), 0, 2);

% percentage
data = [...
    ExperimentData.HighDistractor.Mean, ExperimentData.LowDistractor.Mean, ExperimentData.NPDistractor.Mean;...
    P_test_mean];
    
% Plot
ax2 = subplot(2,2,2);

bobject = bar(data', 'FaceColor', 'flat', 'LineStyle', 'none');
bobject(1).CData = [0.4,0.4,0.4];
bobject(2).CData = [CC.high; CC.low; CC.np];

hold on;
line([bobject(1).XEndPoints(1),bobject(1).XEndPoints(1)], ...
    ExperimentData.HighDistractor.Mean + [-3, +3], 'Color', 'k', 'LineWidth', 2);
line([bobject(1).XEndPoints(2),bobject(1).XEndPoints(2)], ...
    ExperimentData.LowDistractor.Mean + [-3, +3], 'Color', 'k', 'LineWidth', 2);
line([bobject(1).XEndPoints(3),bobject(1).XEndPoints(3)], ...
    ExperimentData.NPDistractor.Mean + [-3, +3], 'Color', 'k', 'LineWidth', 2);

% Axis
ylim([0,25]);
ylabel('% trials', 'FontSize', 13);

% Texts
t = title('LePelly et al. (2019) Exp1 M-alpha');
t.Position(2) = 25 + (25)*0.02; % slightly move up
t.FontSize = 13;
set(ax2, 'FontName', 'Times New Roman Bold');
set(ax2, 'FontSize', 13);
text(-40,250,'B', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');
xticklabels({'High Reward', 'Low Reward', 'Non-Predictable'});

% Extend 
ax2.Position = [ax2.Position(1)-0.03, ax2.Position(2), ax2.Position(3)+0.10, ax2.Position(4)];

%% Experiment Data & Schedule - LePelly Exp2
% Experiment Data
RT_P = 15.76;
RT_NP = 19.05;

Exp_high_mean = RT_NP;
Exp_low_mean = RT_P;

high_reward = 1; % 100 points
low_reward = 0.5; % 50 points

% Experiment Schedule
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Figure 7c          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'EH';
mode = 'alpha';
LePelly_et_al_2019_Exp2_result = load('../result_nll/LePelly_et_al_2019_Exp2/alpha/LePelly_et_al_2019_Exp2_alpha_result.mat');
X = LePelly_et_al_2019_Exp2_result.output_result.(model).x;

[~, ~, alpha, ~, ~, ~, ~] = computeNLL(X, schedule, model, num_repeat, Exp_high_mean, 3, Exp_low_mean, 3, mode);
P = X(1) * ( alpha + X(2) );
P_test = P(:,1:2,:); % whole trial is used. no training session
P_test_mean = mean(mean(P_test,3),1);
P_test_std = std(reshape(shiftdim(P_test,1), 2, []), 0, 2);

% percentage
data = [Exp_high_mean, Exp_low_mean; P_test_mean];
    
% Plot
ax3 = subplot(2,2,3);

bobject = bar(data', 'FaceColor', 'flat', 'LineStyle', 'none');
bobject(1).CData = [0.4,0.4,0.4];
bobject(2).CData = [CC.high;CC.low];

hold on;
line([bobject(1).XEndPoints(1),bobject(1).XEndPoints(1)], Exp_high_mean + [-3, +3], 'Color', 'k', 'LineWidth', 2);
line([bobject(1).XEndPoints(2),bobject(1).XEndPoints(2)], Exp_low_mean + [-3, +3], 'Color', 'k', 'LineWidth', 2);

% Axis
ylim([0,25]);
ylabel('% trials', 'FontSize', 13);

% Texts
t = title('LePelly et al. (2019) Exp2 EH-alpha');
t.Position(2) = 25 + (25)*0.02; % slightly move up
t.FontSize = 13;
set(ax3, 'FontName', 'Times New Roman Bold');
set(ax3, 'FontSize', 13);
text(-40,250,'C', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');
xticklabels({'Non-Predictable', 'Predictable'});

% Extend 
ax3.Position = [ax3.Position(1)-0.07, ax3.Position(2), ax3.Position(3)+0.10, ax3.Position(4)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Figure 7d          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'M';
mode = 'alpha';
X = LePelly_et_al_2019_Exp2_result.output_result.(model).x;

[~, ~, alpha, ~, ~, ~, ~] = computeNLL(X, schedule, model, num_repeat, Exp_high_mean, 3, Exp_low_mean, 3, mode);
P = X(1) * ( alpha + X(2) );
P_test = P(:,1:2,:); % whole trial is used. no training session
P_test_mean = mean(mean(P_test,3),1);
P_test_std = std(reshape(shiftdim(P_test,1), 2, []), 0, 2);

% percentage
data = [Exp_high_mean, Exp_low_mean; P_test_mean];
    
% Plot
ax4 = subplot(2,2,4);

bobject = bar(data', 'FaceColor', 'flat', 'LineStyle', 'none');
bobject(1).CData = [0.4,0.4,0.4];
bobject(2).CData = [CC.high;CC.low];

hold on;
line([bobject(1).XEndPoints(1),bobject(1).XEndPoints(1)], Exp_high_mean + [-3, +3], 'Color', 'k', 'LineWidth', 2);
line([bobject(1).XEndPoints(2),bobject(1).XEndPoints(2)], Exp_low_mean + [-3, +3], 'Color', 'k', 'LineWidth', 2);

% Axis
ylim([0,25]);
ylabel('% trials', 'FontSize', 13);

% Texts
t = title('LePelly et al. (2019) Exp2 M-alpha');
t.Position(2) = 25 + (25)*0.02; % slightly move up
t.FontSize = 13;
set(ax4, 'FontName', 'Times New Roman Bold');
set(ax4, 'FontSize', 13);
text(-40,250,'D', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');
xticklabels({'Non-Predictable', 'Predictable'});

% Extend 
ax4.Position = [ax4.Position(1)-0.03, ax4.Position(2), ax4.Position(3)+0.10, ax4.Position(4)];

saveas(fig, 'Fig7.png');
