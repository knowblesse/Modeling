%% Figure2
% CogBioPsy Publication figures
% Copyed from KSBNS_Partial_Reinforcement
% 2021 Knowblesse
% 21JUL13

addpath('..');
addpath('../helper_function');


%% Color Constant
CC.con = ones(1,3) * 0.0;
CC.par = ones(1,3) * 0.6;

%% Parameters
app.alpha_A.Value = 0.5;
app.alpha_B.Value = 0.5;
app.alpha_C.Value = 0.5;

% Rescorla-Wager Model
app.paramRW_lr_acq.Value = 0.1;%
app.paramRW_lr_ext.Value = 0.05;%

% Mackintosh Model
app.paramM_lr_acq.Value = 0.1;
app.paramM_lr_ext.Value = 0.05;
app.paramM_k.Value = 0.1;
app.paramM_epsilon.Value = 0.02;

% Pearce-Hall Model
app.paramPH_SA.Value = 0.02;
app.paramPH_SB.Value = 0.02;
app.paramPH_SC.Value = 0.02;

% Esber Haselgrove Model
app.paramEH_lr1_acq.Value = 0.07; % lr1 : when delta V >= 0 
app.paramEH_lr2_acq.Value = 0.02; % Phi(2 acq lr) must be larger than Phi(2 ext lr)
app.paramEH_lr1_ext.Value = 0.05;
app.paramEH_lr2_ext.Value = 0.03;
app.paramEH_k.Value = 0.2;
app.paramEH_lr_pre.Value = 0.02;
app.paramEH_limitV.Value = false;

% Schmajuk-Pearson-Hall Model
app.paramSPH_SA.Value = 0.3;
app.paramSPH_SB.Value = 0.3;
app.paramSPH_SC.Value = 0.3;
app.paramSPH_beta_ex.Value = 0.01;
app.paramSPH_beta_in.Value = 0.005;
app.paramSPH_gamma.Value = 0.01;

% TD Model
app.paramTD_table.Data = table(1,4,1,4,1,4,9,10,50);
app.paramTD_c.Value = 0.1;
app.paramTD_beta.Value = 0.8;
app.paramTD_gamma.Value = 0.95;

%% Experiment Schedule from the (Haselgrove et al. 2004)
acquisition = 100;
extinction = 100;

schedule_con = [... % one pellet per reinforcement
    repmat([1,0,0,1,0.5], 100, 1);
    repmat([1,0,0,0,0.5], 100, 1)];
schedule_par = [... % two pellets per reinforcement
    repmat([...
        1,0,0,1,1.0;...
        1,0,0,1,1.0;...
        1,0,0,0,1.0;...
        1,0,0,0,1.0], 25,1);
    repmat([1,0,0,0,1.0], 100,1)];
    
model_names = {'RW', 'Mac', 'PH', 'EH', 'TD', 'SPH'};

%% Run
for model = 1:6
    app1 = CCC_exported(schedule_con,model,[0.5,0.5,0.5],app);
    app2 = CCC_exported(schedule_par,model,[0.5,0.5,0.5],app);
    fig = figure(model);
    clf(fig);
    hold on;
    v_plot_1 = plot(app1.V(:,1),'Color',CC.con,'LineStyle','-','LineWidth',2);
    v_plot_2 = plot(app2.V(:,1),'Color',CC.par,'LineStyle','-','LineWidth',2);
    % a_plot_1 = plot(app1.alpha(:,1),'Color',CC.con,'LineStyle','--','LineWidth',2);
    % a_plot_2 = plot(app2.alpha(:,1),'Color',CC.par,'LineStyle','--','LineWidth',2);
    title(model_names{model});
    xlabel('Trial');
    ylabel('V');
    xlim([0,acquisition + extinction]);
    ylim([0,1]);
    if model == 5
        ylabel('w');
        a_plot_1.Visible = false;
        a_plot_2.Visible = false;
    end 
    
    legend({'continuous','partial'});
    saveas(fig,strcat(model_names{model},'_animal'),'png');
end   
    
%% Animal Data Figure    
load animal_data.mat

fig_animal = figure(7);
fig_animal.Position = [0,0,1056,379];
clf(fig_animal);
subplot(1,4,1:2);
hold on;
plot(1:12, animal_data(1:12, 1), 'Color', CC.con, 'LineWidth', 2);
plot(1:12, animal_data(1:12, 2), 'Color', CC.par, 'LineWidth', 2);
title('Acqusition');
xlabel('Session');
ylabel('Mean difference score (magazine activity)');
xticks(1:12);
xlim([0,13]);
ylim([-1,8]);

subplot(1,4,3:4);
hold on;
plot(1:9, animal_data(13:21,1), 'Color', CC.con, 'LineWidth', 2);
plot(1:9, animal_data(13:21,2), 'Color', CC.par, 'LineWidth', 2);
plot(10:18, animal_data(22:30,1), 'Color', CC.con, 'LineWidth', 2);
plot(10:18, animal_data(22:30,2), 'Color', CC.par, 'LineWidth', 2);
title('Extinction');
xlabel('Trial (2 blocks)');
xticks(1:18);
xticklabels([1:9,1:9]);
xlim([0,19]);
ylim([-1,8]);
