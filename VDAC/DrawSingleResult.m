%% DrawSingleResult
% Draw single simulation result with given parameters
% Debug script

%% parameters
rng('shuffle');
addpath('..');
addpath('../helper_function');
addpath('./experiments');

mode = 'alpha';
num_repeat = 200;

CC.high = [231,124,141]./255; % stimulus condition where the RT should be longer than the low condition
CC.low = [94,165,197]./255; % stimulus condition where the RT should be shorter than the high condition

%% Load Experiment
exp = 'Anderson_2011';
eval(exp);

model = 'EH';

X = [...
    30,...
    -0.1,...
    0.07,...%lr1_acq
    0.07,...%lr2_acq
    0.07,...%lr1_ext
    0.01,...%lr2_ext
    0.4,...%k
    0.01,...%lr_pre
    ];

[negativeloglikelihood, V, alpha, Model_high, Model_low, Exp_high, Exp_low] = evalWholeModel(X, schedule, model, num_repeat, Exp_high_mean, 3, Exp_low_mean, 3, mode);

%% Plot Data
fig = figure(1);
clf(fig);
fig.Position = [200, 120, 1200, 800];
ax1 = subplot(2,4,1:3);
if strcmp(mode, 'V')
    [~,plot_1] = plot_shade(ax1, mean(V(:,1,:),3), std(V(:,1,:),0,3),'Color',CC.high,'LineWidth',2.3,'Shade',true);
    [~,plot_2] = plot_shade(ax1, mean(V(:,2,:),3), std(V(:,2,:),0,3),'Color',CC.low,'LineWidth',2,'Shade',true);
elseif strcmp(mode, 'alpha')
    [~,plot_1] = plot_shade(ax1, mean(alpha(:,1,:),3), std(alpha(:,1,:),0,3),'Color',CC.high,'LineWidth',2.3,'Shade',true);
    [~,plot_2] = plot_shade(ax1, mean(alpha(:,2,:),3), std(alpha(:,2,:),0,3),'Color',CC.low,'LineWidth',2,'Shade',true);
end
ylim([0,1]);
legend([plot_1{1}, plot_2{1}], {'high reward', 'low reward'});

ax2 = subplot(2,4,4);
bar((1:50)-0.25, Model_high, 'FaceColor', CC.high, 'BarWidth',0.5);
hold on;
bar((1:50)+0.25, Model_low, 'FaceColor', CC.low, 'BarWidth', 0.5);
ax2.View = [90, -90];

ax3 = subplot(2,4,5:6);
hold on;
bar((1:50)-0.25, Model_high, 'FaceColor', CC.high, 'BarWidth',0.5);
bar((1:50)+0.25, Model_low, 'FaceColor', CC.low, 'BarWidth', 0.5);
plot(Exp_high, 'Color', CC.high);
plot(Exp_low, 'Color', CC.low);

ax4 = subplot(2,4,7:8);
cla;
axis off;
text(0.05, 1, strcat("Model : ", model), 'FontSize', 20);
text(0.05, 0.8, strcat("Negative Log-Likelihood : ", num2str(negativeloglikelihood)), 'FontSize', 20);
text(0.05, 0.6, strcat("Parameters : ", num2str(X(1)), " ", num2str(X(2))), 'FontSize', 20);