%% Anderson_VDAC_2011
% Anderson et al (2011) simulation
% Only the first experiment is simulated. 
% 2021 Knowblesse
% 21OCT12
rng('shuffle');
addpath('..');
addpath('../helper_function');

exp1_high_reward = 1; %5 cents
exp1_low_reward = 0.2; %1 cents

%% Experiment Schedule
schedule_training = [...
    repmat([1,0,0,1,exp1_high_reward],4,1);...
    repmat([1,0,0,1,exp1_low_reward],1,1);...
    repmat([0,1,0,1,exp1_high_reward],1,1);...
    repmat([0,1,0,1,exp1_low_reward],4,1);...
    ]; % total 1008 trials. => x101 to make 1010 trials
schedule_testing = [...
    [1,0,0,0,0];
    [0,1,0,0,0];
    ]; % total 480 trials. => x240 to make exact 480 trials

%% Color Constant
CC.high = [1,0.3,0.3];
CC.low = [0.3,1,0.3];

%% Parameters
app = getDefaultParameters();
app.paramEH_lr1_acq.Value = 0.048; % lr1 : when delta V >= 0 
app.paramEH_lr2_acq.Value = 0.02; % product of two acq lr > product of two ext lr
app.paramEH_lr1_ext.Value = 0.041;
app.paramEH_lr2_ext.Value = 0.02;

app.paramM_lr_acq.Value = 0.08;
app.paramM_lr_ext.Value = 0.04;
app.paramM_k.Value = 0.015;
app.paramM_epsilon.Value = 0.02;

app.paramSPH_SA.Value = 0.3;
app.paramSPH_SB.Value = 0.3;
app.paramSPH_SC.Value = 0.3;
app.paramSPH_beta_ex.Value = 0.1;
app.paramSPH_beta_in.Value = 0.09;
app.paramSPH_gamma.Value = 0.1;


model_names = {'RW', 'Mac', 'PH', 'EH', 'TD', 'SPH', 'Jeong'};
num_repeat = 100;
%% Run
idx = 1;
V = cell(1,4);
alpha = cell(1,4);
for model = [1,2,4,6]
    for r = 1 : num_repeat
        % Shuffle schedule for repeated simulation
        schedule_shuffled = [shuffle1D(repmat(schedule_training,101,1)); shuffle1D(repmat(schedule_testing,240,1))];

        app1 = CCC_exported(schedule_shuffled,model,[0.5, 0.5, 0.5], app);

        V{1,idx}(:,:,r) = app1.V;
        
        alpha{1,idx}(:,:,r) = app1.alpha;
    end
    
    % Draw
    fig = figure(2*idx -1);
    clf(fig);
    set(fig,'Position',[500,500,1200,400]);
    ax1 = subplot(1,2,1);
    hold on;
    [~,v_plot_1] = plot_shade(ax1, mean(V{1,idx}(1:end-1,1,:),3), std(V{1,idx}(1:end-1,1,:),0,3),'Color',CC.high,'LineWidth',2.3,'Shade',true);
    [~,v_plot_2] = plot_shade(ax1, mean(V{1,idx}(1:end-1,2,:),3), std(V{1,idx}(1:end-1,2,:),0,3),'Color',CC.low,'LineWidth',2,'Shade',true);

    title(strcat(model_names{model}, ' : Exp1'));
    xticks(0:100:1490);
    xlabel('trial');
    ylabel('V');
    xlim([0,1490]);
    ylim([0,1.5]);
    legend([v_plot_1{1}, v_plot_2{1}], {'high reward', 'low reward'});

    ax2 = subplot(1,2,2);
    hold on;
    [~,a_plot_1] = plot_shade(ax2, mean(alpha{1,idx}(1:end-1,1,:),3), std(alpha{1,idx}(1:end-1,1,:),0,3),'Color',CC.high,'LineWidth',2.3,'Shade',true, 'LineStyle','--');
    [~,a_plot_2] = plot_shade(ax2, mean(alpha{1,idx}(1:end-1,2,:),3), std(alpha{1,idx}(1:end-1,2,:),0,3),'Color',CC.low,'LineWidth',2,'Shade',true, 'LineStyle','--');

    title(strcat(model_names{model}, ' : Exp1'));
    xticks(0:100:1490);
    xlabel('trial');
    ylabel('alpha');
    xlim([0,1490]);
    ylim([0,1]);
    legend([a_plot_1{1}, a_plot_2{1}], {'high reward', 'low reward'});

    idx = idx + 1;
    saveas(fig,strcat(model_names{model},'_Exp1.png'),'png');
end
