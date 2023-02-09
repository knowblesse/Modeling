%% Anderson et al 2015
% Anderson et al. 2015 simulation

%% Experiment Data
RT_none = 746;
RT_low = 748;
RT_high = 759;

Exp_high_mean = RT_high - RT_none;
Exp_high_sd = 3;
Exp_low_mean = RT_low - RT_none;
Exp_low_sd = 3;

high_reward = 1; %10 cents
low_reward = 0; %1 cents

%% Experiment Schedule
% +--------+--------+--------+--------+---------------------------+
% | CS1    | CS2    | CS3    | US     | US intensity(reward size) |
% +--------+--------+--------+--------+---------------------------+
% | 1 or 0 | 1 or 0 | 1 or 0 | 1 or 0 | float                     |
% +--------+--------+--------+--------+---------------------------+
schedule = struct();
schedule.schedule_training = [...
    repmat([1,0,0,1,high_reward],1,1);...
    repmat([0,1,0,0,low_reward],1,1);...
    ]; % thesis : 360 trials vs Modeling : 360 trials (2 trial set * 180)
schedule.schedule_training_repeat = 180;
schedule.schedule_training_N = size(schedule.schedule_training,1) * schedule.schedule_training_repeat;

schedule.schedule_testing = [...
    [1,0,0,0,0];
    [0,1,0,0,0];
    [0,0,0,0,0];
    [0,0,0,0,0];
    ]; % thesis : 480 trials vs Modeling : 480 trials (4 trial set * 120
schedule.schedule_testing_repeat = 120;
schedule.schedule_testing_N = size(schedule.schedule_testing,1) * schedule.schedule_testing_repeat;
