%% Fig9
% Draw figure 9
% SPH a M a Cho Exp1
% SPH a M a Cho Exp2

%% parameters
addpath('../');
addpath('../../helper_function');
addpath('../Cho & Cho (2021)');

CC.high = [0.8902,0.3176,0.3569]; % stimulus condition where the RT should be longer than the low condition
CC.low = [0.3608,0.6510,0.7137]; % stimulus condition where the RT should be shorter than the high condition
num_repeat = 500;

%% Make Figure
fig = figure(9);
clf(fig);
fig.Position = [-1572,229,1265,671];

%% Experiment Data & Schedule - Cho & Cho Exp1
% Experiment Data
% all mean RT values are subtracted from RT of corresponding neutral condition
ExperimentData.NeutralRT = [606, 595]; 
ExperimentData.UncertaintyDistractor.Mean = [641 - 606, 605 - 595];
ExperimentData.UncertaintyDistractor.SD = 3;
ExperimentData.CertaintyDistractor.Mean = [603 - 606, 613 - 595]; 
ExperimentData.CertaintyDistractor.SD = 3;

% Experiment Schedule
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

testBlocks = {[577,576+144], [577+144, 576+144+144]};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Figure 9a          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'SPH';
mode = 'alpha';
Cho_Cho_2021_Exp1_result = load('../result_nll/Cho_Cho_2021_Exp1/alpha/Cho_Cho_2021_Exp1_alpha_result.mat');
X = Cho_Cho_2021_Exp1_result.output_result.(model).x;

[~, ~, alpha, ~, ~, ~] = computeNLL_Cho(X, schedule, model, num_repeat, ExperimentData, mode);

RT = X(1) * ( alpha + X(2) );

% uncertain real, uncertain simul, nan(for spacing), certain real, certain simul, nan, control
data = nan(2,5);
for block = 1 : 2
    data(block,:) = [...
        ExperimentData.UncertaintyDistractor.Mean(block), mean(RT(testBlocks{block}(1):testBlocks{block}(2), 1, :), 'all'), nan,...
        ExperimentData.CertaintyDistractor.Mean(block), mean(RT(testBlocks{block}(1):testBlocks{block}(2), 2, :), 'all')...
        ] + ExperimentData.NeutralRT(block);
end

% Plot
ax1 = subplot(2,2,1);

bobject = bar(data, 'FaceColor', 'flat', 'LineStyle', 'none', 'BarWidth', 1);
bobject(1).CData = [0.4,0.4,0.4];
bobject(2).CData = CC.high; % uncertainty
bobject(4).CData = [0.4,0.4,0.4];
bobject(5).CData = CC.low; % certainty

hold on;
for block = 1 : 2
    for ibar = [1,4]
        line([bobject(ibar).XEndPoints(block),bobject(ibar).XEndPoints(block)], [data(block,ibar)-3, data(block,ibar)+3], 'Color', 'k', 'LineWidth', 2);
    end
end

% block separtor
line([1.5, 1.5], ylim, 'Color', [0.4, 0.4, 0.4], 'LineWidth', 1, 'LineStyle', '--');

% Axis
ylim([570,650]);
ylabel('RT (ms)');
xticklabels({'Block1', 'Block2'});

