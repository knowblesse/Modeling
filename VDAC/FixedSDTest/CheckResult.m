%% CheckResult

filelist = dir();
sessionPaths = regexp({filelist.name},'.*.mat','match');
sessionPaths = sessionPaths(~cellfun('isempty',sessionPaths));

data = zeros(numel(sessionPaths), 3);

for session = 1 : numel(sessionPaths)
    datasetPath = cell2mat(sessionPaths{session});
    load(datasetPath);
    data(session, 1) = str2num(regexp(datasetPath, 'V_(?<sd_value>.*)_result', 'names').sd_value);
    data(session, 2:end) = output_result.M.x(1:2);
end

[~, i] = sort(data(:,1));
data = data(i, :);
plot(data(:,1), data(:,2));

