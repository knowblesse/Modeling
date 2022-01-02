%% Anderson_2011;
% Experiment Setup for Anderson 2011

%% Experiment Data
RT_none.T1008 = 665;
RT_low.T1008 = 673;
RT_high.T1008 = 681;

Exp_high_mean = RT_high.T1008 - RT_none.T1008;
Exp_high_sd = 2.8;
Exp_low_mean = RT_low.T1008 - RT_none.T1008;
Exp_low_sd = 2.8;

exp1_high_reward = 1; %5 cents
exp1_low_reward = 0.2; %1 cents

%% Experiment Schedule
% +--------+--------+--------+--------+---------------------------+
% | CS1    | CS2    | CS3    | US     | US intensity(reward size) |
% +--------+--------+--------+--------+---------------------------+
% | 1 or 0 | 1 or 0 | 1 or 0 | 1 or 0 | float                     |
% +--------+--------+--------+--------+---------------------------+
schedule = struct();
schedule.schedule_training = [...
    repmat([1,0,0,1,exp1_high_reward],4,1);...
    repmat([1,0,0,1,exp1_low_reward],1,1);...
    repmat([0,1,0,1,exp1_high_reward],1,1);...
    repmat([0,1,0,1,exp1_low_reward],4,1);...
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

%% Linear Transformation Parameter
% experiment specific range for matching V to RT or score difference from the experiment
ltp_lowerbound = [-30, -30];
ltp_upperbound = [+30, +30];
ltp_x0 = [5, 25]; % rule of thumb 
