%% TD Model Simulation


%% parameters
CS.length = 4;
US.start = 9;
US.end = 10;
ITI = 100;

%% dependent parameters
Trial_length = CS.length + ITI;

%% Schedule
schedule = [...
    repmat([1,0,0,1,0,0,0,1], 70,1)...
    ];

%% Second-order conditioning
CS1_first = [...
    repmat([0,1,0,0,0,0,0,0], 4, 1);...
    repmat([0,0,0,0,0,0,0,0], 3, 1);...z
    repmat([1,0,0,0,0,0,0,0], 4, 1);...
    repmat([0,0,0,0,0,0,0,0], 49, 1)...
    ];

%% Generate new Schedule including time factor

newSchedule = zeros(Trial_length * size(schedule,1),8);
w_trial = zeros(size(schedule,1),3);
for s = 1 : size(schedule,1)
    newSchedule(Trial_length*(s-1)+1 : Trial_length*s,:) = [...
        repmat([schedule(s,1:3),0,schedule(s,5:8)],CS.length,1);...
        repmat([zeros(1,4),schedule(s,5:8)],ITI,1)];
    newSchedule(Trial_length*(s-1)+US.start:Trial_length*(s-1)+US.end,4) = schedule(s,4);
end

%% Run
totalTime = size(newSchedule,1);
beta = 0.8;
c = 0.01;
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
            )*x_bar(t,:);
        test_v(t) = r(t) + gamma .* max(w(t,:) * x(t,:)',0) - max(w(t,:) * x(t-1,:)',0);
    end
    
    if rem(t, Trial_length) == 0
        w_trial(trial,:) = w(t,:);
        trial = trial + 1;
    end
end
fprintf('%.2f, %.2f %.2f\n',w(end,:))

%% Plot
%plot_range = size(newSchedule,1);
plot_range = Trial_length * 3;

%% Plot All 
figure(1);
clf;
subplot(5,1,1);
hold on;
plot(x(1:plot_range,1),'b');
plot(newSchedule(1:plot_range,4),'r');
title('CS/US');

subplot(5,1,2);
plot(x_bar(1:plot_range,1));
title('CS bar');

subplot(5,1,3);
plot(y(1:plot_range));
title('y');

subplot(5,1,4);
plot(test_v(1:plot_range,1));
title('test v');

subplot(5,1,5);
plot(w(1:plot_range,1));
hold on;
plot(Trial_length:Trial_length:plot_range,w_trial(1:plot_range/Trial_length,:));
xticks(Trial_length:Trial_length*5:plot_range);
xticklabels(1:5:plot_range/Trial_length);
title('w');

