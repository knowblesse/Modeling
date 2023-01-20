%% FixedSDTestScript

% Search the best parameters for all experiments with two conditions.
models = {'EH'};
for experiment = {'Anderson_2011'}
    for value = {'V'}
        for sd = 1 : 0.2 : 4
            mlParameterSearch2_SDTesting(experiment, value, models, sd);
        end
    end
end
