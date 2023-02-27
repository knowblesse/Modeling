%% SearchAll2ParamExp
% Search the best parameters for all experiments with two conditions.
models = {'RW', 'M', 'SPH', 'EH'};
for experiment = {'Anderson_2011', 'Anderson_Halpern_2017', 'Cho_Cho_Exp1_2021', 'Anderson_2015', 'Mine_Saiki_2015'}
    for value = {'V', 'alpha'}
        mlParameterSearch2(experiment, value, models);
    end
end
