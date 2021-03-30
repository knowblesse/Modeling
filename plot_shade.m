function ax = plot_shade(ax,m,s)
plot(m,'k','LineWidth',1,'Parent',ax);
hold(ax,'on');
curve1 = m + s;
curve2 = m - s;
p1 = fill([1:size(curve1,1),size(curve1,1):-1:1],[curve1;flipud(curve2)],'r','Parent',ax);
p1.LineStyle = 'none';
p1.FaceAlpha = 0.5;
p1.FaceColor = '#999';
end

