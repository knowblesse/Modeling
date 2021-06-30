function plotExperimentSchedule(CS, US, ITI)
%% Plot Experiment Schedule
fig_sch = figure('Name','Experiment Schedule');
fig_sch.Position = [173, 672, 1515, 263];
clf(fig_sch);

map = [...
    0.800,0.800,0.800;... % 0 : Gray
    0.965,0.527,0.602;... % 1 : Red
    0.507,0.789,0.984     % 2 : Blue
    ];
trial_length = max(CS.length,US.end) + ITI;
v_schedule = zeros(2,trial_length);
v_schedule(1,1:CS.length) = 2;
v_schedule(2,US.start:US.end) = 1;

hmap = heatmap(v_schedule);
hmap.YDisplayLabels={'CS','US'};
hmap.CellLabelColor = 'none';
colormap(map)
end