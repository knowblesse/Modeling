%% Fig10
% Draw figure 10
% LatentInhibition

%% Parameters
rng(0);
addpath('../../helper_function');

%% Experiment Schedule
% +--------+--------+--------+--------+---------------------------+
% | CS1    | CS2    | CS3    | US     | US intensity(reward size) |
% +--------+--------+--------+--------+---------------------------+
% | 1 or 0 | 1 or 0 | 1 or 0 | 1 or 0 | float                     |
% +--------+--------+--------+--------+---------------------------+
% There are three stimulus types and two phases in the hypothetical experiment.
% Phase 1 : A-      C+(0.5)
% Phase 2 : A+(0.5) B+(0.5)
% The simplest design for the latent inhibition is A- -> A+ & B+, and the expected result is 
% higher value to the B compared to the A. 
% However, I included an other stimulus, C, in the first phase to eliminate a criticism, that 
% the no-rewarding phase directly effect the behavior performance. 
% In this new design, the expected result is C == B > A.

high_reward = 1; 
low_reward = 0.5;
no_reward = 0;

schedule = struct();
schedule.schedule{1} = repmat([...
    [1,0,0,0,no_reward];...
    [0,0,1,1,low_reward];...
    ],200,1); % 2 trials x 200 blocks
schedule.schedule{2} = repmat([...
    [1,0,0,1,low_reward];...
    [0,1,0,1,low_reward];
    ],200,1); % 2 trials x 200 blocks
schedule.N = 800;

%% parameters
num_repeat = 200;
CC.old = [0.3608,0.6510,0.7137]; % CS1 which was presented from the beginning
CC.new = [0.8902,0.3176,0.3569]; % CS2 which was presented from the second phase
CC.high = [0.5, 0.5, 0.5]; % CS 3 which was paired with lambda = 0.5

%% Load Parameters
[param, opt_option] = getDefaultParam();
param.M.lr_acq.value = 0.08;
param.M.lr_ext.value = 0.04;
param.M.k.value = 0.06;
param.M.epsilon.value = 0.03;
param.SPH.S.value = 0.1;
param.SPH.beta_ex.value = 0.2;
param.SPH.beta_in.value = 0.1;
param.SPH.gamma.value = 0.03;

numBinModel = 50; % number of bins to divide the v or alpha

%% Make Figure
fig = figure(8);
clf(fig);
fig.Position = [-1572,229,1265,671];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%           Figure 8a,c         %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

model = 'M';

V = zeros(schedule.N,3,num_repeat);
alpha = zeros(schedule.N,3,num_repeat);

for r = 1 : num_repeat
    % Shuffle schedule for repeated simulation
    schedule_shuffled = [
        shuffle1D(schedule.schedule{1});...
        shuffle1D(schedule.schedule{2});...
        ];

    [outV, outAlpha] = SimulateModel(schedule_shuffled, model, param);

    V(:,:,r) = outV; % [trial, cs type, repeat]
    alpha(:,:,r) = outAlpha;
end

ax1 = subplot(2,2,1);
[~,plot_1] = plot_shade(ax1, mean(V(:,1,:),3), std(V(:,1,:),0,3),'Color',CC.old,'LineWidth',2.3,'Shade',true);
[~,plot_2] = plot_shade(ax1, mean(V(:,2,:),3), std(V(:,2,:),0,3),'Color',CC.new,'LineWidth',2,'Shade',true, 'x', 401:800);
[~,plot_3] = plot_shade(ax1, mean(V(:,3,:),3), std(V(:,3,:),0,3),'Color',CC.high,'LineWidth',1.7,'Shade',true, 'LineStyle', '--','x', 1:400);
xticks(100:100:800);
yticks(0:0.2:1);
ylim([0,1]);
xlabel('Trials');
ylabel('V');

