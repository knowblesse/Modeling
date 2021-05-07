%% TD Model Simulation

%% parameters
CS.length = 4;
US.start = 9; % US must be presented after the CS
US.end = 10; 
ITI = 100;

trial_length = max(CS.length,US.end) + ITI;

%% Schedule

schedule1 = [...
    1,0,0,1,0,0,0,.5;...
    1,0,0,1,0,0,0,.5;...
    ];
schedule = repmat(schedule1,100,1);
schedule = schedule(randperm(size(schedule,1)),:);




% schedule = [...
%     repmat([1,0,0,1,0,0,0,1], 70,1);...
%     %repmat([1,0,0,0,0,0,0,1], 100,1)...
%     ];

%% Second-order conditioning
CS1_first = [...
    repmat([0,1,0,0,0,0,0,0], 8, 1);...
    repmat([0,0,0,0,0,0,0,0], 4, 1);...
    repmat([1,0,0,0,0,0,0,0], 8, 1);...
    repmat([0,0,0,0,0,0,0,0], trial_length-20, 1)...
    ];

%% Generate new Schedule including time factor
newSchedule = zeros(trial_length * size(schedule,1),8);
w_trial = zeros(size(schedule,1),3);
for s = 1 : size(schedule,1)
    temp = zeros(trial_length,8);
    temp(1:CS.length,[1,2,3,5,6,7]) = repmat(schedule(s,[1,2,3,5,6,7]),CS.length,1);
    temp(US.start:US.end,[4,8]) = repmat(schedule(s,[4,8]),US.end-US.start+1,1);
    newSchedule(trial_length*(s-1)+1 : trial_length*s,:) = temp;
end
clearvars temp

% newSchedule = [...
%     newSchedule;...
%     repmat(CS1_first,50,1)...
%     ];

%% Run
totalTime = size(newSchedule,1);

% The parameter that the original thesis (Sutton & Barto, 1987) used c=0.01, 
% but this does not fit with the simulated data. And also, similar model
% (SBmodel by Sutton & Barto, 1981) uses c values a way over .01.
% So I used c=0.1
beta = 0.8;
c = 0.1; 
gamma = 0.95;

% Initialize
y = zeros(totalTime,1);
r = zeros(totalTime,1);
x_bar = zeros(totalTime,3);
x = zeros(totalTime,3);
w = zeros(totalTime,3);
w(1,:) = newSchedule(1,5:7);
test_v = zeros(totalTime,1);

trial = 1;
for t = 1 : size(newSchedule,1)
    US_weight = newSchedule(t,8);
    US_presence = newSchedule(t,4);
    x(t,:) = newSchedule(t,1:3);
    r(t) = US_weight * US_presence;
    y(t) = r(t) + max(w(t,:) * x(t,:)',0);
    if t == 1
        x_bar(t,:) = 0; %eligibility traces
        w(t+1,:) = w(t,:) + c*(r(t) + gamma*max(w(t,:) * x(t,:)',0) )*x_bar(t,:);
        test_v(t) = r(t) + gamma .* max(w(t,:) * x(t,:)',0);
    else
        x_bar(t,:) = beta .* x_bar(t-1,:) + (1-beta) .* x(t-1,:); %eligibility traces
        w(t+1,:) = w(t,:) + c.*(...
            r(t) + gamma .* max(w(t,:) * x(t,:)',0) - max(w(t,:) * x(t-1,:)',0)...
            )*x_bar(t,:); % during the CS presentaion, gamma value makes the delta w negative proportional to it's weight.
        test_v(t) = r(t) + gamma .* max(w(t,:) * x(t,:)',0) - max(w(t,:) * x(t-1,:)',0);
    end
    
    if rem(t, trial_length) == 0
        w_trial(trial,:) = w(t,:);
        trial = trial + 1;
    end
end
fprintf('%.2f, %.2f %.2f\n',w(end,:))

%% Plot
plot_range.start = 1;
plot_range.end = size(schedule,1);

%% Plot All 
figure(2);
%clf;
subplot(5,1,1);
hold on;

c_blue = [0.507,0.789,0.984];
c_green = [0.465,0.827,0.402];

plot(x(trial_length*(plot_range.start-1)+1:trial_length*plot_range.end,1),'Color',c_blue);
plot(x(trial_length*(plot_range.start-1)+1:trial_length*plot_range.end,2),'Color',c_green);
plot(newSchedule(trial_length*(plot_range.start-1)+1:trial_length*plot_range.end,4),'r');
title('CS/US');
legend({'CS1','CS2','US'});

subplot(5,1,2);
hold on;
plot(x_bar(trial_length*(plot_range.start-1)+1:trial_length*plot_range.end,1),'Color',c_blue);
plot(x_bar(trial_length*(plot_range.start-1)+1:trial_length*plot_range.end,2),'Color',c_green);
title('CS bar');
legend({'CS1','CS2'});

subplot(5,1,3);
plot(y(trial_length*(plot_range.start-1)+1:trial_length*plot_range.end));
title('y');

subplot(5,1,4:5);
%plot(w(1:plot_range,1));
hold on;
line = plot(...
    trial_length * (plot_range.start-1) + 1 : trial_length : trial_length * plot_range.end,...
    w_trial(plot_range.start:plot_range.end,:));
line(1).Color = c_blue;
line(1).LineWidth = 2;
line(2).Color = c_green;
line(2).LineWidth = 2;
xticks(trial_length * (plot_range.start-1) + 1 : trial_length*5 : trial_length * plot_range.end);
xticklabels(plot_range.start:5:plot_range.end);
title('w');
xlabel('trial');
ylabel('w');
legend({'CS1','CS2','CS3'});
%plot(w(trial_length*(plot_range.start-1)+1:trial_length*plot_range.end,1));