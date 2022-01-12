%% Mine_Saiki_2017
% Mine & Saiki 2017 simulation
% Exp2

%% Experiment Data
RT_none = 844.73;
RT_low = 850.02;
RT_high = 869.31;

Exp_high_mean = RT_high - RT_none;
Exp_high_sd = 18.35;
Exp_low_mean = RT_low - RT_none;
Exp_low_sd = 17.59;

high_reward = 1; %100 yen
low_reward = 0.1; %10 yen

%% Experiment Schedule
% +--------+--------+--------+--------+---------------------------+
% | CS1    | CS2    | CS3    | US     | US intensity(reward size) |
% +--------+--------+--------+--------+---------------------------+
% | 1 or 0 | 1 or 0 | 1 or 0 | 1 or 0 | float                     |
% +--------+--------+--------+--------+---------------------------+
schedule = struct();
schedule.schedule_training = [...
    repmat([1,0,0,1,high_reward],3,1);...
    repmat([1,0,0,1,low_reward],1,1);...
    repmat([0,1,0,1,low_reward],3,1);...
    repmat([0,1,0,1,high_reward],1,1);...
    ]; % thesis : 48 trials x 5 blocks = 240 trials --> 8 trial set * 30 
schedule.schedule_training_repeat = 30;
schedule.schedule_training_N = size(schedule.schedule_training,1) * schedule.schedule_training_repeat;

schedule.schedule_testing = [...
    [1,0,0,0,0];
    [0,1,0,0,0];
    [0,0,0,0,0];
    ]; % thesis : 192 trials----> 3 trial set * 64 
schedule.schedule_testing_repeat = 64;
schedule.schedule_testing_N = size(schedule.schedule_testing,1) * schedule.schedule_testing_repeat;

%% Linear Transformation Parameter
% experiment specific range for matching V to RT or score difference from the experiment
ltp_lowerbound = [-40, -40];
ltp_upperbound = [+40, +40];
ltp_x0 = [0, 30]; % rule of thumb 
