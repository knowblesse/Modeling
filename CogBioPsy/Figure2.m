%% Figure2
% CogBioPsy Publication figures
% Copyed from KSBNS_Partial_Reinforcement
% 2021 Knowblesse
% 21JUL13

addpath('..');
addpath('../helper_function');


%% Color Constant
CC.con_1 = ones(1,3) * 0.0;
CC.con_2 = ones(1,3) * 0.0;
CC.par_1 = ones(1,3) * 0.6;
CC.par_2 = ones(1,3) * 0.6;

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

lambda1 = 0.5;
lambda2 = 1;
acquisition = 100;
extinction = 100;

schedule_con_1 = [...
    repmat([1,0,0,1,lambda1], acquisition,1);
    repmat([1,0,0,0,lambda1], extinction,1)];
schedule_con_2 = [...
    repmat([1,0,0,1,lambda2], acquisition,1);
    repmat([1,0,0,0,lambda2], extinction,1)];
schedule_par_1 = [...
    repmat([...
        1,0,0,1,lambda1;...
        1,0,0,1,lambda1;...
        1,0,0,0,lambda1;...
        1,0,0,0,lambda1], acquisition/4,1);
    repmat([1,0,0,0,lambda1], extinction,1)];
    
schedule_par_2 = [...
    repmat([...
        1,0,0,1,lambda2;...
        1,0,0,1,lambda2;...
        1,0,0,0,lambda2;...
        1,0,0,0,lambda2], acquisition/4,1);
    repmat([1,0,0,0,lambda2], extinction,1)];
    
model_names = {'RW', 'Mac', 'PH', 'EH', 'TD', 'SPH'};

%% Run
for model = 1:6
    app1 = CCC_exported(schedule_con_1,model,[0.5,0.5,0.5],app);
    app2 = CCC_exported(schedule_con_2,model,[0.5,0.5,0.5],app);
    app3 = CCC_exported(schedule_par_1,model,[0.5,0.5,0.5],app);
    app4 = CCC_exported(schedule_par_2,model,[0.5,0.5,0.5],app);
    fig = figure(model);
    clf(fig);
    hold on;
    v_plot_1 = plot(app1.V(:,1),'Color',CC.con_1,'LineStyle','--','LineWidth',2);
    v_plot_2 = plot(app2.V(:,1),'Color',CC.con_2,'LineStyle','-','LineWidth',2);
    v_plot_3 = plot(app3.V(:,1),'Color',CC.par_1,'LineStyle','--','LineWidth',2);
    v_plot_4 = plot(app4.V(:,1),'Color',CC.par_2,'LineStyle','-','LineWidth',2);
    % a_plot_1 = plot(app1.alpha(:,1),'Color',CC.con_1,'LineStyle','--','LineWidth',2);
    % a_plot_2 = plot(app2.alpha(:,1),'Color',CC.con_2,'LineStyle','--','LineWidth',2);
    % a_plot_3 = plot(app3.alpha(:,1),'Color',CC.par_1,'LineStyle','--','LineWidth',2);
    % a_plot_4 = plot(app4.alpha(:,1),'Color',CC.par_2,'LineStyle','--','LineWidth',2);
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
    
    legend({'con_1','con_2','par_1','par_2'});
    saveas(fig,strcat(model_names{model},'_animal'),'png');
end   
    
    
    
