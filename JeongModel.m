%% JeongModel
% Testing script for Jeong Model
% 2021 Knowblesse
% 21AUG18

%% Color Constant
CC.cert = '#9E2C6A';
CC.unct = '#C17FB5';


%% Experiment Schedule from the (Choi & Choi, 2021)

schedule_uncertain = repmat([...
    1,0,0,1,1;...
    1,0,0,0,0;...
    1,0,0,0,0;...
    1,0,0,0,0;...
    ],25,1);
schedule_certain = repmat([...
    1,0,0,1,0.25;...
    ],100,1);

% schedule_uncertain = repmat([1,0,0,1,1],100,1);
% schedule_certain = repmat([1,0,0,1,1],100,1);

num_repeat = 100;

%% Run
V = cell(1,2);
alpha = cell(1,2);
J = cell(1,2);
V_pos = cell(1,2);
V_bar = cell(1,2);

for r = 1 : num_repeat
    % Shuffle schedule for repeated simulation
    schedule_uncertain_shuffled = [shuffle1D(schedule_uncertain);repmat([1,0,0,0,0],50,1)];
    schedule_certain_shuffled = [shuffle1D(schedule_certain);repmat([1,0,0,0,0],50,1)];

    sim1 = JModel(schedule_uncertain_shuffled);
    sim2 = JModel(schedule_certain_shuffled);

    V{1}(:,r) = sim1.V(:,1);
    V{2}(:,r) = sim2.V(:,1);

    alpha{1}(:,r) = sim1.alpha(:,1);
    alpha{2}(:,r) = sim2.alpha(:,1);

    J{1}(:,r) = sim1.J(:,1);
    J{2}(:,r) = sim2.J(:,1);

    V_pos{1}(:,r) = sim1.V_pos(:,1);
    V_pos{2}(:,r) = sim2.V_pos(:,1);

    V_bar{1}(:,r) = sim1.V_bar(:,1);
    V_bar{2}(:,r) = sim2.V_bar(:,1);
end

fig1 = figure(1);
clf;
hold on;

fig2 = figure(2);
clf;
hold on;

[~,V_plot_1] = plot_shade(fig1.Children, mean(V{1},2), std(V{1},0,2),'Color',CC.unct,'LineWidth',2,'Shade',true);
[~,alpha_plot_1] = plot_shade(fig1.Children, mean(alpha{1},2), std(alpha{1},0,2), 'Color',CC.unct,'LineWidth',2,'Shade',true,'LineStyle','--');
[~,J_plot_1] = plot_shade(fig1.Children, mean(J{1},2), std(J{1},0,2), 'Color','#75C9E2','LineWidth',1,'Shade',true);
[~,V_pos_plot_1] = plot_shade(fig1.Children, mean(V_pos{1},2), std(V_pos{1},0,2),'Color','#E3364A','Shade',true);
[~,V_bar_plot_1] = plot_shade(fig1.Children, mean(V_bar{1},2), std(V_bar{1},0,2),'Color','#61B0E2','Shade',true);
xlabel('Trial');
ylabel('V');
xlim([0,150]);
ylim([0,1]);
legend([V_plot_1{1}, alpha_plot_1{1}, J_plot_1{1}, V_pos_plot_1{1}, V_bar_plot_1{1}],{'V', 'alpha', 'J', 'V_{pos}', 'V_{bar}'});


[~,V_plot_2] = plot_shade(fig2.Children, mean(V{2},2), std(V{2},0,2),'Color',CC.unct,'LineWidth',2,'Shade',true);
[~,alpha_plot_2] = plot_shade(fig2.Children, mean(alpha{2},2), std(alpha{2},0,2), 'Color',CC.unct,'LineWidth',2,'Shade',true,'LineStyle','--');
[~,J_plot_2] = plot_shade(fig2.Children, mean(J{2},2), std(J{2},0,2), 'Color','#75C9E2','LineWidth',1,'Shade',true);
[~,V_pos_plot_2] = plot_shade(fig2.Children, mean(V_pos{2},2), std(V_pos{2},0,2),'Color','#E3364A','Shade',true);
[~,V_bar_plot_2] = plot_shade(fig2.Children, mean(V_bar{2},2), std(V_bar{2},0,2),'Color','#61B0E2','Shade',true);
xlabel('Trial');
ylabel('V');
xlim([0,150]);
ylim([0,1]);
legend([V_plot_2{1}, alpha_plot_2{1}, J_plot_2{1}, V_pos_plot_2{1}, V_bar_plot_2{1}],{'V', 'alpha', 'J', 'V_{pos}', 'V_{bar}'});
