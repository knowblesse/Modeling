%% Figure3
% CogBioPsy Publication figures
% Copyed from KSBNS_HumanExp_Comparision
% 2021 Knowblesse
% 21JUL13

addpath('..');
addpath('../helper_function');

%% Color Constant
CC.cert = ones(1,3) * 0.0;
CC.unct = ones(1,3) * 0.6;

%% Parameters
app = getDefaultParameters();

% Mackintosh Model
app.paramM_lr_acq.Value = 0.1;
app.paramM_lr_ext.Value = 0.1;
app.paramM_k.Value = 0.2;

% Pearce-Hall Model
app.paramPH_SA.Value = 0.02;
app.paramPH_SB.Value = 0.02;
app.paramPH_SC.Value = 0.02;

% Esber Haselgrove Model
app.paramEH_lr1_acq.Value = 0.06;
app.paramEH_lr1_ext.Value = 0.01;

% Schmajuk-Pearson-Hall Model
app.paramSPH_SA.Value = 0.4;
app.paramSPH_SB.Value = 0.4;
app.paramSPH_SC.Value = 0.4;
app.paramSPH_beta_in.Value = 0.03;

%% Experiment Schedule from the (Choi & Choi, 2021)

schedule_exp1_uncertain = repmat([...
    1,0,0,1,1;...
    1,0,0,0,0;...
    1,0,0,0,0;...
    1,0,0,0,0;...
    ],25,1);
schedule_exp1_certain = repmat([...
    1,0,0,1,0.25;...
    ],100,1);

schedule_exp2_uncertain = repmat([...
    1,0,0,1,0.9;...
    1,0,0,1,0.75;...
    1,0,0,1,0.25;...
    1,0,0,1,0.1;...
    ],25,1);
schedule_exp2_certain = repmat([...
    1,0,0,1,0.5;...
    ],100,1);


model_names = {'RW', 'Mac', 'PH', 'EH', 'TD', 'SPH'};
num_repeat = 100;

%% Run
for model = [1,2,3,4,6]
    V = cell(1,4);
    alpha = cell(1,4);
    for r = 1 : num_repeat
        % Shuffle schedule for repeated simulation
        schedule_exp1_uncertain_shuffled = [shuffle1D(schedule_exp1_uncertain);repmat([1,0,0,0,0],100,1)];
        schedule_exp1_certain_shuffled = [shuffle1D(schedule_exp1_certain);repmat([1,0,0,0,0],100,1)];
        schedule_exp2_uncertain_shuffled = [shuffle1D(schedule_exp2_uncertain);repmat([1,0,0,0,0],100,1)];
        schedule_exp2_certain_shuffled = [shuffle1D(schedule_exp2_certain);repmat([1,0,0,0,0],100,1)];

        app1 = CCC_exported(schedule_exp1_uncertain_shuffled,model,[0.5, 0.5, 0.5], app);
        app2 = CCC_exported(schedule_exp1_certain_shuffled,model,[0.5, 0.5, 0.5], app);
        app3 = CCC_exported(schedule_exp2_uncertain_shuffled,model,[0.5, 0.5, 0.5], app);
        app4 = CCC_exported(schedule_exp2_certain_shuffled,model,[0.5, 0.5, 0.5], app);

        V{1}(:,r) = app1.V(:,1);
        V{2}(:,r) = app2.V(:,1);
        V{3}(:,r) = app3.V(:,1);
        V{4}(:,r) = app4.V(:,1);
        
        alpha{1}(:,r) = app1.alpha(:,1);
        alpha{2}(:,r) = app2.alpha(:,1);
        alpha{3}(:,r) = app3.alpha(:,1);
        alpha{4}(:,r) = app4.alpha(:,1);
    end
    fig = figure(2*model-1);
    clf(fig);
    hold on;
    [~,v_plot_1] = plot_shade(fig.Children, mean(V{1},2), std(V{1},0,2),'Color',CC.unct,'LineWidth',2,'Shade',true);
    [~,v_plot_2] = plot_shade(fig.Children, mean(V{2},2), std(V{2},0,2),'Color',CC.cert,'LineWidth',2,'Shade',true);
    title(strcat(model_names{model}, ' : Exp1'));
    xticks(0:50:200);
    xlabel('trial');
    ylabel('V');
    xlim([0,200]);
    ylim([0,0.7]);
    legend([v_plot_1{1}, v_plot_2{1}], {'exp1 uncertain','exp1 certain'});
    
    fig = figure(2*model);
    clf(fig);
    hold on;
    [~,v_plot_3] = plot_shade(fig.Children, mean(V{3},2), std(V{3},0,2),'Color',CC.unct,'LineWidth',2,'Shade',true);
    [~,v_plot_4] = plot_shade(fig.Children, mean(V{4},2), std(V{4},0,2),'Color',CC.cert,'LineWidth',2,'Shade',true);
    title(strcat(model_names{model}, ' : Exp2'));
    xticks(0:50:200);
    xlabel('trial');
    ylabel('V');
    xlim([0,200]);
    ylim([0,0.7]);
    legend([v_plot_3{1}, v_plot_4{1}], {'exp2 uncertain','exp2 certain'});
