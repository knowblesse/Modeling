%% Fig3
% Draw figure 3

%% parameters
rng('shuffle');
addpath('../');
addpath('../../helper_function');
addpath('../experiments');
addpath('../AndersonPLOS1 (2011)');

CC.high = [0.8902,0.3176,0.3569]; % stimulus condition where the RT should be longer than the low condition
CC.low = [0.3608,0.6510,0.7137]; % stimulus condition where the RT should be shorter than the high condition
num_repeat = 500;

fig = figure(3);
clf(fig);
fig.Position = [-1572,29,1265,895];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%          Figure 3a top        %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Anderson_et_al_PLOS1_2011;
model = 'M';
value = 'alpha';
Anderson_et_al_PLOS1_2011_result = load(strcat('../result_nll/Anderson_et_al_PLOS1_2011/', value, '/Anderson_et_al_PLOS1_2011_', value, '_result.mat'));
X = Anderson_et_al_PLOS1_2011_result.output_result.(model).x;

[negativeloglikelihood, V, alpha, SimulationResult, ExperimentResult, Model_element_number] = computeNLL_AndersonPLOS1(X, schedule, model, num_repeat, ExperimentData, value);

% Plot
ax1 = subplot(4,10,1:10);
hold on;
[~,plot_1] = plot_shade(ax1, mean(alpha(:,1,:),3), std(alpha(:,1,:),0,3),'Color',CC.high,'LineWidth',2.3,'Shade',true);
[~,plot_2] = plot_shade(ax1, mean(alpha(:,2,:),3), std(alpha(:,2,:),0,3),'Color',CC.low,'LineWidth',2,'Shade',true);
axis tight

% Axis
ylim([0.4,1]);
xticks([]);
ylabel('alpha');

