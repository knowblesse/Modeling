function [ax,gp] = plot_shade(ax,m,s,opt)
    arguments
        ax (1,1) matlab.graphics.axis.Axes
        m (:,1) double
        s (:,1) double
        opt.LineStyle (1,1) string
        opt.Color (1,3) double
        opt.Shade (1,1) logical
        opt.LineWidth (1,1) double
    end
opts = struct('LineStyle','-','Color','k','Parent',ax,'LineWidth',1);

if isfield(opt,'LineStyle')
    opts.LineStyle = opt.LineStyle;
end
if isfield(opt,'Color')
    opts.Color = opt.Color;
end
if isfield(opt,'LineWidth')
    opts.LineWidth = opt.LineWidth;
end

if isfield(opt,'Shade')
    if opt.Shade == false
        return;
    else    
        curve1 = m + s;
        curve2 = m - s;
        gp{2} = fill([1:size(curve1,1),size(curve1,1):-1:1],[curve1;flipud(curve2)],'r','Parent',ax);
        gp{2}.LineStyle = 'none';
        gp{2}.FaceAlpha = 0.5;
        gp{2}.FaceColor = '#999';
    end
end

hold(ax,'on');
gp{1}=plot(m,opts);

end
