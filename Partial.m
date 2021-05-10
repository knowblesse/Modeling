%% MultiModel_Runner

%% Design
CC.CS1 = [113,204,255]/255;
CC.CS2 = [130,196,124]/255;
CC.CS3=
CC.US  = [234,129,147]/255;


%% Schedule
% +------+------+------+------+----------+---------+---------+--------+
% | Col1 | Col2 | Col3 | Col4 |   Col5   |  Col6   |  Col7   |  Col8  |
% +------+------+------+------+----------+---------+---------+--------+
% | CS A | CS B | CS C | US   | alpha A  | alpha B | alpha C | lambda |
% +------+------+------+------+----------+---------+---------+--------+
%% Partial Reinforcement Schedule

% for comparision
schedule_acq_half = repmat([1,0,0,1,0.5,0.5,0.5,.5], 200,1);

% half alternating
schedule_half_alternating = [...
    1,0,0,1,0.5,0.5,0.5,1;...
    1,0,0,1,0.5,0.5,0.5,1;...
    1,0,0,0,0.5,0.5,0.5,1;...
    1,0,0,0,0.5,0.5,0.5,1;...
    ];
schedule_half_alternating = repmat(schedule_half_alternating,50,1);



model_names = {'Rescorla-Wagner', 'Mackintosh', 'Pearce-Hall', 'Esber-Hasselgrove', 'Temporal Difference'};
% Model : 1|RW    2|M    3|PH    4|EH    5|TD


for model = 1:5
    app1 = CCC_exported(schedule_acq_half,model);
    app2 = CCC_exported(schedule_half_alternating,model);
    app.V = app1.V;
    app.V(:,2) = app2.V(:,1);
    app.alpha = app1.alpha;
    app.alpha(:,2) = app2.alpha(:,1);
    fig = figure();
    fig.Position = [-1699         390         845         462];
    clf(fig);
    %ax = subplot(2,3,model,'Parent',fig1);
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
    %saveas(fig1,strcat(model_names{model},'_Blocking'),'png');
end   
    
    
    
