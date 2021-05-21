%% KSBNS_AnimalExp_Comparision
% KSBNS * Predictions from the simulations > comparing real animal data
% figure
% 2021 Knowblesse
% 21MAY11

%% Color Constant
CC.con_1 = [113,204,255]/255;
CC.con_2 = [50,84,157]/255;
CC.par_1 = [130,196,124]/255;
CC.par_2 = [66,116,62]/255;

CC.US  = [234,129,147]/255;

%% Experiment Schedule from the (Haselgrove et al. 2004)

lambda1 = 0.5;
lambda2 = 1;
acquisition = 100;
extinction = 100;

schedule_con_1 = [...
    repmat([1,0,0,1,0.5,0.5,0.5,lambda1], acquisition,1);
    repmat([1,0,0,0,0.5,0.5,0.5,lambda1], extinction,1)];
schedule_con_2 = [...
    repmat([1,0,0,1,0.5,0.5,0.5,lambda2], acquisition,1);
    repmat([1,0,0,0,0.5,0.5,0.5,lambda2], extinction,1)];
schedule_par_1 = [...
    repmat([...
        1,0,0,1,0.5,0.5,0.5,lambda1;...
        1,0,0,1,0.5,0.5,0.5,lambda1;...
        1,0,0,0,0.5,0.5,0.5,lambda1;...
        1,0,0,0,0.5,0.5,0.5,lambda1], acquisition/4,1);
    repmat([1,0,0,0,0.5,0.5,0.5,lambda1], extinction,1)];
    
schedule_par_2 = [...
    repmat([...
        1,0,0,1,0.5,0.5,0.5,lambda2;...
        1,0,0,1,0.5,0.5,0.5,lambda2;...
        1,0,0,0,0.5,0.5,0.5,lambda2;...
        1,0,0,0,0.5,0.5,0.5,lambda2], acquisition/4,1);
    repmat([1,0,0,0,0.5,0.5,0.5,lambda2], extinction,1)];
    
model_names = {'Rescorla-Wagner', 'Mackintosh', 'Pearce-Hall', 'Esber-Hasselgrove', 'Temporal Difference'};

%% Run
for model = 1:5
    % Used CCC_exported"_test" for parameter manipulations
    app1 = CCC_exported_test(schedule_con_1,model);
    app2 = CCC_exported_test(schedule_con_2,model);
    app3 = CCC_exported_test(schedule_par_1,model);
    app4 = CCC_exported_test(schedule_par_2,model);
    fig = figure(model);
    clf(fig);
    hold on;
    v_plot_1 = plot(app1.V(:,1),'Color',CC.con_1,'LineWidth',2);
    v_plot_2 = plot(app2.V(:,1),'Color',CC.con_2,'LineWidth',2);
    v_plot_3 = plot(app3.V(:,1),'Color',CC.par_1,'LineWidth',2);
    v_plot_4 = plot(app4.V(:,1),'Color',CC.par_2,'LineWidth',2);
    a_plot_1 = plot(app1.alpha(:,1),'Color',CC.con_1,'LineStyle','--','LineWidth',2);
    a_plot_2 = plot(app2.alpha(:,1),'Color',CC.con_2,'LineStyle','--','LineWidth',2);
    a_plot_3 = plot(app3.alpha(:,1),'Color',CC.par_1,'LineStyle','--','LineWidth',2);
    a_plot_4 = plot(app4.alpha(:,1),'Color',CC.par_2,'LineStyle','--','LineWidth',2);
    title(model_names{model});
    xlabel('Trial');
    ylabel('V');
    xlim([0,acquisition + extinction]);
    ylim([0,1]);
    if model == 5
        ylabel('w');
        a_plot_1.Visible = false;
        a_plot_2.Visible = false;
    end 
    legend({'con_1','con_2','par_1','par_2'});
    saveas(fig,strcat(model_names{model},'_animal'),'png');
end   