end   

%% Human Data Plot
exp1_block1 = [641, 603, 606];
exp1_block1_err = [7.164, 5.970, 3.880];
exp1_block2 = [605, 613, 595];
exp1_block2_err = [5.970, 5.397, 4.762];
exp2_block1 = [621, 604, 589];
exp2_block1_err = [6.4, 5.8, 5];
exp2_block2 = [581, 598,581];
exp2_block2_err = [5.8, 8, 5.2];

%% Final Figure
fig_exp1 = figure(13);
clf(fig_exp1);
fig_exp1.Position = [100,100, 560, 420];
b = bar([exp1_block1;exp1_block2],'EdgeColor','k', 'LineWidth', 2);
b(1).FaceColor = [0.6, 0.6, 0.6];
b(2).FaceColor = [0.0, 0.0, 0.0];
b(3).FaceColor = [1.0, 1.0, 1.0];
hold on;
errorbar([0.7778, 1, 1.2222], exp1_block1, exp1_block1_err, 'LineStyle', 'none', 'LineWidth', 1, 'Color', [0.4, 0.4, 0.4]);
errorbar([1.7778, 2, 2.2222], exp1_block2, exp1_block2_err, 'LineStyle', 'none', 'LineWidth', 1, 'Color', [0.4, 0.4, 0.4]);
ylim([560, 660]);
xticklabels({'Block 1', 'Block 2'});
ylabel('RT(ms)');
yticks(560:20:660);
title('Experiment 1');
legend({'Uncertain distractor', 'Certain distractor', 'No distractor'});

fig_exp2 = figure(14);
clf(fig_exp2);
fig_exp2.Position = [100,100, 560, 420];
b = bar([exp2_block1;exp2_block2],'EdgeColor','k', 'LineWidth', 2);
b(1).FaceColor = [0.6, 0.6, 0.6];
b(2).FaceColor = [0.0, 0.0, 0.0];
b(3).FaceColor = [1.0, 1.0, 1.0];
hold on;
errorbar([0.7778, 1, 1.2222], exp2_block1, exp2_block1_err, 'LineStyle', 'none', 'LineWidth', 1, 'Color', [0.4, 0.4, 0.4]);
errorbar([1.7778, 2, 2.2222], exp2_block2, exp2_block2_err, 'LineStyle', 'none', 'LineWidth', 1, 'Color', [0.4, 0.4, 0.4]);
ylim([560, 660]);
xticklabels({'Block 1', 'Block 2'});
ylabel('RT(ms)');
yticks(560:20:660);
title('Experiment 2');
legend({'Uncertain distractor', 'Certain distractor', 'No distractor'});