% Texts
t = title('Cho & Cho (2021) Exp1 SPH-alpha');
t.Position(2) = 650 + (650-570)*0.02; % slightly move up
t.FontSize = 13;
set(ax1, 'FontName', 'Times New Roman Bold');
set(ax1, 'FontSize', 13);
text(-40,250,'A', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');

% Extend 
ax1.Position = [ax1.Position(1)-0.07, ax1.Position(2), ax1.Position(3)+0.10, ax1.Position(4)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Figure 9b          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'M';
mode = 'alpha';
Cho_Cho_2021_Exp1_result = load('../result_nll/Cho_Cho_2021_Exp1/alpha/Cho_Cho_2021_Exp1_alpha_result.mat');
X = Cho_Cho_2021_Exp1_result.output_result.(model).x;

[~, ~, alpha, ~, ~, ~] = computeNLL_Cho(X, schedule, model, num_repeat, ExperimentData, mode);

RT = X(1) * ( alpha + X(2) );

% uncertain real, uncertain simul, nan(for spacing), certain real, certain simul, nan, control
data = nan(2,5);
for block = 1 : 2
    data(block,:) = [...
        ExperimentData.UncertaintyDistractor.Mean(block), mean(RT(testBlocks{block}(1):testBlocks{block}(2), 1, :), 'all'), nan,...
        ExperimentData.CertaintyDistractor.Mean(block), mean(RT(testBlocks{block}(1):testBlocks{block}(2), 2, :), 'all')...
        ] + ExperimentData.NeutralRT(block);
end

% Plot
ax2 = subplot(2,2,2);

bobject = bar(data, 'FaceColor', 'flat', 'LineStyle', 'none', 'BarWidth', 1);
bobject(1).CData = [0.4,0.4,0.4];
bobject(2).CData = CC.high; % uncertainty
bobject(4).CData = [0.4,0.4,0.4];
bobject(5).CData = CC.low; % certainty

hold on;
for block = 1 : 2
    for ibar = [1,4]
        line([bobject(ibar).XEndPoints(block),bobject(ibar).XEndPoints(block)], [data(block,ibar)-3, data(block,ibar)+3], 'Color', 'k', 'LineWidth', 2);
    end
end

% block separtor
line([1.5, 1.5], ylim, 'Color', [0.4, 0.4, 0.4], 'LineWidth', 1, 'LineStyle', '--');

% Axis
ylim([570,650]);
ylabel('RT (ms)');
xticklabels({'Block1', 'Block2'});

% Texts
t = title('Cho & Cho (2021) Exp1 M-alpha');
t.Position(2) = 650 + (650-570)*0.02; % slightly move up
t.FontSize = 13;
set(ax2, 'FontName', 'Times New Roman Bold');
set(ax2, 'FontSize', 13);
text(-40,250,'B', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');
legend([bobject(2), bobject(5)], {'Uncertainty Distractor', 'Certainty Distractor'}, 'FontSize', 10);

% Extend 
ax2.Position = [ax2.Position(1)-0.03, ax2.Position(2), ax2.Position(3)+0.10, ax2.Position(4)];

%% Experiment Data & Schedule - Cho & Cho Exp2
% Experiment Data
% all mean RT values are subtracted from RT of corresponding neutral condition
ExperimentData.NeutralRT = [589, 581];
ExperimentData.UncertaintyDistractor.Mean = [621 - 589, 581 - 581];
ExperimentData.UncertaintyDistractor.SD = 3;
ExperimentData.CertaintyDistractor.Mean = [604 - 589, 598 - 581]; 
ExperimentData.CertaintyDistractor.SD = 3;

% Experiment Schedule
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

testBlocks = {[577,576+144], [577+144, 576+144+144]};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Figure 9c          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'SPH';
mode = 'alpha';
Cho_Cho_2021_Exp2_result = load('../result_nll/Cho_Cho_2021_Exp2/alpha/Cho_Cho_2021_Exp2_alpha_result.mat');
X = Cho_Cho_2021_Exp2_result.output_result.(model).x;

[~, ~, alpha, ~, ~, ~] = computeNLL_Cho(X, schedule, model, num_repeat, ExperimentData, mode);

RT = X(1) * ( alpha + X(2) );

% uncertain real, uncertain simul, nan(for spacing), certain real, certain simul, nan, control
data = nan(2,5);
for block = 1 : 2
    data(block,:) = [...
        ExperimentData.UncertaintyDistractor.Mean(block), mean(RT(testBlocks{block}(1):testBlocks{block}(2), 1, :), 'all'), nan,...
        ExperimentData.CertaintyDistractor.Mean(block), mean(RT(testBlocks{block}(1):testBlocks{block}(2), 2, :), 'all')...
        ] + ExperimentData.NeutralRT(block);
end

% Plot
ax3 = subplot(2,2,3);

bobject = bar(data, 'FaceColor', 'flat', 'LineStyle', 'none', 'BarWidth', 1);
bobject(1).CData = [0.4,0.4,0.4];
bobject(2).CData = CC.high; % uncertainty
bobject(4).CData = [0.4,0.4,0.4];
bobject(5).CData = CC.low; % certainty

hold on;
for block = 1 : 2
    for ibar = [1,4]
        line([bobject(ibar).XEndPoints(block),bobject(ibar).XEndPoints(block)], [data(block,ibar)-3, data(block,ibar)+3], 'Color', 'k', 'LineWidth', 2);
    end
end

% block separtor
line([1.5, 1.5], ylim, 'Color', [0.4, 0.4, 0.4], 'LineWidth', 1, 'LineStyle', '--');

% Axis
ylim([570,650]);
ylabel('RT (ms)');
xticklabels({'Block1', 'Block2'});

% Texts
t = title('Cho & Cho (2021) Exp2 SPH-alpha');
t.Position(2) = 650 + (650-570)*0.02; % slightly move up
t.FontSize = 13;
set(ax3, 'FontName', 'Times New Roman Bold');
set(ax3, 'FontSize', 13);
text(-40,250,'C', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');


% Extend 
ax3.Position = [ax3.Position(1)-0.07, ax3.Position(2), ax3.Position(3)+0.10, ax3.Position(4)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Figure 9d          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'M';
mode = 'alpha';
X = Cho_Cho_2021_Exp2_result.output_result.(model).x;

[~, ~, alpha, ~, ~, ~] = computeNLL_Cho(X, schedule, model, num_repeat, ExperimentData, mode);

RT = X(1) * ( alpha + X(2) );

% uncertain real, uncertain simul, nan(for spacing), certain real, certain simul, nan, control
data = nan(2,5);
for block = 1 : 2
    data(block,:) = [...
        ExperimentData.UncertaintyDistractor.Mean(block), mean(RT(testBlocks{block}(1):testBlocks{block}(2), 1, :), 'all'), nan,...
        ExperimentData.CertaintyDistractor.Mean(block), mean(RT(testBlocks{block}(1):testBlocks{block}(2), 2, :), 'all')...
        ] + ExperimentData.NeutralRT(block);
end

% Plot
ax4 = subplot(2,2,4);

bobject = bar(data, 'FaceColor', 'flat', 'LineStyle', 'none', 'BarWidth', 1);
bobject(1).CData = [0.4,0.4,0.4];
bobject(2).CData = CC.high; % uncertainty
bobject(4).CData = [0.4,0.4,0.4];
bobject(5).CData = CC.low; % certainty

hold on;
for block = 1 : 2
    for ibar = [1,4]
        line([bobject(ibar).XEndPoints(block),bobject(ibar).XEndPoints(block)], [data(block,ibar)-3, data(block,ibar)+3], 'Color', 'k', 'LineWidth', 2);
    end
end

% block separtor
line([1.5, 1.5], ylim, 'Color', [0.4, 0.4, 0.4], 'LineWidth', 1, 'LineStyle', '--');

% Axis
ylim([570,650]);
ylabel('RT (ms)', 'FontSize', 13);
xticklabels({'Block1', 'Block2'});

% Texts
t = title('Cho & Cho (2021) Exp2 M-alpha');
t.Position(2) = 650 + (650-570)*0.02; % slightly move up
t.FontSize = 13;
set(ax4, 'FontName', 'Times New Roman Bold');
set(ax4, 'FontSize', 13);
text(-40,250,'D', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');
legend([bobject(2), bobject(5)], {'Uncertainty Distractor', 'Certainty Distractor'}, 'FontSize', 10);

% Extend 
ax4.Position = [ax4.Position(1)-0.03, ax4.Position(2), ax4.Position(3)+0.10, ax4.Position(4)];

saveas(fig, 'Fig9.png');
