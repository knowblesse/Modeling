a = dir();
filenames = {a.name};
filenames = filenames(3:end);

for i = 1 : length(filenames)
    fn = filenames{i};
    if ~isempty(regexp(fn,'.fig','match'))
        fig = openfig(fn);
        fig_data = regexp(fn,'(?<model>\w*?)_.*','names');
        model_name = fig_data.model;
        fig_data = regexp(fn,'(\d){4}_(?<var>\w*?)_result.fig','names');
        var_name = fig_data.var;
        fig2 = figure('Position',[98,509,981,358]);
        fig.Children(end).Parent = fig2;
        subplot(1,4,1:3,fig2.Children(2));
        fig.Children(end-1).Parent = fig2;
        ax = subplot(1,4,4,fig2.Children(1));
        ax.View = [90, -90];
        ax = subplot(1,4,4);
        for k = 1 : numel(ax.Children)
            if strcmp(class(ax.Children(k)),'matlab.graphics.chart.primitive.Bar')
                ax.Children(k).EdgeAlpha = 0;
            end
        end
        subplot(1,4,1:3);
        title(strcat(model_name, "  ", var_name), 'Interpreter', 'none');
        saveas(fig2,strcat(fn(1:end-3),'png'),'png');
    end
end


%% Liao (2020)
a = dir();
filenames = {a.name};
filenames = filenames(3:end);

for i = 1 : length(filenames)
    fn = filenames{i};
    if ~isempty(regexp(fn,'.fig','match'))
        fig = openfig(fn);
        fig_data = regexp(fn,'(?<model>\w*?)_.*','names');
        model_name = fig_data.model;
        fig_data = regexp(fn,'(\d){4}_(?<var>\w*?)_result.fig','names');
        var_name = fig_data.var;
        subplot(2,4,1:4);
        title(strcat(model_name, "  ", var_name));
        if strcmp(model_name, 'EH')
            ylim([0,2]);
        end
        for p = 5:8
            ax = subplot(2,4,p);
            for k = 1 : numel(ax.Children)
                if strcmp(class(ax.Children(k)),'matlab.graphics.chart.primitive.Bar')
                    ax.Children(k).EdgeAlpha = 0;
                end
            end
        end
        saveas(fig,strcat(fn(1:end-3),'png'),'png');
    end
end

%% Anderson Plos One (2011)

a = dir();
filenames = {a.name};
filenames = filenames(3:end);

for i = 1 : length(filenames)
    fn = filenames{i};
    if ~isempty(regexp(fn,'.fig','match'))
        fig = openfig(fn);
        fig_data = regexp(fn,'(?<model>\w*?)_.*','names');
        model_name = fig_data.model;
        fig_data = regexp(fn,'(\d){4}_(?<var>\w*?)_result.fig','names');
        var_name = fig_data.var;
        subplot(2,10,1:10);
        title(strcat(model_name, "  ", var_name));
        for i = 1 : 10
            ax = subplot(2,10,10+i);
            xticks([]);
            ylim([0,0.15]);
            yticks([]);
            ax.Position = [ax.Position(1), ax.Position(2), 0.07,ax.Position(4)];
        end
        saveas(fig,strcat(fn(1:end-3),'png'),'png');
    end
end