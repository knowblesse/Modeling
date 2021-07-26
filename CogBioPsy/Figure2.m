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
% only the EH model's variable is changed
app = getDefaultParameters();
app.paramEH_lr1_acq.Value = 0.07; % lr1 : when delta V >= 0 
app.paramEH_lr2_acq.Value = 0.03; % product of two acq lr > product of two ext lr
app.paramEH_lr1_ext.Value = 0.05;
app.paramEH_lr2_ext.Value = 0.01;

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
    fig.Position = [1000,74, 560, 420];
    hold on;
    v_plot_1 = plot(app1.V(:,1),'Color',CC.con,'LineStyle','-','LineWidth',2);
    v_plot_2 = plot(app2.V(:,1),'Color',CC.par,'LineStyle','-','LineWidth',2);
    % a_plot_1 = plot(app1.alpha(:,1),'Color',CC.con,'LineStyle','--','LineWidth',2);
    % a_plot_2 = plot(app2.alpha(:,1),'Color',CC.par,'LineStyle','--','LineWidth',2);
    title(model_names{model});
    xlabel('trial');
    ylabel('V');
    xlim([0,acquisition + extinction]);
    ylim([0,1]);
    legend({'continuous','partial'});
    fprintf('%jjs : con: %.2f par: %.2f\n', model_names{model}, app1.V(200,1), app2.V(200,1));
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
xlabel('session');
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
xlabel('trial (2 blocks)');
xticks(1:18);
xticklabels([1:9,1:9]);
xlim([0,19]);
ylim([-1,8]);
legend({'continuous','partial'});

%% Model Figure
fig_model = figure(8);
fig_model.Position = [0,0,1056,379];
clf(fig_model);
for model = [1,2] % RW, Mac
    subplot(1,2,model);
    app1 = CCC_exported(schedule_con,model,[0.5,0.5,0.5],app);
    app2 = CCC_exported(schedule_par,model,[0.5,0.5,0.5],app);
    hold on;
    v_plot_1 = plot(app1.V(:,1),'Color',CC.con,'LineStyle','-','LineWidth',2);
    v_plot_2 = plot(app2.V(:,1),'Color',CC.par,'LineStyle','-','LineWidth',2);
    title(model_names{model});
    xlabel('trial');
    ylabel('V');
    xlim([0,acquisition + extinction]);
    ylim([0,1]);
    legend({'continuous','partial'});
end