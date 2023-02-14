%% CheckResult
addpath('..');
addpath('../experiments/');
addpath('../../helper_function');

filelist = dir();
sessionPaths = regexp({filelist.name},'.*.mat','match');
sessionPaths = sessionPaths(~cellfun('isempty',sessionPaths));

data = zeros(numel(sessionPaths), 4);

for session = 1 : numel(sessionPaths)
    datasetPath = cell2mat(sessionPaths{session});
    load(datasetPath);
    data(session, 1) = str2num(regexp(datasetPath, 'V_(?<sd_value>.*)_result', 'names').sd_value);
    data(session, 2:3) = output_result.M.x(1:2);
    data(session, 4) = output_result.M.fval;
end

[~, i] = sort(data(:,1));
data = data(i, :);

%% Constants
sd = 4;
load(strcat('Anderson_2011_V_', num2str(sd), '_result.mat'));
X = output_result.M.x;
num_repeat = 200;
model = 'M';
value = 'V';
CC.high = [231,124,141]./255; % stimulus condition where the RT should be longer than the low condition
CC.low = [94,165,197]./255; % stimulus condition where the RT should be shorter than the high condition

%% Draw Graph
Anderson_2011;

%% Draw Result
[~, V, ~, Model_high, Model_low, Exp_high, Exp_low, Model_element_number] = computeNLL(X, schedule, model, num_repeat, Exp_high_mean, sd, Exp_low_mean, sd, value);

fig = figure('name', model, 'Position', [200, 120, 1200, 800]);
ax1 = subplot(2,4,1:3);
[~,plot_1] = plot_shade(ax1, mean(V(:,1,:),3), std(V(:,1,:),0,3),'Color',CC.high,'LineWidth',2.3,'Shade',true);
[~,plot_2] = plot_shade(ax1, mean(V(:,2,:),3), std(V(:,2,:),0,3),'Color',CC.low,'LineWidth',2,'Shade',true);

ylim([0,1]);
legend([plot_1{1}, plot_2{1}], {'high reward', 'low reward'});

ax2 = subplot(2,4,4);
bar((1:50)-0.25, Model_high, 'FaceColor', CC.high, 'BarWidth',0.5, 'EdgeAlpha', 0);
hold on;
bar((1:50)+0.25, Model_low, 'FaceColor', CC.low, 'BarWidth', 0.5, 'EdgeAlpha', 0);
ax2.View = [90, -90];
xticks(0:10:50);
xticklabels(0:0.2:1);

ax3 = subplot(2,4,5:6);
hold on;
bar((1:50)-0.25, Model_high, 'FaceColor', CC.high, 'BarWidth',0.5, 'EdgeAlpha', 0);
bar((1:50)+0.25, Model_low, 'FaceColor', CC.low, 'BarWidth', 0.5, 'EdgeAlpha', 0);
plot(Exp_high, 'Color', CC.high);
plot(Exp_low, 'Color', CC.low);

%% All together Figure
figure();
index = 1;
for sd = [1, 2, 4, 8, 10, 15, 20, 30, 40]
    [~, V, ~, Model_high, Model_low, Exp_high, Exp_low, Model_element_number] = computeNLL(X, schedule, model, num_repeat, Exp_high_mean, sd, Exp_low_mean, sd, value);
    subplot(3,3,index);
    hold on;
    bar((1:50)-0.25, Model_high, 'FaceColor', CC.high, 'BarWidth',0.5, 'EdgeAlpha', 0);
    bar((1:50)+0.25, Model_low, 'FaceColor', CC.low, 'BarWidth', 0.5, 'EdgeAlpha', 0);
    plot(Exp_high, 'Color', CC.high);
    plot(Exp_low, 'Color', CC.low);
    xticks(0:10:50);
    xticklabels(0:0.2:1);
    title(strcat('SD = ', num2str(sd)));
    index = index + 1;
end

%% Ratio with RW alpha

fval = zeros(8,7); % 7 models x 8 sd conditions

idx = 1;
for sd = [2, 4, 8, 10, 15, 20, 30, 40]
    load(strcat('Anderson_2011_V_', num2str(sd), '_result.mat'));
    fval_V = [...
        output_result.RW.fval,...
        output_result.M.fval,...
        output_result.SPH.fval,...
        output_result.EH.fval];
    load(strcat('Anderson_2011_alpha_', num2str(sd), '_result.mat'));
    fval_alpha = [...
        output_result.M.fval,...
        output_result.SPH.fval,...
        output_result.EH.fval];
    
    fval(idx, :) = [fval_V, fval_alpha] ./ output_result.RW.fval;
    idx = idx + 1;
end


    

%savefig(fig,strcat('./result_nll', filesep, experiment, filesep, value, filesep, model,'_',experiment,'_',value,'_result.fig'));
