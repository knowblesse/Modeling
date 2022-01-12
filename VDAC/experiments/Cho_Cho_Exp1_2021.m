%% Cho_Cho_Exp1_2021
% Cho & Cho 2021 Experiment 1 simulation

%% Experiment Data
RT_none = 600;
RT_uncertain = 623;
RT_certain = 608;

Exp_high_mean = RT_uncertain - RT_none; % high as high uncertainty
Exp_high_sd = 16.33; % 24 participants
Exp_low_mean = RT_certain - RT_none;
Exp_low_sd = 15.11; % 24 participants

high_reward = 1; %100 points
low_reward = 0.25; %25 points

%% Experiment Schedule
% +--------+--------+--------+--------+---------------------------+
% | CS1    | CS2    | CS3    | US     | US intensity(reward size) |
% +--------+--------+--------+--------+---------------------------+
% | 1 or 0 | 1 or 0 | 1 or 0 | 1 or 0 | float                     |
% +--------+--------+--------+--------+---------------------------+
schedule = struct();
schedule.schedule_training = [...
    repmat([1,0,0,1,high_reward],1,1);...
    repmat([1,0,0,0,0],3,1);...
    repmat([0,1,0,1,low_reward],4,1);...
    ]; % thesis : 192 trials x 3 blocks = 576 trials --> 8 trial set * 72 
schedule.schedule_training_repeat = 72;
schedule.schedule_training_N = size(schedule.schedule_training,1) * schedule.schedule_training_repeat;

schedule.schedule_testing = [...
    [1,0,0,0,0];
    [0,1,0,0,0];
    [0,0,0,0,0];
    [0,0,0,0,0];
    ]; % thesis : 144 trials x 2 blocs = 288 trials --> 4 trial set * 72 
schedule.schedule_testing_repeat = 72;
schedule.schedule_testing_N = size(schedule.schedule_testing,1) * schedule.schedule_testing_repeat;

%% Linear Transformation Parameter
% experiment specific range for matching V to RT or score difference from the experiment
ltp_lowerbound = [-30, -30];
ltp_upperbound = [+30, +30];
ltp_x0 = [5, 25]; % rule of thumb 
