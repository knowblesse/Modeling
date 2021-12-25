%% parameters
tic;
addpath('..');
addpath('helper_function');

model = 'M';
numBinModel = 30; % number of bins to divide the V or alpha
num_repeat = 100;

%% Experiment Data
RT_none.T1008 = 665;
RT_low.T1008 = 673;
RT_high.T1008 = 681;

bins = 1:30;
EXP_DATA_HIGH = normpdf(bins,RT_high.T1008 - RT_none.T1008, 2.8);
EXP_DATA_LOW = normpdf(bins,RT_low.T1008 - RT_none.T1008, 2.8);

exp1_high_reward = 1; %5 cents
exp1_low_reward = 0.2; %1 cents

%% Experiment Schedule
schedule_training = [...
    repmat([1,0,0,1,exp1_high_reward],4,1);...
    repmat([1,0,0,1,exp1_low_reward],1,1);...
    repmat([0,1,0,1,exp1_high_reward],1,1);...
    repmat([0,1,0,1,exp1_low_reward],4,1);...
    ]; % thesis : 1008 trials vs Modeling : 1010 trials (10 trial set * 101)

schedule_testing = [...
    [1,0,0,0,0];
    [0,1,0,0,0];
    [0,0,0,0,0];
    [0,0,0,0,0];
    ]; % * 120 

%% Repeat with parameter
param = getDefaultParam();
score = zeros(numel(param.M.lr_acq.range), numel(param.M.lr_ext.range), numel(param.M.k.range), numel(param.M.epsilon.range));
d = [0, 0, 0, 0];
for lr_acq = 1 : numel(param.M.lr_acq.range)
    param.M.lr_acq.value = param.M.lr_acq.range(lr_acq);
    
    for lr_ext = 1 : numel(param.M.lr_ext.range)
        param.M.lr_ext.value = param.M.lr_ext.range(lr_ext);
        
        if lr_ext >= lr_acq
            continue
        else
            for k = 1 : numel(param.M.k.range)
                param.M.k.value = param.M.k.range(k);

                for epsilon = 1 : numel(param.M.epsilon.range)
                    param.M.epsilon.value = param.M.epsilon.range(epsilon);
                   %% Run
                    V = zeros(1490,3,num_repeat);
                    alpha = zeros(1490,3,num_repeat);

                    for r = 1 : num_repeat
                        % Shuffle schedule for repeated simulation
                        schedule_shuffled = [shuffle1D(repmat(schedule_training,101,1)); shuffle1D(repmat(schedule_testing,120,1))];

                        [outV, outAlpha] = SimulateModel(schedule_shuffled,model, param);

                        V(:,:,r) = outV; % [trial, cs type, repeat]
                        alpha(:,:,r) = outAlpha;
                    end

                    V1 = histcounts(V(1011:end,1,:),linspace(0,1,numBinModel + 1))/numel(V(1011:end,1,:));
                    V2 = histcounts(V(1011:end,2,:),linspace(0,1,numBinModel + 1))/numel(V(1011:end,2,:));

                    a1 = histcounts(alpha(1011:end,1,:),linspace(0,1,numBinModel + 1));
                    a2 = histcounts(alpha(1011:end,2,:),linspace(0,1,numBinModel + 1));

                  %% Check Score
                  data = []
                  for offset = 0 : 0.5 : 10
                      bins = 1:30;
                      EXP_DATA_HIGH = normpdf(bins,RT_high.T1008 - RT_none.T1008-offset, 2.8);
                      EXP_DATA_LOW = normpdf(bins,RT_low.T1008 - RT_none.T1008-offset, 2.8);
                      
                      data = [data; sum(EXP_DATA_HIGH .* V1) + sum(EXP_DATA_LOW .* V2)];
                  end
                end
               
            end
        end
        fprintf('B');
    end
end

