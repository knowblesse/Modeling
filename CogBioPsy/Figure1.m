%% Figure1
% CogBioPsy Publication figures
% 2021 Knowblesse
% 21JUL12

addpath('..');
addpath('../helper_function');

%% Experiment Schedule

sch_CI = [...
    repmat([1,0,0,1,1],100,1);...
    repmat([1,1,0,0,0],100,1);...
    ];
sch_LI = [...
    repmat([1,0,0,0,0],100,1);...
    repmat([1,0,0,1,1],100,1);...
    ];
sch_LI_ctrl = repmat([1,0,0,1,1],100,1);
% 1 RW | 2 Mac | 3 PH | 4 EH | 5 TD | 6 SPH 

%% Conditioned Inhibition
app1_RW = CCC_exported(sch_CI,1,[0.5,0.5,0.5]);
app1_Mac = CCC_exported(sch_CI,2,[0.5,0.5,0.5]);

fig1 = figure(1);
clf(fig1);
set(fig1,'Position', [100,100,1500,400]);
subplot(1,2,1);
hold on;
plot(app1_RW.V(1:200,1), 'Color', ones(1,3) * 0.0, 'LineStyle', '-', 'LineWidth', 2);
plot(app1_RW.V(1:200,2), 'Color', ones(1,3) * 0.6, 'LineStyle', '-', 'LineWidth', 2);
xlabel('trial');
ylabel('V');
xlim([0,200]);
ylim([-0.5,1]);
xticks(0:50:200);
legend({'V_{CSA}', 'V_{CSB}'});
title('RW','FontSize', 16);

subplot(1,2,2);
hold on;
plot(app1_Mac.V(1:200,1), 'Color', ones(1,3) * 0.0, 'LineStyle', '-', 'LineWidth', 2);
plot(app1_Mac.V(1:200,2), 'Color', ones(1,3) * 0.6, 'LineStyle', '-', 'LineWidth', 2);
plot(app1_Mac.alpha(1:200,1), 'Color', ones(1,3) * 0.0, 'LineStyle', '--', 'LineWidth', 2);
plot(app1_Mac.alpha(1:200,2), 'Color', ones(1,3) * 0.6, 'LineStyle', '--', 'LineWidth', 2);
xlabel('trial');
ylabel('V');
xlim([0,200]);
ylim([-0.5,1]);
xticks(0:50:200);
legend({'V_{CSA}', 'V_{CSB}', '\alpha_{CSA}', '\alpha_{CSB}'},'Location','southeast');
title('Mac','FontSize',16);

%% Latent Inhibition
app = getDefaultParameters();
app.paramSPH_gamma.Value = 0.05; % to enlarge the discrepancy
app2_SPH = CCC_exported(sch_LI,6,[0.5,0.5,0.5],app);
app2_SPH_ctrl = CCC_exported(sch_LI_ctrl,6,[0.5,0.5,0.5],app);
app2_PH = CCC_exported(sch_LI,3,[0.5,0.5,0.5]); 
app2_PH_ctrl = CCC_exported(sch_LI_ctrl,3,[0.5,0.5,0.5]);

fig2 = figure(2);
clf(fig2);
set(fig2,'Position', [100,100,1500,400]);
subplot(1,2,1);
hold on;
plot(app2_SPH.V(1:200,1), 'Color', ones(1,3) * 0.0, 'LineStyle', '-', 'LineWidth', 2);
plot(101:200, app2_SPH_ctrl.V(1:100,1), 'Color', ones(1,3) * 0.6, 'LineStyle', '-', 'LineWidth', 2);
plot(app2_SPH.alpha(1:200,1), 'Color', ones(1,3) * 0.0, 'LineStyle', '--', 'LineWidth', 2); 
plot(101:200, app2_SPH_ctrl.alpha(1:100,1), 'Color', ones(1,3) * 0.6, 'LineStyle', '--', 'LineWidth', 2); 
xlabel('trial');
ylabel('V');
xlim([0,200]);
ylim([0,1]);
xticks(0:50:200);
legend({'V_{CSA}', 'V_{CSB}', '\alpha_{CSA}', '\alpha_{CSB}'},'Location','northwest');
title('SPH','FontSize', 16);

subplot(1,2,2);
hold on;
plot(app2_PH.V(1:200,1), 'Color', ones(1,3) * 0.0, 'LineStyle', '-', 'LineWidth', 2);
plot(101:200, app2_PH_ctrl.V(1:100,1), 'Color', ones(1,3) * 0.6, 'LineStyle', '-', 'LineWidth', 2);
plot(app2_PH.alpha(1:200,1), 'Color', ones(1,3) * 0.0, 'LineStyle', '--', 'LineWidth', 2); 
plot(101:200, app2_PH_ctrl.alpha(1:100,1), 'Color', ones(1,3) * 0.6, 'LineStyle', '--', 'LineWidth', 2); 
xlabel('trial');
ylabel('V');
xlim([0,200]);
ylim([0,1]);
xticks(0:50:200);
legend({'V_{CSA}', 'V_{CSB}', '\alpha_{CSA}', '\alpha_{CSB}'},'Location','northwest');
title('PH','FontSize', 16);

