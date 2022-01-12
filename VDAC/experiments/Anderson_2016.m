%% Anderson 2016
% Anderson 2016 simulation
% Auditory

%% Experiment Data
RT_none = 681;
RT_low = 684;
RT_high = 700;

Exp_high_mean = RT_high - RT_none;
Exp_high_sd = 3.07;
Exp_low_mean = RT_low - RT_none;
Exp_low_sd = 4.08;

exp1_high_reward = 1; %10 cents
exp1_low_reward = 0.2; %2 cents

%% Experiment Schedule
% +--------+--------+--------+--------+---------------------------+
% | CS1    | CS2    | CS3    | US     | US intensity(reward size) |
% +--------+--------+--------+--------+---------------------------+
% | 1 or 0 | 1 or 0 | 1 or 0 | 1 or 0 | float                     |
% +--------+--------+--------+--------+---------------------------+
schedule = struct();
schedule.schedule_training = [...
    repmat([1,0,0,1,exp1_high_reward],1,1);...
    repmat([0,1,0,1,exp1_low_reward],1,1);...
    ]; % thesis : 120 trials x 4 blocks of spoken words = 480 trials --> 2 trial set * 240
schedule.schedule_training_repeat = 240;
schedule.schedule_training_N = size(schedule.schedule_training,1) * schedule.schedule_training_repeat;

schedule.schedule_testing = [...
    [1,0,0,0,0];
    [0,1,0,0,0];
    [0,0,0,0,0];
    ]; % thesis : total 144 trials----> 3 trial set * 48 
schedule.schedule_testing_repeat = 48;
schedule.schedule_testing_N = size(schedule.schedule_testing,1) * schedule.schedule_testing_repeat;

%% Linear Transformation Parameter
% experiment specific range for matching V to RT or score difference from the experiment
ltp_lowerbound = [-30, -30];
ltp_upperbound = [+30, +30];
ltp_x0 = [5, 25]; % rule of thumb 
