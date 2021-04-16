function ax = plot_shade(ax,m,s,opt)
    arguments
        ax (1,1) matlab.graphics.axis.Axes
        m (:,1) double
        s (:,1) double
        opt.LineStyle (1,1) string
        opt.Color (1,1) string
        opt.Shade (1,1) logical
    end
opts = struct('LineStyle','-','Color','k','Parent',ax,'LineWidth',1);

if isfield(opt,'LineStyle')
    opts.LineStyle = opt.LineStyle;
end
if isfield(opt,'Color')
    opts.Color = opt.Color;
end
plot(m,opts);
hold(ax,'on');
if isfield(opt,'Shade')
    if opt.Shade == false
        return;
    else    
        curve1 = m + s;
        curve2 = m - s;
        p1 = fill([1:size(curve1,1),size(curve1,1):-1:1],[curve1;flipud(curve2)],'r','Parent',ax);
        p1.LineStyle = 'none';
        p1.FaceAlpha = 0.5;
        p1.FaceColor = '#999';
    end
end
end
