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
        fig2 = figure('Position',[98,509,1181,458]);
        fig.Children(end).Parent = fig2;
        subplot(1,4,1:3,fig2.Children(2));
        fig.Children(end).Parent = fig2;
        subplot(1,4,4,fig2.Children(1));
        subplot(1,4,1:3);
        title(strcat(model_name, "  ", var_name));
        saveas(fig2,strcat(fn(1:end-3),'png'),'png');
    end
end
