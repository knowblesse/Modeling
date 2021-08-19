function sim = JModel(schedule)
%% Output Values
V = zeros(size(schedule,1),3);
alpha = zeros(size(schedule,1),3);
J = zeros(size(schedule,1),3);
V_pos = zeros(size(schedule,1),3);
V_bar = zeros(size(schedule,1),3);
p = zeros(size(schedule,1),3);
%% Parameters
S = 1;
beta_ex = 0.1;
beta_in= 0.09;
gamma= 0.5;
baseline = 0.2;
minimum_p = 0.01;

%% Run
for t = 1 : size(schedule,1)
    CS = schedule(t,1:3);
    US = schedule(t,4);

    V_dot = V_pos(t,:) - V_bar(t,:);
    Lambda = US .* schedule(t,5);
    Lambda_bar = sum(CS .* V_dot) - Lambda;

    p(t,:) = max(1 - abs(min(max(CS .* V_dot,0),1) - Lambda), minimum_p);
    
    J(t+1,:) = t/(t+1).*J(t,:) - 1/(t+1).*log2(p(t,:));

    % alpha change
    if t == 1
        oldAlpha = alpha(1,:);
    else
        oldAlpha = alpha(t-1,:);
    end
    newAlpha = gamma * J(t,:) + baseline;
    newAlpha = min(max(newAlpha,[0,0,0]),[1,1,1]);%limit alpha to [0,1] 
    
    % update alpha when CS is present
    for s = 1 : 3
        if CS(s)
            alpha(t,s) = newAlpha(s);
        else
            alpha(t,s) = oldAlpha(s);
        end
    end

    % V change
%     deltaV_pos = [0, 0, 0];
%     deltaV_bar = [0, 0, 0];
%     if Lambda - sum(CS .* V_dot) > 0
%         deltaV_pos = CS .* S .* alpha(t,:) .* beta_ex .* Lambda;
%     else
%         deltaV_bar = CS .* S .* alpha(t,:) .* beta_in .* Lambda_bar;
%     end
    deltaV_pos = CS .* S .* alpha(t,:) .* beta_ex .* Lambda;
    deltaV_bar = CS .* S .* alpha(t,:) .* beta_in .* Lambda_bar;
    V(t,:) = V_dot;
    V_pos(t+1,:) = V_pos(t,:) + deltaV_pos;
    V_bar(t+1,:) = V_bar(t,:) + deltaV_bar;
end

%% Output Result
sim = struct();
sim.V = V;
sim.alpha = alpha;
sim.J = J;
sim.V_pos = V_pos;
sim.V_bar = V_bar;
sim.p = p;
end
