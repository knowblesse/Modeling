%% FixedSDTestScript

% Search the best parameters for all experiments with two conditions.
models = {'M'};
for experiment = {'Anderson_2011'}
    for value = {'V'}
        for sd = [1, 2, 4, 8, 10, 15, 20]
            mlParameterSearch2_SDTesting(experiment, value, models, sd);
        end
    end
end
