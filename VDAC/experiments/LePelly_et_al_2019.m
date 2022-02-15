%% LePelly_et_al_2019

%% Experiment Data
% RT_none = 844.73;
% RT_low = 850.02;
% RT_high = 869.31;
% 
% Exp_high_mean = RT_high - RT_none;
% Exp_high_sd = 18.35;
% Exp_low_mean = RT_low - RT_none;
% Exp_low_sd = 17.59;

high_reward = 1; %500 point
low_reward = 0.02; %10 point

%% Experiment Schedule
% +--------+--------+--------+--------+---------------------------+
% | CS1    | CS2    | CS3    | US     | US intensity(reward size) |
% +--------+--------+--------+--------+---------------------------+
% | 1 or 0 | 1 or 0 | 1 or 0 | 1 or 0 | float                     |
% +--------+--------+--------+--------+---------------------------+
schedule = struct();
schedule.schedule_training = [...
    repmat([1,0,0,1,high_reward],12,1);... % high
    repmat([0,1,0,1,low_reward],12,1);... % low
    repmat([0,0,1,1,high_reward],6,1);... % NP-high
    repmat([0,0,1,1,low_reward],6,1);... % NP-low
    ]; % thesis : 36 trials x13 blocks = 468 trials --> 36 trial set * 13 
schedule.schedule_training_repeat = 13;
schedule.schedule_training_N = size(schedule.schedule_training,1) * schedule.schedule_training_repeat;


%% Linear Transformation Parameter
% experiment specific range for matching V to RT or score difference from the experiment
ltp_lowerbound = [-40, -40];
ltp_upperbound = [+40, +40];
ltp_x0 = [0, 30]; % rule of thumb 






