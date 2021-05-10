%% MultiModel_Runner

%% Design
CC.CS1 = [113,204,255]/255;
CC.CS2 = [130,196,124]/255;
CC.US  = [234,129,147]/255;


%% Schedule
% +------+------+------+------+----------+---------+---------+--------+
% | Col1 | Col2 | Col3 | Col4 |   Col5   |  Col6   |  Col7   |  Col8  |
% +------+------+------+------+----------+---------+---------+--------+
% | CS A | CS B | CS C | US   | alpha A  | alpha B | alpha C | lambda |
% +------+------+------+------+----------+---------+---------+--------+

schedule_acq_ext = [...
    repmat([1,0,0,1,0.5,0.5,0.5,1], 100,1);...
    repmat([1,0,0,0,0.5,0.5,0.5,0], 100,1)...
    ];

schedule_blocking = [...
    repmat([1,0,0,1,0.5,0.5,0.5,1], 20,1);...
    repmat([1,1,0,1,0.5,0.5,0.5,1], 100,1)...
    ];

schedule_latent_inhibition = [...
    repmat([1,0,0,0,0.5,0.5,0.5,0], 100,1);...
    repmat([1,0,0,1,0.5,0.5,0.5,1], 100,1)...
    ];
schedule_latent_inhibition_cmp = [...
    repmat([0,0,0,0,0.5,0.5,0.5,0], 100,1);...
    repmat([1,0,0,1,0.5,0.5,0.5,1], 100,1)...
    ];

schedule = schedule_acq_ext;
model_names = {'Rescorla-Wagner', 'Mackintosh', 'Pearce-Hall', 'Esber-Hasselgrove', 'Temporal Difference'};
% Model : 1|RW    2|M    3|PH    4|EH    5|TD
fig = figure(1);
fig.Position = [-1699         390         845         462];
clf(fig);
for model = 1:5
    app = CCC_exported(schedule,model);
    hold on;
    v_plot_1 = plot(app.V(:,1),'Color',CC.CS1,'LineWidth',2);
    v_plot_2 = plot(app.V(:,2),'Color',CC.CS2,'LineWidth',2);
    a_plot_1 = plot(app.alpha(:,1),'Color',CC.CS1,'LineStyle','--','LineWidth',2);
    a_plot_2 = plot(app.alpha(:,2),'Color',CC.CS2,'LineStyle','-.','LineWidth',2);
    title(model_names{model});
    xlabel('Trial');
    ylabel('V');
    xlim([0,120]);
    ylim([0,1]);
    if model == 5
        ylabel('w');
        a_plot_1.Visible = false;
        a_plot_2.Visible = false;
    end 
    %saveas(fig1,strcat(model_names{model},'_Blocking'),'png');
end   
    
    
    
