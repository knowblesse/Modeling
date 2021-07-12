%% KSBNS_HumanExp_Comparision
% KSBNS * Predictions from the simulations > comparing real human data
% figure
% 2021 Knowblesse
% 21MAY11

addpath('..');
addpath('../helper_function');

%% Color Constant
CC.exp1_cert = [113,204,255]/255;
CC.exp1_unct = [50,84,157]/255;
CC.exp2_cert = [130,196,124]/255;
CC.exp2_unct = [66,116,62]/255;

CC.US  = [234,129,147]/255;

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


model_names = {'Rescorla-Wagner', 'Mackintosh', 'Pearce-Hall', 'Esber-Haselgrove', 'Temporal Difference'};
num_repeat = 100;

%% Run
for model = 1:5
    V = cell(1,4);
    alpha = cell(1,4);
    for r = 1 : num_repeat
        % Shuffle schedule for repeated simulation
        schedule_exp1_uncertain_shuffled = [shuffle1D(schedule_exp1_uncertain);repmat([1,0,0,0,0],50,1)];
        schedule_exp1_certain_shuffled = [shuffle1D(schedule_exp1_certain);repmat([1,0,0,0,0],50,1)];
        schedule_exp2_uncertain_shuffled = [shuffle1D(schedule_exp2_uncertain);repmat([1,0,0,0,0],50,1)];
        schedule_exp2_certain_shuffled = [shuffle1D(schedule_exp2_certain);repmat([1,0,0,0,0],50,1)];

        app1 = CCC_exported(schedule_exp1_uncertain_shuffled,model,[0.5, 0.5, 0.5]);
        app2 = CCC_exported(schedule_exp1_certain_shuffled,model,[0.5, 0.5, 0.5]);
        app3 = CCC_exported(schedule_exp2_uncertain_shuffled,model,[0.5, 0.5, 0.5]);
        app4 = CCC_exported(schedule_exp2_certain_shuffled,model,[0.5, 0.5, 0.5]);

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
    [~,v_plot_1] = plot_shade(fig.Children, mean(V{1},2), std(V{1},0,2),'Color',CC.exp1_unct,'LineWidth',2,'Shade',true);
    [~,v_plot_2] = plot_shade(fig.Children, mean(V{2},2), std(V{2},0,2),'Color',CC.exp1_cert,'LineWidth',2,'Shade',true);
    [~,v_plot_3] = plot_shade(fig.Children, mean(V{3},2), std(V{3},0,2),'Color',CC.exp2_unct,'LineWidth',2,'Shade',true);
    [~,v_plot_4] = plot_shade(fig.Children, mean(V{4},2), std(V{4},0,2),'Color',CC.exp2_cert,'LineWidth',2,'Shade',true);
    title(model_names{model});
    xlabel('Trial');
    ylabel('V');
    xlim([0,150]);
    ylim([0,0.7]);
    legend([v_plot_1{1}, v_plot_2{1}, v_plot_3{1}, v_plot_4{1}],{'exp1 uncertain','exp1 certain','exp2 uncertain','exp2 certain'});
end   
