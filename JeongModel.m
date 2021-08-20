%% JeongModel
% Testing script for Jeong Model
% 2021 Knowblesse
% 21AUG18

addpath('helper_function');
%% Color Constant
CC.cert = '#9E2C6A';
CC.unct = '#C17FB5';

%% Experiment Schedule from the (Choi & Choi, 2021)
a = [50, 100, 150]./ 150;
pa = [0.2, 0.6, 0.2];
b = [60, 70, 100, 130, 140]./ 150;
pb = [0.2, 0.2, 0.2, 0.2, 0.2];

fprintf('E(X) : %f  ', sum(a .* pa))
fprintf('V(X) : %f  ', sum((a.^2) .* pa) - (sum(a .* pa))^2);
fprintf('H(X) : %f  \n', shannon(pa));

fprintf('E(X) : %f  ', sum(b .* pb))
fprintf('V(X) : %f  ', sum((b.^2) .* pb) - (sum(b .* pb))^2);
fprintf('H(X) : %f  \n', shannon(pb));

schedule_uncertain = repmat([...
    1,0,0,1,1;...
    1,0,0,0,0;...
    1,0,0,0,0;...
    1,0,0,0,0;...
    ],25,1);
schedule_certain = repmat([...
    1,0,0,1,0.25;...
    ],100,1);

schedule_lowH = repmat([...
    1,0,0,1,0.33;...
    1,0,0,1,0.67;...
    1,0,0,1,0.67;...
    1,0,0,1,0.67;...
    1,0,0,1,1],20,1);
schedule_highH = repmat([...
    1,0,0,1,0.4;...
    1,0,0,1,0.47;...
    1,0,0,1,0.67;...
    1,0,0,1,0.87;...
    1,0,0,1,0.93],20,1);

% schedule_uncertain = repmat([1,0,0,1,1],100,1);
% schedule_certain = repmat([1,0,0,1,1],100,1);
schedule_partial = repmat([...
    1,0,0,1,0.2;...
    1,0,0,1,0.4;...
    1,0,0,1,0.6;...
    1,0,0,1,0.8;],25,1);
num_repeat = 100;

%% Run
V = cell(1,2);
alpha = cell(1,2);
J = cell(1,2);
V_pos = cell(1,2);
V_bar = cell(1,2);
p = cell(1,2);
for r = 1 : num_repeat
    % Shuffle schedule for repeated simulation
    schedule_lowH_shuffled = [shuffle1D(schedule_lowH);repmat([1,0,0,0,0],50,1)];
    schedule_highH_shuffled = [shuffle1D(schedule_highH);repmat([1,0,0,0,0],50,1)];

    sim1 = JModel(schedule_lowH_shuffled);
    sim2 = JModel(schedule_highH_shuffled);

    V{1}(:,r) = sim1.V(:,1);
    V{2}(:,r) = sim2.V(:,1);

    alpha{1}(:,r) = sim1.alpha(:,1);
    alpha{2}(:,r) = sim2.alpha(:,1);

    J{1}(:,r) = sim1.J(:,1);
    J{2}(:,r) = sim2.J(:,1);

    p{1}(:,r) = sim1.p(:,1);
    p{2}(:,r) = sim2.p(:,1);
end

fig1 = figure(1);
clf;
hold on;

[~,V_plot_1] = plot_shade(fig1.Children, mean(V{1},2), std(V{1},0,2),'Color',CC.unct,'LineWidth',2,'Shade',true);
[~,alpha_plot_1] = plot_shade(fig1.Children, mean(alpha{1},2), std(alpha{1},0,2), 'Color',CC.unct,'LineWidth',2,'Shade',true,'LineStyle','--');
[~,J_plot_1] = plot_shade(fig1.Children, mean(J{1},2), std(J{1},0,2), 'Color','#75C9E2','LineWidth',1,'Shade',true);
[~,p_plot_1] = plot_shade(fig1.Children, mean(p{1},2), std(p{1},0,2),'Color','#E3364A','Shade',true);
xlabel('Trial');
ylabel('V');
xlim([0,150]);
ylim([0,1]);
legend([V_plot_1{1}, alpha_plot_1{1}, J_plot_1{1}, p_plot_1{1}],{'V', 'alpha', 'J', 'p'});

fig2 = figure(2);
clf;
hold on;

[~,V_plot_2] = plot_shade(fig2.Children, mean(V{2},2), std(V{2},0,2),'Color',CC.cert,'LineWidth',2,'Shade',true);
[~,alpha_plot_2] = plot_shade(fig2.Children, mean(alpha{2},2), std(alpha{2},0,2), 'Color',CC.cert,'LineWidth',2,'Shade',true,'LineStyle','--');
[~,J_plot_2] = plot_shade(fig2.Children, mean(J{2},2), std(J{2},0,2), 'Color','#75C9E2','LineWidth',1,'Shade',true);
[~,p_plot_2] = plot_shade(fig2.Children, mean(p{2},2), std(p{2},0,2),'Color','#E3364A','Shade',true);
xlabel('Trial');
ylabel('V');
xlim([0,150]);
ylim([0,1]);
legend([V_plot_2{1}, alpha_plot_2{1}, J_plot_2{1}, p_plot_2{1}],{'V', 'alpha', 'J', 'p'});

fig4 = figure(4);
clf;
hold on;
[~,V_plot_1] = plot_shade(fig4.Children, mean(V{1},2), std(V{1},0,2),'Color',CC.unct,'LineWidth',2,'Shade',true);
[~,V_plot_2] = plot_shade(fig4.Children, mean(V{2},2), std(V{2},0,2),'Color',CC.cert,'LineWidth',2,'Shade',true);

fig3 = figure(3);
clf;
hold on;

sim3 = JModel(schedule_partial);
plot(sim3.V(:,1), 'Color', 'k','LineWidth', 2);
plot(sim3.alpha(:,1), 'Color', 'k', 'LineStyle','--');
plot(sim3.p(:,1), 'Color', 'r');
plot(sim3.J(:,1), 'Color', 'g');





