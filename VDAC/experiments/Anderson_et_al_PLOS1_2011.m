%% Anderson_et_al_PLOS1_2011
% Experiment Setup for Anderson et al. (2011) in PLOS One

%% Experiment Data
% all mean RT values are subtracted from RT of corresponding neutral condition
ExperimentData.HighTarget.Mean = [472.3591555, 460.3282374, 450.873717, 452.5483446, 453.5270914, 456.0775211, 457.1595216, 456.5928625, 451.4403761, 455.6654335];
ExperimentData.HighTarget.SD = 3;
ExperimentData.LowTarget.Mean = [477.7434991, 464.4243821, 459.9934355, 461.3329521, 456.9020055, 457.5459504, 455.0728064, 458.1642364, 456.4899179, 454.5318061];
ExperimentData.LowTarget.SD = 3;

% Since the lower RT indicates more attention allocation (i.e. higher V value) in this study, 
% I used mean values below.
ExperimentData.HighTarget.Mean = ExperimentData.LowTarget.Mean(1) - ExperimentData.HighTarget.Mean;
ExperimentData.LowTarget.Mean = ExperimentData.LowTarget.Mean(1) - ExperimentData.LowTarget.Mean;

%% Experiment Schedule
% +--------+--------+--------+--------+---------------------------+
% | CS1    | CS2    | CS3    | US     | US intensity(reward size) |
% +--------+--------+--------+--------+---------------------------+
% | 1 or 0 | 1 or 0 | 1 or 0 | 1 or 0 | float                     |
% +--------+--------+--------+--------+---------------------------+
high_reward = 1; %5 cents
low_reward = 0.2; %1 cents

schedule = struct();
%-------------------- Block 1 Training ---------------------------%
schedule.schedule = repmat([...
    repmat([1,0,0,1,high_reward],4,1);... % High : 80% high
    repmat([1,0,0,1,low_reward],1,1);... % High : 20% low
    repmat([0,1,0,1,high_reward],1,1);... % Low : 20% high
    repmat([0,1,0,1,low_reward],4,1);... % Low : 80% low
    ],100,1); % thesis : 1008 trials. simulation : 10 trials x 100 blocks = 1000 trials
schedule.N = 1000;