% inset figure
fig_inset = figure();
fig_inset.Position = [1165, 169, 258, 263];
clf;

hold on;
plot(-1:3, app2_PH.V(99:103,1), 'Color', ones(1,3) * 0.0, 'LineStyle', '-', 'LineWidth', 2);
plot(1:3, app2_PH_ctrl.V(1:3,1), 'Color', ones(1,3) * 0.6, 'LineStyle', '-', 'LineWidth', 2);
plot(-1:3, app2_PH.alpha(99:103,1), 'Color', ones(1,3) * 0.0, 'LineStyle', '--', 'LineWidth', 2); 
plot(1:3, app2_PH_ctrl.alpha(1:3,1), 'Color', ones(1,3) * 0.6, 'LineStyle', '--', 'LineWidth', 2); 
line([1,1],[0,1],'Color', ones(1,3) * 0.8, 'LineStyle', ':', 'LineWidth',2);
xticks(1);
xticklabels(101);
yticks([0,1]);
xlim([-1, 3]);

%% Second-order Condition
% A Start | A End | B Start | B End | C Start | C End | US Start | US End | ITI
app.paramTD_table.Data = table(...
    1,4,...
    1,4,...
    1,4,...
    7,8,...
    50);
app3_TD_ctrl = CCC_exported(sch_CI,5,[0.5,0.5,0.5],app);

app.paramTD_table.Data = table(...
    5,8,...
    1,4,...
    1,4,...
    11,12,...
    50);
app.paramTD_c.Value = 0.1;
app.paramTD_beta.Value = 0.8;
app.paramTD_gamma.Value = 0.95;
app3_TD = CCC_exported(sch_CI,5,[0.5,0.5,0.5],app);

fig3 = figure(3);
clf(fig3);
set(fig3,'Position', [100,100,1500,400]);

% TD Control graph
subplot(4,4,[1,2,5,6,9,10]);
hold on;
plot(app3_TD_ctrl.V(:,1), 'Color', ones(1,3) * 0.6, 'LineStyle', '-', 'LineWidth', 2);
plot(app3_TD_ctrl.V(:,2), 'Color', ones(1,3) * 0.0, 'LineStyle', '-', 'LineWidth', 2);
xlabel('trial');
ylabel('w');
xlim([0,200]);
ylim([-1,2]);
xticks(0:50:200);
legend({'V_{CSA}', 'V_{CSB}'});
title('TD control','FontSize', 16);

% TD Control Block 1 config
subplot(4,4,13);
hold on;

CSA = zeros(200,1);
US = zeros(200,1);
CSA(21:40) = 1;
US(61:70) = 1;

plot(CSA, 'Color', ones(1,3) * 0.6, 'LineStyle', '-', 'LineWidth', 2);
plot(US, 'Color', ones(1,3) * 0.6, 'LineStyle', ':', 'LineWidth', 2);
xticks([]);
yticks([]);
legend({'CSA', 'US'});
axis off;

% TD Control Block 2 config
subplot(4,4,14);
hold on;

CSA = zeros(200,1);
CSX = zeros(200,1);
CSX(61:80) = 1;
CSA(21:40) = 1;

plot(CSA, 'Color', ones(1,3) * 0.6, 'LineStyle', '-', 'LineWidth', 2);
plot(CSX, 'Color', ones(1,3) * 0.0, 'LineStyle', '-', 'LineWidth', 2);

xticks([]);
yticks([]);
legend({'CSA','CSB'});
axis off;

% TD graph
subplot(4,4,[3,4,7,8,11,12]);
hold on;
plot(app3_TD.V(:,1), 'Color', ones(1,3) * 0.6, 'LineStyle', '-', 'LineWidth', 2);
plot(app3_TD.V(:,2), 'Color', ones(1,3) * 0.0, 'LineStyle', '-', 'LineWidth', 2);
xlabel('trial');
ylabel('w');
xlim([0,200]);
ylim([-1,2]);
xticks(0:50:200);
legend({'V_{CSA}', 'V_{CSB}'});
title('TD','FontSize', 16);

% TD Block 1 config
subplot(4,4,15);
hold on;

CSA = zeros(200,1);
US = zeros(200,1);
CSA(21:40) = 1;
US(61:70) = 1;

plot(CSA, 'Color', ones(1,3) * 0.6, 'LineStyle', '-', 'LineWidth', 2);
plot(US, 'Color', ones(1,3) * 0.6, 'LineStyle', ':', 'LineWidth', 2);
xticks([]);
yticks([]);
legend({'CSA', 'US'});
axis off;

% TD Block 2 config
subplot(4,4,16);
hold on;

CSA = zeros(200,1);
CSX = zeros(200,1);
CSA(61:80) = 1;
CSX(21:40) = 1;

plot(CSA, 'Color', ones(1,3) * 0.6, 'LineStyle', '-', 'LineWidth', 2);
plot(CSX, 'Color', ones(1,3) * 0.0, 'LineStyle', '-', 'LineWidth', 2);

xticks([]);
yticks([]);
legend({'CSA','CSB'});
axis off;
