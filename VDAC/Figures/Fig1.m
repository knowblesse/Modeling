%% Fig1
% Draw figure 1

%% parameters
rng('shuffle');
addpath('../..');
addpath('../');
addpath('../../helper_function');
addpath('../experiments');

CC.high = [0.8902,0.3176,0.3569]; % stimulus condition where the RT should be longer than the low condition
CC.low = [0.3608,0.6510,0.7137]; % stimulus condition where the RT should be shorter than the high condition
num_repeat = 500;

fig = figure(1);
clf(fig);
fig.Position = [-1572,229,1265,671];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Figure 1a          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eval('Anderson_2016');
model = 'RW';
mode = 'V';
Anderson_2016_result = load('../result_nll/Anderson_2016/V/Anderson_2016_V_result.mat');
X = Anderson_2016_result.output_result.RW.x;

[negativeloglikelihood, V, alpha, Model_high, Model_low, Exp_high, Exp_low] = computeNLL(X, schedule, model, num_repeat, Exp_high_mean, 3, Exp_low_mean, 3, mode);

% Plot
ax1 = subplot(2,2,1);
hold on;
[~,plot_1] = plot_shade(ax1, mean(V(:,1,:),3), std(V(:,1,:),0,3),'Color',CC.high,'LineWidth',2.3,'Shade',true);
[~,plot_2] = plot_shade(ax1, mean(V(:,2,:),3), std(V(:,2,:),0,3),'Color',CC.low,'LineWidth',2,'Shade',true);
patch([480,size(V,1),size(V,1), 480], [0,0,1,1], 'k', 'FaceAlpha', 0.05, 'EdgeColor', 'None')
axis tight

% Axis
xticks(50:50:600);
ylim([0,1]);
xlabel('Trials');
ylabel('V'); 

% Texts
t = title('Anderson (2016)');
t.Position(2) = 1.05; % slightly move up
t.FontSize = 13;
set(ax1, 'FontName', 'Times New Roman Bold');
set(ax1, 'FontSize', 13);
legend([plot_1{1}, plot_2{1}], {'high EV', 'low EV'}, 'FontSize',10);
text(-50,250,'A', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');

% Extend 
ax1.Position = [ax1.Position(1)-0.07, ax1.Position(2), ax1.Position(3)+0.10, ax1.Position(4)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Figure 1b          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eval('Anderson_Halpern_2017');
model = 'RW';
mode = 'V';
Anderson_Halpern_2017_result = load('../result_nll/Anderson_Halpern_2017/V/Anderson_Halpern_2017_V_result.mat');
X = Anderson_Halpern_2017_result.output_result.RW.x;

[negativeloglikelihood, V, alpha, Model_high, Model_low, Exp_high, Exp_low] = computeNLL(X, schedule, model, num_repeat, Exp_high_mean, 3, Exp_low_mean, 3, mode);

% Plot
ax2 = subplot(2,2,2);
hold on;
[~,plot_1] = plot_shade(ax2, mean(V(:,1,:),3), std(V(:,1,:),0,3),'Color',CC.high,'LineWidth',2.3,'Shade',true);
[~,plot_2] = plot_shade(ax2, mean(V(:,2,:),3), std(V(:,2,:),0,3),'Color',CC.low,'LineWidth',2,'Shade',true);
patch([240,size(V,1),size(V,1), 240], [0,0,1,1], 'k', 'FaceAlpha', 0.05, 'EdgeColor', 'None');
axis tight

% Axis
xticks(50:50:450);
ylim([0,1]);
xlabel('Trials');
ylabel('V');

% Texts
t = title('Anderson & Halpern (2017) Exp1', 'FontSize', 12);
t.Position(2) = 1.05;
t.FontSize = 13;
set(ax2, 'FontName', 'Times New Roman Bold');
set(ax2, 'FontSize', 13);
legend([plot_1{1}, plot_2{1}], {'high EV', 'low EV'}, 'FontSize',10);
text(-50,250,'B', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');

% Extend
ax2.Position = [ax2.Position(1)-0.03, ax2.Position(2), ax2.Position(3)+0.10, ax2.Position(4)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Figure 1c          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eval('Mine_Saiki_2015');
model = 'RW';
mode = 'V';
Mine_Saiki_2015_result = load('../result_nll/Mine_Saiki_2015/V/Mine_Saiki_2015_V_result.mat');
X = Mine_Saiki_2015_result.output_result.RW.x;

[negativeloglikelihood, V, alpha, Model_high, Model_low, Exp_high, Exp_low] = computeNLL(X, schedule, model, num_repeat, Exp_high_mean, 3, Exp_low_mean, 3, mode);

% Plot
ax3 = subplot(2,2,3);
hold on;
[~,plot_1] = plot_shade(ax3, mean(V(:,1,:),3), std(V(:,1,:),0,3),'Color',CC.high,'LineWidth',2.3,'Shade',true);
[~,plot_2] = plot_shade(ax3, mean(V(:,2,:),3), std(V(:,2,:),0,3),'Color',CC.low,'LineWidth',2,'Shade',true);
patch([240,size(V,1),size(V,1), 240], [0,0,1,1], 'k', 'FaceAlpha', 0.05, 'EdgeColor', 'None');
axis tight

% Axis
ylim([0,1]);
xlabel('Trials');
ylabel('V');

% Texts
t = title('Mine & Saiki (2015) Exp2');
t.Position(2) = 1.05;
t.FontSize = 13;
set(ax3, 'FontName', 'Times New Roman Bold');
set(ax3, 'FontSize', 13);
legend([plot_1{1}, plot_2{1}], {'high EV', 'low EV'}, 'FontSize', 10);
text(-50,250,'C', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');

% Extend
ax3.Position = [ax3.Position(1)-0.07, ax3.Position(2), ax3.Position(3)+0.10, ax3.Position(4)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Figure 1d          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eval('Anderson_2011');
model = 'RW';
mode = 'V';
Anderson_2011_result = load('../result_nll/Anderson_2011/V/Anderson_2011_V_result.mat');
X = Anderson_2011_result.output_result.RW.x;

[negativeloglikelihood, V, alpha, Model_high, Model_low, Exp_high, Exp_low] = computeNLL(X, schedule, model, num_repeat, Exp_high_mean, 3, Exp_low_mean, 3, mode);

% Plot
ax4 = subplot(2,2,4);
hold on;
[~,plot_1] = plot_shade(ax4, mean(V(:,1,:),3), std(V(:,1,:),0,3),'Color',CC.high,'LineWidth',2.3,'Shade',true);
[~,plot_2] = plot_shade(ax4, mean(V(:,2,:),3), std(V(:,2,:),0,3),'Color',CC.low,'LineWidth',2,'Shade',true);
patch([1010,size(V,1),size(V,1), 1010], [0,0,1,1], 'k', 'FaceAlpha', 0.05, 'EdgeColor', 'None');
axis tight

% Axis
ylim([0,1]);
xlabel('Trials');
ylabel('V');

% Texts
t = title('Anderson et al. (2011b) Exp1');
t.Position(2) = 1.05;
t.FontSize = 13;
set(ax4, 'FontName', 'Times New Roman Bold');
set(ax4, 'FontSize', 13);
legend([plot_1{1}, plot_2{1}], {'high EV', 'low EV'}, 'FontSize',10);
text(-50,250,'D', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');

% Extend
ax4.Position = [ax4.Position(1)-0.03, ax4.Position(2), ax4.Position(3)+0.10, ax4.Position(4)];

saveas(fig, 'Fig1.png');
