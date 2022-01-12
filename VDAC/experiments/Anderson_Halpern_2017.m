%% Anderson_Halpern_2017

%% Experiment Data
RT_none = 688;
RT_low = 689;
RT_high = 698;

Exp_high_mean = RT_high - RT_none;
Exp_high_sd = 13.25;
Exp_low_mean = RT_low - RT_none;
Exp_low_sd = 13.25;

high_reward = 1; %10 cents
low_reward = 0.2; %2 cents

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
    ]; % thesis : 240 trials vs Modeling : 240 trials (10 trial set * 24)
schedule.schedule_training_repeat = 24;
schedule.schedule_training_N = size(schedule.schedule_training,1) * schedule.schedule_training_repeat;

schedule.schedule_testing = [...
    [1,0,0,0,0];
    [0,1,0,0,0];
    [0,0,0,0,0];
    [0,0,0,0,0];
    ]; % * 60 = 240 test trials
schedule.schedule_testing_repeat = 60;
schedule.schedule_testing_N = size(schedule.schedule_testing,1) * schedule.schedule_testing_repeat;

%% Linear Transformation Parameter
% experiment specific range for matching V to RT or score difference from the experiment
ltp_lowerbound = [-30, -30];
ltp_upperbound = [+30, +30];
ltp_x0 = [5, 25]; % rule of thumb 