% Texts
t = title('M-alpha');
t.Position(2) = 1.05;
t.FontSize = 13;
set(ax1, 'FontName', 'Times New Roman Bold');
set(ax1, 'FontSize', 13);
legend([plot_1{1}, plot_2{1}], {'high EV', 'low EV'}, 'FontSize',10);
text(-50,170,'A', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');

% Extend?
ax1.Position = [ax1.Position(1)-0.07, ax1.Position(2), ax1.Position(3)+0.07*2, ax1.Position(4)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%          Figure 3a bot        %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax2 = cell(10,1);
for i = 1 : 10
    ax2{i} = subplot(4,10,10+i);
    cla(ax2{i});
    ax2{i}.View = [90, -90];
    hold on;
    bar((1:50)-0.25, SimulationResult.HighTarget.Distribution{i}, 'FaceColor', CC.high, 'BarWidth',0.75, 'EdgeAlpha', 0);
    bar((1:50)+0.25, SimulationResult.LowTarget.Distribution{i}, 'FaceColor', CC.low, 'BarWidth',0.75, 'EdgeAlpha', 0);
    plot(ExperimentResult.HighTarget.Distribution{i}, 'Color', CC.high, 'LineWidth', 1);
    plot(ExperimentResult.LowTarget.Distribution{i}, 'Color', CC.low, 'LineWidth', 1);
    xlim([21,50]);
    ylim([0,0.4]);
    xticks([]);
    yticks([0]);
    yticklabels(num2str(100*(i-1)));
    set(ax2{i}, 'FontName', 'Times New Roman Bold', 'FontSize', 11);
    set(ax2{i}, 'FontSize',13);
end

yticks([0,0.4]);
yticklabels({'900', '1000'});


for i = 1 : 10
    ax2{i}.Position = [ax2{i}.Position(1)-0.07+(0.012*(i-1)), ax2{i}.Position(2)+0.01, ax2{i}.Position(3)+0.03, ax2{i}.Position(4)+0.03];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Figure 3b          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
value = 'V';
model = 'RW';
Anderson_et_al_PLOS1_2011_result = load(strcat('../result_nll/Anderson_et_al_PLOS1_2011/', value, '/Anderson_et_al_PLOS1_2011_', value, '_result.mat'));
X = Anderson_et_al_PLOS1_2011_result.output_result.(model).x;

[negativeloglikelihood, V, alpha, SimulationResult, ExperimentResult, Model_element_number] = computeNLL_AndersonPLOS1(X, schedule, model, num_repeat, ExperimentData, value);

% Plot
ax3 = subplot(4,10,21:25);
hold on;
[~,plot_1] = plot_shade(ax3, mean(V(:,1,:),3), std(V(:,1,:),0,3),'Color',CC.high,'LineWidth',2.3,'Shade',true);
[~,plot_2] = plot_shade(ax3, mean(V(:,2,:),3), std(V(:,2,:),0,3),'Color',CC.low,'LineWidth',2,'Shade',true);
%axis tight

% Axis
xticks(0:100:1000);
ylim([0,1]);
ylabel('V');

% Texts
t = title('RW-V');
t.Position(2) = 1.05;
t.FontSize = 13;
set(ax3, 'FontName', 'Times New Roman Bold');
set(ax3, 'FontSize', 13);
text(-50,160,'B', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');

% Extend?
ax3.Position = [ax3.Position(1)-0.07, ax3.Position(2), ax3.Position(3)+0.03, ax3.Position(4)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Figure 3c          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
value = 'V';
model = 'M';
Anderson_et_al_PLOS1_2011_result = load(strcat('../result_nll/Anderson_et_al_PLOS1_2011/', value, '/Anderson_et_al_PLOS1_2011_', value, '_result.mat'));
X = Anderson_et_al_PLOS1_2011_result.output_result.(model).x;

[negativeloglikelihood, V, alpha, SimulationResult, ExperimentResult, Model_element_number] = computeNLL_AndersonPLOS1(X, schedule, model, num_repeat, ExperimentData, value);

% Plot
ax4 = subplot(4,10,26:30);
hold on;
[~,plot_1] = plot_shade(ax4, mean(V(:,1,:),3), std(V(:,1,:),0,3),'Color',CC.high,'LineWidth',2.3,'Shade',true);
[~,plot_2] = plot_shade(ax4, mean(V(:,2,:),3), std(V(:,2,:),0,3),'Color',CC.low,'LineWidth',2,'Shade',true);
axis tight

% Axis
xticks(0:100:1000);
ylim([0,1]);
yl = ylabel('V');
yl.Position(1) = -60;

% Texts
t = title('M-V');
t.Position(2) = 1.05;
t.FontSize = 13;
set(ax4, 'FontName', 'Times New Roman Bold');
set(ax4, 'FontSize', 13);
text(-50,160,'C', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');

% Extend?
ax4.Position = [ax4.Position(1)+0.01, ax4.Position(2), ax4.Position(3)+0.03, ax4.Position(4)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Figure 3d          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
value = 'alpha';
model = 'EH';
Anderson_et_al_PLOS1_2011_result = load(strcat('../result_nll/Anderson_et_al_PLOS1_2011/', value, '/Anderson_et_al_PLOS1_2011_', value, '_result.mat'));
X = Anderson_et_al_PLOS1_2011_result.output_result.(model).x;

[negativeloglikelihood, V, alpha, SimulationResult, ExperimentResult, Model_element_number] = computeNLL_AndersonPLOS1(X, schedule, model, num_repeat, ExperimentData, value);

% Plot
ax5 = subplot(4,10,31:35);
hold on;
[~,plot_1] = plot_shade(ax5, mean(alpha(:,1,:),3), std(alpha(:,1,:),0,3),'Color',CC.high,'LineWidth',2.3,'Shade',true);
[~,plot_2] = plot_shade(ax5, mean(alpha(:,2,:),3), std(alpha(:,2,:),0,3),'Color',CC.low,'LineWidth',2,'Shade',true);
%axis tight

% Axis
xticks(0:100:1000);
yticks(0:2);
ylim([0,2]);
xlabel('Trials');
ylabel('alpha');

% Texts
t = title('EH-alpha');
t.Position(2) = 2.05;
t.FontSize = 13;
set(ax5, 'FontName', 'Times New Roman Bold');
set(ax5, 'FontSize', 13);
text(-50,160,'D', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');

% Extend?
ax5.Position = [ax5.Position(1)-0.07, ax5.Position(2), ax5.Position(3)+0.03, ax5.Position(4)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Figure 3e          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
value = 'alpha';
model = 'SPH';
Anderson_et_al_PLOS1_2011_result = load(strcat('../result_nll/Anderson_et_al_PLOS1_2011/', value, '/Anderson_et_al_PLOS1_2011_', value, '_result.mat'));
X = Anderson_et_al_PLOS1_2011_result.output_result.(model).x;

[negativeloglikelihood, V, alpha, SimulationResult, ExperimentResult, Model_element_number] = computeNLL_AndersonPLOS1(X, schedule, model, num_repeat, ExperimentData, value);

% Plot
ax6 = subplot(4,10,36:40);
hold on;
[~,plot_1] = plot_shade(ax6, mean(alpha(:,1,:),3), std(alpha(:,1,:),0,3),'Color',CC.high,'LineWidth',2.3,'Shade',true);
[~,plot_2] = plot_shade(ax6, mean(alpha(:,2,:),3), std(alpha(:,2,:),0,3),'Color',CC.low,'LineWidth',2,'Shade',true);
axis tight

% Axis
xticks(0:100:1000);
ylim([0,1]);
xlabel('Trials');
yl = ylabel('alpha');
yl.Position(1) = -60;

% Texts
t = title('SPH-alpha');
t.Position(2) = 1.05;
t.FontSize = 13;
set(ax6, 'FontName', 'Times New Roman Bold');
set(ax6, 'FontSize', 13);
text(-50,160,'E', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');

% Extend?
ax6.Position = [ax6.Position(1)+0.01, ax6.Position(2), ax6.Position(3)+0.03, ax6.Position(4)];

saveas(fig, 'Fig3.png');
