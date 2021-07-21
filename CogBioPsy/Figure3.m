%% Figure3
% CogBioPsy Publication figures
% Copyed from KSBNS_HumanExp_Comparision
% 2021 Knowblesse
% 21JUL13

addpath('..');
addpath('../helper_function');

%% Color Constant
CC.exp1_cert = ones(1,3) * 0.0;
CC.exp1_unct = ones(1,3) * 0.0;
CC.exp2_cert = ones(1,3) * 0.6;
CC.exp2_unct = ones(1,3) * 0.6;

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
app.paramEH_lr1_ext.Value = 0.03;
app.paramEH_lr2_ext.Value = 0.015;
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
for model = [4]
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
    fig = figure(model);
    clf(fig);
    hold on;
    [~,v_plot_1] = plot_shade(fig.Children, mean(V{1},2), std(V{1},0,2),'Color',CC.exp1_unct,'LineWidth',2,'Shade',true, 'LineStyle', '--');
    [~,v_plot_2] = plot_shade(fig.Children, mean(V{2},2), std(V{2},0,2),'Color',CC.exp1_cert,'LineWidth',2,'Shade',true);
    [~,v_plot_3] = plot_shade(fig.Children, mean(V{3},2), std(V{3},0,2),'Color',CC.exp2_unct,'LineWidth',2,'Shade',true, 'LineStyle', '--');
    [~,v_plot_4] = plot_shade(fig.Children, mean(V{4},2), std(V{4},0,2),'Color',CC.exp2_cert,'LineWidth',2,'Shade',true);
    title(model_names{model});
    xticks(0:50:200);
    xlabel('trials');
    ylabel('V');
    xlim([0,200]);
    ylim([0,0.7]);
    legend([v_plot_1{1}, v_plot_2{1}, v_plot_3{1}, v_plot_4{1}],{'exp1 uncertain','exp1 certain','exp2 uncertain','exp2 certain'});
end   
