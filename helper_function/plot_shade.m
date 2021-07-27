function [ax,gp] = plot_shade(ax,m,s,varargin)
%     arguments
%         ax (1,1) matlab.graphics.axis.Axes
%         m (:,1) double
%         s (:,1) double
%         opt.LineStyle (1,1) string
%         opt.Color (1,3) double
%         opt.Shade (1,1) logical
%         opt.LineWidth (1,1) double
%     end

p = inputParser;
addParameter(p, 'LineStyle', '-');
addParameter(p, 'Color', 'k');
addParameter(p, 'Parent', ax);
addParameter(p, 'LineWidth', 1);
addParameter(p, 'Shade', false);
parse(p,varargin{:});


opts = struct('LineStyle','-','Color','k','Parent',ax,'LineWidth',1);
opts.LineStyle = p.Results.LineStyle;
opts.Color = p.Results.Color;
opts.LineWidth = p.Results.LineWidth;

if p.Results.Shade == false
    return;
else    
    curve1 = m + s;
    curve2 = m - s;
    gp{2} = fill([1:size(curve1,1),size(curve1,1):-1:1],[curve1;flipud(curve2)],'r','Parent',ax);
    gp{2}.LineStyle = 'none';
    gp{2}.FaceAlpha = 0.5;
    gp{2}.FaceColor = '#999';
end


hold(ax,'on');
gp{1}=plot(m,opts);

end
