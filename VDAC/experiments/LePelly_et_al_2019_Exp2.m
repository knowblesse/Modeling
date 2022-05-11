%% LePelly_et_al_2019_Exp2
% LePelly et al. 2019 Exp2  simulation

%% Experiment Data
RT_P = 15.76;
RT_NP = 19.05;

Exp_high_mean = RT_NP;
Exp_low_mean = RT_P;

high_reward = 1; % 100 points
low_reward = 0.5; % 50 points

%% Experiment Schedule
% +--------+--------+--------+--------+---------------------------+
% | CS1    | CS2    | CS3    | US     | US intensity(reward size) |
% +--------+--------+--------+--------+---------------------------+
% | 1 or 0 | 1 or 0 | 1 or 0 | 1 or 0 | float                     |
% +--------+--------+--------+--------+---------------------------+
schedule = struct();
schedule.schedule_testing{1} = [...
    repmat([1,0,0,1,high_reward],9,1);... % NP-high
    repmat([1,0,0,0,0],9,1);... % NP-low    
    repmat([0,1,0,1,low_reward],18,1);... % P
    ]; % 36 trials x 5 blocks
schedule.schedule_testing_repeat{1} = 5;
schedule.schedule_testing{2} = [...
    repmat([1,0,0,1,high_reward],7,1);... % NP : high
    repmat([1,0,0,0,0],7,1);... % NP : low
    repmat([0,1,0,1,low_reward],14,1);... % P
    repmat([1,1,0,1,low_reward],8,1);... % P + NP : 50 points(low)
    ]; % 36 trials x (8 blocks(day1) + 13 blocks(day2)
schedule.schedule_testing_repeat{2} = 21;
schedule.schedule_testing_N = 36*5 + 36*21;