%% Fig2
% Draw figure 2

%% parameters
addpath('../..');
addpath('../');
addpath('../../helper_function');
addpath('../experiments');

CC.high = [0.8902,0.3176,0.3569]; % stimulus condition where the RT should be longer than the low condition
CC.low = [0.3608,0.6510,0.7137]; % stimulus condition where the RT should be shorter than the high condition
num_repeat = 500;

fig = figure(2); 
clf(fig);
fig.Position = [-1572,229,1265,671];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Figure 2a          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eval('Anderson_2016');
Anderson_2016_result = load('../result_nll/Anderson_2016/alpha/Anderson_2016_alpha_result.mat');
model = 'EH';
mode = 'alpha';
X = Anderson_2016_result.output_result.(model).x;

[~, ~, alpha, ~, ~, ~, ~] = computeNLL(X, schedule, model, num_repeat, Exp_high_mean, 3, Exp_low_mean, 3, mode);
RT = X(1) * ( alpha + X(2) );
RT_test = RT(schedule.schedule_training_N+1:end,1:2,:);
RT_test_mean = mean(mean(RT_test,3),1);
RT_test_std = std(reshape(shiftdim(RT_test,1), 2, []), 0, 2);
RT_model = [ RT_test_mean, nan];

% high / Low / Control
data = [RT_high, RT_low, RT_none;...
    RT_none + RT_model];
    
% Plot
ax1 = subplot(1,2,1);

bobject = bar(data', 'FaceColor', 'flat', 'LineStyle', 'none');
bobject(1).CData = [0.4,0.4,0.4];
bobject(2).CData = [CC.high;CC.low;[0.4,0.4,0.4]];

hold on;
line([bobject(1).XEndPoints(1),bobject(1).XEndPoints(1)], [RT_high-3, RT_high+3], 'Color', 'k', 'LineWidth', 2);
line([bobject(1).XEndPoints(2),bobject(1).XEndPoints(2)], [RT_low-3, RT_low+3], 'Color', 'k', 'LineWidth', 2);
line([bobject(1).XEndPoints(3),bobject(1).XEndPoints(3)], [RT_none-3, RT_none+3], 'Color', 'k', 'LineWidth', 2);

% Axis
ylim([670,710]);
ylabel('RT (ms)');

% Texts
t = title('Anderson (2016)');
t.Position(2) = 710 + (710-670)*0.02; % slightly move up
t.FontSize = 13;
set(ax1, 'FontName', 'Times New Roman Bold');
set(ax1, 'FontSize', 13);
text(-60,565,'A', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');
xticklabels({'High-value', 'Low-value', 'Former nontarget'});

% Extend 
ax1.Position = [ax1.Position(1)-0.07, ax1.Position(2), ax1.Position(3)+0.07, ax1.Position(4)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Figure 2b          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eval('Mine_Saiki_2015');
Mine_Saiki_2015_result = load('../result_nll/Mine_Saiki_2015/alpha/Mine_Saiki_2015_alpha_result.mat');
X = Mine_Saiki_2015_result.output_result.EH.x;
model = 'EH';
mode = 'alpha';
[~, ~, alpha, ~, ~, ~, ~] = computeNLL(X, schedule, model, num_repeat, Exp_high_mean, 3, Exp_low_mean, 3, mode);
RT = X(1) * ( alpha + X(2) );
RT_test = RT(schedule.schedule_training_N+1:end,1:2,:);
RT_test_mean = mean(mean(RT_test,3),1);
RT_test_std = std(reshape(shiftdim(RT_test,1), 2, []), 0, 2);
RT_model = [ RT_test_mean, nan];

% high / Low / Control
data = [RT_high, RT_low, RT_none;...
    RT_none + RT_model];
    
% Plot
ax2 = subplot(1,2,2);

bobject = bar(data', 'FaceColor', 'flat', 'LineStyle', 'none');
bobject(1).CData = [0.4,0.4,0.4];
bobject(2).CData = [CC.high;CC.low;[0.4,0.4,0.4]];

hold on;
line([bobject(1).XEndPoints(1),bobject(1).XEndPoints(1)], [RT_high-3, RT_high+3], 'Color', 'k', 'LineWidth', 2);
line([bobject(1).XEndPoints(2),bobject(1).XEndPoints(2)], [RT_low-3, RT_low+3], 'Color', 'k', 'LineWidth', 2);
line([bobject(1).XEndPoints(3),bobject(1).XEndPoints(3)], [RT_none-3, RT_none+3], 'Color', 'k', 'LineWidth', 2);

% Axis
ylim([840,880]);
ylabel('RT (ms)');

% Texts
t = title('Mine & Saiki (2015) Exp2');
t.Position(2) = 880 + (880-840)*0.02; % slightly move up
t.FontSize = 13;
set(ax2, 'FontName', 'Times New Roman Bold');
set(ax2, 'FontSize', 13);
text(-60,565,'B', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');
xticklabels({'High-value', 'Low-value', 'Control'});

% Extend 
ax2.Position = [ax2.Position(1), ax2.Position(2), ax2.Position(3)+0.07, ax2.Position(4)];

saveas(fig, 'Fig2.png');
