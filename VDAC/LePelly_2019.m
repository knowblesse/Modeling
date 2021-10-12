%% Le Pelley 2019
% Le Pelley et al (2019) simulation
% 2021 Knowblesse
% 21OCT11
rng('shuffle');
addpath('..');
addpath('../helper_function');

exp1_high_reward = 1; %500 points
exp1_low_reward = 0.1; %10 points

exp2_high_reward = 1; %100 points
exp2_medium_reward = 0.5; %50 points

%% Experiment Schedule
schedule_exp1 = [...
    repmat([1,0,0,1,exp1_high_reward],12,1);...
    repmat([0,1,0,1,exp1_low_reward],12,1);...
    repmat([0,0,1,1,exp1_high_reward],6,1);...
    repmat([0,0,1,1,exp1_low_reward],6,1);...
    ];

schedule_exp2 = [...
    repmat([1,0,0,1,exp2_medium_reward],18,1);...
    repmat([0,1,0,1,exp2_high_reward],9,1);...
    repmat([0,1,0,0,0],9,1);...
    ];

%% Color Constant
CC.P = ones(1,3) * 0.0;
CC.NP = ones(1,3) * 0.6;
CC.high = [1,0.3,0.3];
CC.low = [0.3,1,0.3];

%% Parameters
app = getDefaultParameters();
app.paramEH_lr1_acq.Value = 0.06; % lr1 : when delta V >= 0 
app.paramEH_lr2_acq.Value = 0.04; % product of two acq lr > product of two ext lr
app.paramEH_lr1_ext.Value = 0.04;
app.paramEH_lr2_ext.Value = 0.01;


model_names = {'RW', 'Mac', 'PH', 'EH', 'TD', 'SPH', 'Jeong'};
num_repeat = 100;
%% Run
idx = 1;
V = cell(1,4);
alpha = cell(1,4);
for model = [1,2,4,6]
    for r = 1 : num_repeat
        % Shuffle schedule for repeated simulation
        schedule_exp1_shuffled = shuffle1D(repmat(schedule_exp1,5,1));

        app1 = CCC_exported(schedule_exp1_shuffled,model,[0.5, 0.5, 0.5], app);

        V{1,idx}(:,:,r) = app1.V;
        
        alpha{1,idx}(:,:,r) = app1.alpha;
    end
    
    % Draw
    fig = figure(2*idx -1);
    clf(fig);
    set(fig,'Position',[500,500,1200,400]);
    ax1 = subplot(1,2,1);
    hold on;
    [~,v_plot_1] = plot_shade(ax1, mean(V{1,idx}(:,1,:),3), std(V{1,idx}(:,1,:),0,3),'Color',CC.high,'LineWidth',2.3,'Shade',true);
    [~,v_plot_2] = plot_shade(ax1, mean(V{1,idx}(:,2,:),3), std(V{1,idx}(:,2,:),0,3),'Color',CC.low,'LineWidth',2,'Shade',true);
    [~,v_plot_3] = plot_shade(ax1, mean(V{1,idx}(:,3,:),3), std(V{1,idx}(:,3,:),0,3),'Color',CC.NP,'LineWidth',1.7,'Shade',true);

    title(strcat(model_names{model}, ' : Exp1'));
    xticks(0:20:180);
    xlabel('trial');
    ylabel('V');
    xlim([0,180]);
    ylim([0,1.5]);
    legend([v_plot_1{1}, v_plot_2{1}, v_plot_3{1}], {'high reward', 'low reward', 'NP'});

    ax2 = subplot(1,2,2);
    hold on;
    [~,a_plot_1] = plot_shade(ax2, mean(alpha{1,idx}(:,1,:),3), std(alpha{1,idx}(:,1,:),0,3),'Color',CC.high,'LineWidth',2.3,'Shade',true, 'LineStyle','--');
    [~,a_plot_2] = plot_shade(ax2, mean(alpha{1,idx}(:,2,:),3), std(alpha{1,idx}(:,2,:),0,3),'Color',CC.low,'LineWidth',2,'Shade',true, 'LineStyle','--');
    [~,a_plot_3] = plot_shade(ax2, mean(alpha{1,idx}(:,3,:),3), std(alpha{1,idx}(:,3,:),0,3),'Color',CC.NP,'LineWidth',1.7,'Shade',true, 'LineStyle','--');

    title(strcat(model_names{model}, ' : Exp1'));
    xticks(0:20:180);
    xlabel('trial');
    ylabel('alpha');
    xlim([0,180]);
    ylim([0,1]);
    legend([a_plot_1{1}, a_plot_2{1}, a_plot_3{1}], {'high reward', 'low reward', 'NP'});

    idx = idx + 1;
    saveas(fig,strcat(model_names{model},'_Exp1.png'),'png');
end

%% Experiment 2
model_names = {'RW', 'Mac', 'PH', 'EH', 'TD', 'SPH', 'Jeong'};
num_repeat = 100;
%% Run
idx = 1;
V = cell(1,4);
alpha = cell(1,4);
for model = [1,2,4,6]
    for r = 1 : num_repeat
        % Shuffle schedule for repeated simulation
        schedule_exp2_shuffled = shuffle1D(repmat(schedule_exp2,5,1));

        app1 = CCC_exported(schedule_exp2_shuffled,model,[0.5, 0.5, 0.5], app);

        V{1,idx}(:,:,r) = app1.V;
        
        alpha{1,idx}(:,:,r) = app1.alpha;
    end
    
    % Draw
    fig = figure(2*idx -1);
    clf(fig);
    set(fig,'Position',[500,500,1200,400]);
    ax1 = subplot(1,2,1);
    hold on;
    [~,v_plot_1] = plot_shade(ax1, mean(V{1,idx}(:,1,:),3), std(V{1,idx}(:,1,:),0,3),'Color',CC.P,'LineWidth',2.3,'Shade',true);
    [~,v_plot_2] = plot_shade(ax1, mean(V{1,idx}(:,2,:),3), std(V{1,idx}(:,2,:),0,3),'Color',CC.NP,'LineWidth',2,'Shade',true);

    title(strcat(model_names{model}, ' : Exp2'));
    xticks(0:20:180);
    xlabel('trial');
    ylabel('V');
    xlim([0,180]);
    ylim([0,1.5]);
    legend([v_plot_1{1}, v_plot_2{1}], {'P', 'NP'});

    ax2 = subplot(1,2,2);
    hold on;
    [~,a_plot_1] = plot_shade(ax2, mean(alpha{1,idx}(:,1,:),3), std(alpha{1,idx}(:,1,:),0,3),'Color',CC.P,'LineWidth',2.3,'Shade',true, 'LineStyle','--');
    [~,a_plot_2] = plot_shade(ax2, mean(alpha{1,idx}(:,2,:),3), std(alpha{1,idx}(:,2,:),0,3),'Color',CC.NP,'LineWidth',2,'Shade',true, 'LineStyle','--');

    title(strcat(model_names{model}, ' : Exp2'));
    xticks(0:20:180);
    xlabel('trial');
    ylabel('alpha');
    xlim([0,180]);
    ylim([0,1]);
    legend([a_plot_1{1}, a_plot_2{1}], {'P', 'NP'});

    idx = idx + 1;
    saveas(fig,strcat(model_names{model},'_Exp2.png'),'png');
end