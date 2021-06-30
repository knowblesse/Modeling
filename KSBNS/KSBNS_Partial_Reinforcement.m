%% KSBNS_Partial_Reinforcement
% KSBNS * Predictions from the simulations > Partial reinforcement figures
% 2021 Knowblesse
% 21MAY11

addpath('..');
addpath('../helper_function');

%% Color Constant
CC.CS1 = [113,204,255]/255;
CC.CS2 = [130,196,124]/255;
CC.US  = [234,129,147]/255;

%% Partial Reinforcement Schedule

schedule_con_half = repmat([1,0,0,1,0.5,0.5,0.5,.5], 200,1);
schedule_par = [...
    1,0,0,1,0.5,0.5,0.5,1;...
    1,0,0,1,0.5,0.5,0.5,1;...
    1,0,0,0,0.5,0.5,0.5,1;...
    1,0,0,0,0.5,0.5,0.5,1;...
    ];
schedule_par = repmat(schedule_par,50,1);

model_names = {'Rescorla-Wagner', 'Mackintosh', 'Pearce-Hall', 'Esber-Hasselgrove', 'Temporal Difference'};

%% Run
for model = 1:5
    app1 = CCC_exported(schedule_con_half,model);
    app2 = CCC_exported(schedule_par,model);
    app.V = app1.V;
    app.V(:,2) = app2.V(:,1);
    app.alpha = app1.alpha;
    app.alpha(:,2) = app2.alpha(:,1);
    fig = figure();
    clf(fig);
    hold on;
    v_plot_1 = plot(app.V(:,1),'Color',CC.CS1,'LineWidth',2);
    v_plot_2 = plot(app.V(:,2),'Color',CC.CS2,'LineWidth',2);
    a_plot_1 = plot(app.alpha(:,1),'Color',CC.CS1,'LineStyle','--','LineWidth',2);
    a_plot_2 = plot(app.alpha(:,2),'Color',CC.CS2,'LineStyle','-.','LineWidth',2);
    title(model_names{model});
    xlabel('Trial');
    ylabel('V');
    xlim([0,200]);
    ylim([0,1]);
    if model == 5
        ylabel('w');
        a_plot_1.Visible = false;
        a_plot_2.Visible = false;
    end 
end   
    
    
    
