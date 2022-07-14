%% Fig5
% Draw figure 5

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
ExperimentData.NeutralRT = [463.1204, 436.3744, 446.7162, 419.8514];
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
fig = figure(5);
clf(fig);
fig.Position = [-1572,229,1265,671];
ax1 = subplot(1,1,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Figure 4          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'EH';
mode = 'alpha';
Liao_et_al_2020_result = load('../result_nll/Liao_et_al_2020/alpha/Liao_et_al_2020_alpha_result.mat');
X = Liao_et_al_2020_result.output_result.(model).x;

[negative_log, ~, alpha, ~, ~, ~] = computeNLL3(X, schedule, model, num_repeat, ExperimentData, mode);
RT = X(1) * ( alpha + X(2) );

% old high real, old high simul, nan(for spacing), new high real, new high simul, nan, low real, low simul, control
data = nan(4,10);
for block = 1 : 4
    data(block,:) = [...
        ExperimentData.OldHighDistractor.Mean(block), mean(RT(testBlocks{block}(1):testBlocks{block}(2), 1, :), 'all'), nan,...
        ExperimentData.NewHighDistractor.Mean(block), mean(RT(testBlocks{block}(1):testBlocks{block}(2), 3, :), 'all'), nan,...
        ExperimentData.LowDistractor.Mean(block), mean(RT(testBlocks{block}(1):testBlocks{block}(2), 2, :), 'all'), nan,...
        0] + ExperimentData.NeutralRT(block);
end

bobject = bar(data, 'FaceColor', 'flat', 'LineStyle', 'none', 'BarWidth', 1);
bobject(1).CData = [0.4,0.4,0.4];
bobject(2).CData = CC.high; % old high
bobject(4).CData = [0.4,0.4,0.4];
bobject(5).CData = CC.low; % new high
bobject(7).CData = [0.4,0.4,0.4];
bobject(8).CData = [0,155,107]/255; % low
bobject(10).CData = [0.4,0.4,0.4];

hold on;
for block = 1 : 4
    for ibar = [1,4,7,10]
        line([bobject(ibar).XEndPoints(block),bobject(ibar).XEndPoints(block)], [data(block,ibar)-3, data(block,ibar)+3], 'Color', 'k', 'LineWidth', 2);
    end
end

% block separtor
line([1.5, 1.5], ylim, 'Color', [0.4, 0.4, 0.4], 'LineWidth', 1, 'LineStyle', '--');
line([2.5, 2.5], ylim, 'Color', [0.4, 0.4, 0.4], 'LineWidth', 1, 'LineStyle', '--');
line([3.5, 3.5], ylim, 'Color', [0.4, 0.4, 0.4], 'LineWidth', 1, 'LineStyle', '--');


% Axis
ylim([400,480]);
ylabel('RT (ms)');

% Texts
t = title('Liao et al. (2020)');
t.Position(2) = 480 + (480-400)*0.02; % slightly move up
t.FontSize = 13;
set(ax1, 'FontName', 'Times New Roman Bold');
set(ax1, 'FontSize', 13);
xticklabels({'Block1', 'Block2', 'Block3', 'Block4'});
legend([bobject(2), bobject(5), bobject(8)], {'old high-value', 'new high-value', 'low-value'});

% Extend 
ax1.Position = [ax1.Position(1)-0.07, ax1.Position(2), ax1.Position(3)+0.14, ax1.Position(4)];

saveas(fig, 'Fig5.png');