% Texts
t = title('M-V');
t.Position(2) = 1.05; % slightly move up
t.FontSize = 13;
set(ax1, 'FontName', 'Times New Roman Bold');
set(ax1, 'FontSize', 13);
text(-50,250,'A', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');

% Extend
ax1.Position = [ax1.Position(1)-0.07, ax1.Position(2), ax1.Position(3)+0.10, ax1.Position(4)];

ax3 = subplot(2,2,3);
[~,plot_1] = plot_shade(ax3, mean(alpha(:,1,:),3), std(alpha(:,1,:),0,3),'Color',CC.old,'LineWidth',2.3,'Shade',true);
[~,plot_2] = plot_shade(ax3, mean(alpha(:,2,:),3), std(alpha(:,2,:),0,3),'Color',CC.new,'LineWidth',2,'Shade',true, 'x', 401:800);
[~,plot_3] = plot_shade(ax3, mean(alpha(:,3,:),3), std(alpha(:,3,:),0,3),'Color',CC.high,'LineWidth',1.7,'Shade',true, 'LineStyle', '--', 'x', 1:400);
xticks(100:100:800);
yticks(0:0.2:1);
ylim([0,1]);
xlabel('Trials');
ylabel('alpha');

    
% Texts
t = title('M-alpha');
t.Position(2) = 1.05; % slightly move up
t.FontSize = 13;
set(ax3, 'FontName', 'Times New Roman Bold');
set(ax3, 'FontSize', 13);
text(-50,250,'C', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');

% Extend
ax3.Position = [ax3.Position(1)-0.07, ax3.Position(2), ax3.Position(3)+0.10, ax3.Position(4)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%           Figure 8b,d         %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

model = 'SPH';

V = zeros(schedule.N,3,num_repeat);
alpha = zeros(schedule.N,3,num_repeat);

for r = 1 : num_repeat
    % Shuffle schedule for repeated simulation
    schedule_shuffled = [
        shuffle1D(schedule.schedule{1});...
        shuffle1D(schedule.schedule{2});...
        ];

    [outV, outAlpha] = SimulateModel(schedule_shuffled, model, param);

    V(:,:,r) = outV; % [trial, cs type, repeat]
    alpha(:,:,r) = outAlpha;
end

ax2 = subplot(2,2,2);
[~,plot_1] = plot_shade(ax2, mean(V(:,1,:),3), std(V(:,1,:),0,3),'Color',CC.old,'LineWidth',2.3,'Shade',true);
[~,plot_2] = plot_shade(ax2, mean(V(:,2,:),3), std(V(:,2,:),0,3),'Color',CC.new,'LineWidth',2,'Shade',true, 'x', 401:800);
[~,plot_3] = plot_shade(ax2, mean(V(:,3,:),3), std(V(:,3,:),0,3),'Color',CC.high,'LineWidth',1.7,'Shade',true, 'LineStyle', '--','x', 1:400);
xticks(100:100:800);
yticks(0:0.2:1);
ylim([0,1]);
xlabel('Trials', 'FontSize', 13);
ylabel('V', 'FontSize', 13);

% Texts
t = title('SPH-V');
t.Position(2) = 1.05; % slightly move up
t.FontSize = 13;
set(ax2, 'FontName', 'Times New Roman Bold');
set(ax2, 'FontSize', 13);
legend([plot_1{1}, plot_2{1}, plot_3{1}], {'pre-exposed distractor', 'new distractor', 'old distractor'}, 'FontSize', 10);
text(-50,250,'B', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');

% Extend
ax2.Position = [ax2.Position(1)-0.03, ax2.Position(2), ax2.Position(3)+0.10, ax2.Position(4)];

ax4 = subplot(2,2,4);
[~,plot_1] = plot_shade(ax4, mean(alpha(:,1,:),3), std(alpha(:,1,:),0,3),'Color',CC.old,'LineWidth',2.3,'Shade',true);
[~,plot_2] = plot_shade(ax4, mean(alpha(:,2,:),3), std(alpha(:,2,:),0,3),'Color',CC.new,'LineWidth',2,'Shade',true, 'x', 401:800);
[~,plot_3] = plot_shade(ax4, mean(alpha(:,3,:),3), std(alpha(:,3,:),0,3),'Color',CC.high,'LineWidth',1.7,'Shade',true, 'LineStyle', '--', 'x', 1:400);
xticks(100:100:800);
yticks(0:0.2:1);
ylim([0,1]);
xlabel('Trials');
ylabel('alpha');
    
% Texts
t = title('SPH-alpha');
t.Position(2) = 1.05; % slightly move up
t.FontSize = 13;
set(ax4, 'FontName', 'Times New Roman Bold');
set(ax4, 'FontSize', 13);
legend([plot_1{1}, plot_2{1}, plot_3{1}], {'pre-exposed distractor', 'new distractor', 'old distractor'}, 'FontSize', 10);
text(-50,250,'D', 'FontSize', 18, 'FontName', 'Times New Roman Bold', 'Units', 'pixels');

% Extend
ax4.Position = [ax4.Position(1)-0.03, ax4.Position(2), ax4.Position(3)+0.10, ax4.Position(4)];

saveas(fig, 'Fig8.png');
