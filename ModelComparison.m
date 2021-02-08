%% Rescorla Wagner Model


%% Constants
lambda = 1;
lr_acq = 0.1;
lr_ext = 0.05;

%% Experiemnt Condition
condition = cell(3);
condition{1} = [ones(100,1), ones(100,1), ones(100,1)];
condition{2} = [ones(100,1), 0.5 * ones(100,1), ones(100,1)];
condition{3} = [repmat([1,0]',50,1), ones(100,1), ones(100,1)];
condition{4} = [ones(100,1), repmat([0.9,0.1]',50,1), ones(100,1)];

%% Run
numTrial = 100;
experiment = condition{4};
V = zeros(numTrial,1);
for i = 1 : numTrial
    if experiment(i,3) == 1 % acq
        deltaV = lr_acq * experiment(i,2) * (lambda - V(i));
    elseif experiment(i,3) == 0 % ext
        deltaV = lr_ext * experiment(i,2) * (lambda - V(i));
    end
    V(i+1) = V(i) + deltaV;
end

plot(V);
%% Mackintosh Model
% Constants
% learning rate AND "stimulus-specific parameter" : alpha.
% this sometimes referred as saliency
alpha = 0.9;

if abs(lambda - Va) < abs(lambda - sum(V)
    deltaAlpha = deltaAlpha * 1.1;
else
    deltaAlpha = deltaAlpha * 0.9;
end

size of change in alpha : 

%% Run
numTrial = 100;
experiment = condition{1};
V = zeros(numTrial,1);
for i = 1 : numTrial
    if experiment(i,3) == 1 % acq
        deltaV = lr_acq * experiment(i,2) * (lambda - V(i));
    elseif experiment(i,3) == 0 % ext
        deltaV = lr_ext * experiment(i,2) * (lambda - V(i));
    end
    if abs(lambda - V(i) < abs(lambda - sum(V(i))
        deltaAlpha  = deltaAlpha * 1.1;
    else
        deltaAlpha = deltaAlpha * 0.9;
    end
    V(i+1) = V(i) + deltaV;
end

%% Pearson Hall
