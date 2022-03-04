%% Anderson et al 2011
% Anderson et al. 2011 simulation

%% Experiment Data
RT_none = 665;
RT_low = 673;
RT_high = 681;

Exp_high_mean = RT_high - RT_none;
Exp_high_sd = 2.6;
Exp_low_mean = RT_low - RT_none;
Exp_low_sd = 2.8;

high_reward = 1; %5 cents
low_reward = 0.2; %1 cents

%% Experiment Schedule
% +--------+--------+--------+--------+---------------------------+
% | CS1    | CS2    | CS3    | US     | US intensity(reward size) |
% +--------+--------+--------+--------+---------------------------+
% | 1 or 0 | 1 or 0 | 1 or 0 | 1 or 0 | float                     |
% +--------+--------+--------+--------+---------------------------+
schedule = struct();
schedule.schedule_training = [...
    repmat([1,0,0,1,high_reward],4,1);...
    repmat([1,0,0,1,low_reward],1,1);...
    repmat([0,1,0,1,high_reward],1,1);...
    repmat([0,1,0,1,low_reward],4,1);...
    ]; % thesis : 1008 trials vs Modeling : 1010 trials (10 trial set * 101)
schedule.schedule_training_repeat = 101;
schedule.schedule_training_N = size(schedule.schedule_training,1) * schedule.schedule_training_repeat;

schedule.schedule_testing = [...
    [1,0,0,0,0];
    [0,1,0,0,0];
    [0,0,0,0,0];
    [0,0,0,0,0];
    ]; % * 120 
schedule.schedule_testing_repeat = 120;
schedule.schedule_testing_N = size(schedule.schedule_testing,1) * schedule.schedule_testing_repeat;
