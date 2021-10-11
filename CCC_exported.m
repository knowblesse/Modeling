function app = CCC_exported(schedule, mode, initial_alpha, app_custom)
%% Classical Conditioning Closet Core
% Description :
%       The Core script of the Classical Conditioning Closet App for testing purpose 
% Author : 
%       2021 Knowblesse
% 

%% Parameters
app = struct();

app.alpha_A.Value = initial_alpha(1);
app.alpha_B.Value = initial_alpha(2);
app.alpha_C.Value = initial_alpha(3);

% Rescorla-Wager Model
app.paramRW_lr_acq.Value = 0.1;
app.paramRW_lr_ext.Value = 0.05;

% Mackintosh Model
app.paramM_lr_acq.Value = 0.08;
app.paramM_lr_ext.Value = 0.04;
app.paramM_k.Value = 0.05;
app.paramM_epsilon.Value = 0.02;

% Pearce-Hall Model
app.paramPH_SA.Value = 0.04;
app.paramPH_SB.Value = 0.04;
app.paramPH_SC.Value = 0.04;

% Esber Haselgrove Model
app.paramEH_lr1_acq.Value = 0.05; % lr1 : when delta V >= 0 
app.paramEH_lr2_acq.Value = 0.03; % product of two acq lr > product of two ext lr
app.paramEH_lr1_ext.Value = 0.04;
app.paramEH_lr2_ext.Value = 0.02;
app.paramEH_k.Value = 0.2;
app.paramEH_lr_pre.Value = 0.02;
app.paramEH_limitV.Value = false;

% Schmajuk-Pearson-Hall Model
app.paramSPH_SA.Value = 0.3;
app.paramSPH_SB.Value = 0.3;
app.paramSPH_SC.Value = 0.3;
app.paramSPH_beta_ex.Value = 0.1;
app.paramSPH_beta_in.Value = 0.09;
app.paramSPH_gamma.Value = 0.2;

% TD Model
app.paramTD_table.Data = table(1,4,1,4,1,4,9,10,50);
app.paramTD_beta.Value = 0.875;
app.paramTD_c.Value = 0.08;
app.paramTD_gamma.Value = 0.95;

% Jeong Model
app.paramJ_SA.Value = 1;
app.paramJ_SB.Value = 1;
app.paramJ_SC.Value = 1;
app.paramJ_beta_ex.Value = 0.1;
app.paramJ_beta_in.Value = 0.09;
app.paramJ_gamma.Value = 0.5; % Effect of J to alpha
app.paramJ_baseline.Value = 0.2; % Minimum alpha
app.paramJ_minimum_p.Value = 0.01; % minimum prob of event

if exist('app_custom','var')
    app = app_custom;
end

%% Experiement Variables
app.V = zeros(1000,3);
app.V_pos = zeros(1000,3); % V value for S-P-H model, V_dot(=V_pos - V_bar) is assigned to V instead
app.V_bar = zeros(1000,3);
app.alpha = zeros(1000,3);
app.numTrial = 1;

%% Meaningless code snippet for smooth importing appdesigner-based GUI code to CUI code 
app.Tab_RW = [];
app.Tab_M = [];
app.Tab_PH = [];
app.Tab_EH = [];
app.Tab_SPH = [];
app.Tab_TD = [];
app.Tab_J = [];
app.ModelButtonGroup = struct();


%% Helper Function
app.ModelButtonGroup.SelectedObject = struct();
switch(mode)
    case(1)
        app.ModelButtonGroup.SelectedObject.Text = 'Rescorla-Wagner';
    case(2)
        app.ModelButtonGroup.SelectedObject.Text = 'Mackintosh';
    case(3)
        app.ModelButtonGroup.SelectedObject.Text = 'Pearce-Hall';
    case(4)
        app.ModelButtonGroup.SelectedObject.Text = 'Esber-Haselgrove';
    case(5)
        app.ModelButtonGroup.SelectedObject.Text = 'Temporal-Difference';
    case(6)
        app.ModelButtonGroup.SelectedObject.Text = 'Schmajuk-P-H';
    case(7)
        app.ModelButtonGroup.SelectedObject.Text = 'Jeong';
end


%% Run
app.V = zeros(size(schedule,1)+1,3);
app.V_pos = zeros(size(schedule,1)+1,3); % V value for S-P-H model, V_dot(=V_pos - V_bar) is assigned to V instead
app.V_bar = zeros(size(schedule,1)+1,3);
app.alpha = zeros(size(schedule,1)+1,3);
app.numTrial = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%CCC_exported Start %%%%%%%%%%%%%%%%%%%%%%%%%%
% Schedule
% +------+------+------+------+--------+
% | Col1 | Col2 | Col3 | Col4 |  Col5  |
% +------+------+------+------+--------+
% | CS A | CS B | CS C |  US  | lambda |
% +------+------+------+------+--------+
if isempty(schedule)
    msgbox('Empty Schedule');
else
    selectedButton = app.ModelButtonGroup.SelectedObject;
    switch(selectedButton.Text)
        case('Rescorla-Wagner')
            app.TabGroup.SelectedTab = app.Tab_RW;
            app.alpha(1,:) = [app.alpha_A.Value, app.alpha_B.Value, app.alpha_C.Value];
            % Do Simulation
            for t = 1 : size(schedule,1)
                CS = schedule(t,1:3);
                US = schedule(t,4);

                Vtot = sum(app.V(t,:) .* CS);

                Lambda = US .* schedule(t,5);

                if schedule(t,4) ~= 0 % US
                    lr = app.paramRW_lr_acq.Value;
                else
                    lr = app.paramRW_lr_ext.Value;
                end

                deltaV = app.alpha(t,:) .* CS .* (lr .* (Lambda - Vtot));

                app.V(t + 1,:) = app.V(t,:) + deltaV;
                app.alpha(t + 1, :) = app.alpha(t,:);
            end
        case('Mackintosh')
            app.TabGroup.SelectedTab = app.Tab_M;
            % Do Simulation
            app.alpha(1,:) = [app.alpha_A.Value, app.alpha_B.Value, app.alpha_C.Value];
            for t = 1 : size(schedule,1)
                CS = schedule(t,1:3);
                US = schedule(t,4);

                Vtot = sum(app.V(t,:) .* CS);

                Lambda = US .* schedule(t,5);

                if schedule(t,4) ~= 0 % US
                    lr = app.paramM_lr_acq.Value;
                else
                    lr = app.paramM_lr_ext.Value;
                end

                deltaV = app.alpha(t,:) .* CS .* lr .* (Lambda - app.V(t,:)); % not Vtot

                % alpha change
                deltaAlpha = [0, 0, 0];
                for s = 1 : 3
                    D_x = abs(Lambda - (Vtot - app.V(t,s)));
                    D_s = abs(Lambda - app.V(t,s));
                    if D_s < D_x
                        deltaAlpha(s) = CS(s) * app.paramM_k.Value * (1-app.alpha(t,s)) * (D_x - D_s) / 2;
                    elseif D_s == D_x
                        deltaAlpha(s) = -1 * CS(s) * app.paramM_k.Value * app.paramM_epsilon.Value;
                    else
                        deltaAlpha(s) = CS(s) * app.paramM_k.Value * app.alpha(t,s) * (D_x - D_s) / 2;
                    end
                end

                app.V(t + 1,:) = app.V(t,:) + deltaV;
                app.alpha(t + 1, :) = app.alpha(t,:) + deltaAlpha;
            end
        case('Pearce-Hall')
            app.TabGroup.SelectedTab = app.Tab_PH;
            % Do Simulation
            app.alpha(1,:) = [app.alpha_A.Value, app.alpha_B.Value, app.alpha_C.Value];
            for t = 1 : size(schedule,1)
                CS = schedule(t,1:3);
                US = schedule(t,4);
                S = [app.paramPH_SA.Value, app.paramPH_SB.Value, app.paramPH_SC.Value];

                V_pos_tot = sum(app.V_pos(t,:) .* CS);
                V_bar_tot = sum(app.V_bar(t,:) .* CS);

                Lambda = US .* schedule(t,5);
                Lambda_bar = (V_pos_tot - V_bar_tot) - Lambda;

                deltaV_pos = CS .* S .* app.alpha(t,:) .* Lambda;
                deltaV_bar = CS .* S .* app.alpha(t,:) .* Lambda_bar;

                % alpha change
                newAlpha = repmat(abs(Lambda - (V_pos_tot - V_bar_tot)),1,3);

                app.V(t,:) = app.V_pos(t,:) - app.V_bar(t,:);
                app.V_pos(t+1,:) = app.V_pos(t,:) + deltaV_pos;
                app.V_bar(t+1,:) = app.V_bar(t,:) + deltaV_bar;
                app.alpha(t+1,:) = newAlpha;
            end
        case('Esber-Haselgrove')
            app.TabGroup.SelectedTab = app.Tab_EH;

            % Do Simulation
            app.alpha(1,:) = [app.alpha_A.Value, app.alpha_B.Value, app.alpha_C.Value];
            phi = [app.alpha_A.Value, app.alpha_B.Value, app.alpha_C.Value];
            V_pre = [0, 0, 0];
            for t = 1 : size(schedule,1)
                CS = schedule(t,1:3);
                US = schedule(t,4);

                V_pos_tot = sum(app.V_pos(t,:) .* CS);
                V_bar_tot = sum(app.V_bar(t,:) .* CS);

                Lambda = US .* schedule(t,5);

                newAlpha = phi + (app.V_pos(t,:) + app.V_bar(t,:)) - app.paramEH_k.Value * V_pre;

                if((Lambda - (V_pos_tot - V_bar_tot)) > 0)
                    beta_pos = app.paramEH_lr1_acq.Value;
                    beta_bar = app.paramEH_lr2_acq.Value;
                else
                    beta_pos = app.paramEH_lr1_ext.Value;
                    beta_bar = app.paramEH_lr2_ext.Value;
                end
                deltaV_pos = CS .* newAlpha .* beta_pos .* (Lambda - (V_pos_tot - V_bar_tot));
                deltaV_bar = CS .* newAlpha .* beta_bar .* ((V_pos_tot - V_bar_tot) - Lambda);

                app.V(t,:) = app.V_pos(t,:) - app.V_bar(t,:);

                if app.paramEH_limitV.Value
                    app.V_pos(t+1,:) = min(max(app.V_pos(t,:) + deltaV_pos,[0,0,0]),[1,1,1]);
                    app.V_bar(t+1,:) = min(max(app.V_bar(t,:) + deltaV_bar,[0,0,0]),[1,1,1]);
                else
                    app.V_pos(t+1,:) = app.V_pos(t,:) + deltaV_pos;
                    app.V_bar(t+1,:) = app.V_bar(t,:) + deltaV_bar;
                end
                app.alpha(t,:) = newAlpha;
                V_pre = V_pre + app.paramEH_lr_pre.Value * (CS - V_pre);
            end

        case('Schmajuk-P-H')
            app.TabGroup.SelectedTab = app.Tab_SPH;

            % Do Simulation
            app.alpha(1,:) = [app.alpha_A.Value, app.alpha_B.Value, app.alpha_C.Value];
            S = [app.paramSPH_SA.Value, app.paramSPH_SB.Value, app.paramSPH_SC.Value];
            for t = 1 : size(schedule,1)
                CS = schedule(t,1:3);
                US = schedule(t,4);

                % In the original paper, V_dot is used as exert
                % conditioned response and V_dot = V - N.
                % In this program these variable is translated into
                % below
                % V_dot => V
                % V => V_pos
                % N => V_bar
                V = app.V_pos(t,:) - app.V_bar(t,:);
                Lambda = US .* schedule(t,5);
                Lambda_bar = sum(CS .* V) - Lambda;

                % alpha change
                if(t == 1) % if the first trial, use the initial value, not t-1
                    newAlpha = app.paramSPH_gamma.Value * abs(Lambda) + (1-app.paramSPH_gamma.Value) * app.alpha(1,:);
                    oldAlpha = app.alpha(1,:);
                else
                    newAlpha = app.paramSPH_gamma.Value * abs(Lambda - sum(CS .* app.V(t-1,:))) + (1-app.paramSPH_gamma.Value) * app.alpha(t-1,:);
                    oldAlpha = app.alpha(t-1,:);
                end
                newAlpha = min(max(...
                    newAlpha,[0,0,0]),[1,1,1]); % alpha value should be in range [0,1]. // Really??
                for s = 1 : 3
                    if CS(s)
                        app.alpha(t,s) = newAlpha(s);
                    else
                        app.alpha(t,s) = oldAlpha(s);
                    end
                end

                % V change
                deltaV_pos = [0, 0, 0];
                deltaV_bar = [0, 0, 0];

                if Lambda - sum(CS .* V) > 0
                    deltaV_pos = CS .* S .* app.alpha(t,:) .* app.paramSPH_beta_ex.Value .* Lambda;
                else
                    deltaV_bar = CS .* S .* app.alpha(t,:) .* app.paramSPH_beta_in.Value .* Lambda_bar;
                end
                app.V(t,:) = V;
                app.V_pos(t+1,:) = app.V_pos(t,:) + deltaV_pos;
                app.V_bar(t+1,:) = app.V_bar(t,:) + deltaV_bar;
            end
        case('Temporal-Difference')
            app.TabGroup.SelectedTab = app.Tab_TD;
            %% Parameters
            % A Start | A End | B Start | B End | C Start | C End | US Start | US End | ITI

            %% Stretch the schedule to include time factor
            trial_length = max(app.paramTD_table.Data{1,1:8}) + app.paramTD_table.Data{1,9};% max cs end + iti
            newSchedule = zeros(trial_length * size(schedule, 1),5);
            for s = 1 : size(schedule,1)
                temp = zeros(trial_length, 5);
                temp(app.paramTD_table.Data{1,1} : app.paramTD_table.Data{1,2},1) = 1 * schedule(s,1);
                temp(app.paramTD_table.Data{1,3} : app.paramTD_table.Data{1,4},2) = 1 * schedule(s,2);
                temp(app.paramTD_table.Data{1,5} : app.paramTD_table.Data{1,6},3) = 1 * schedule(s,3);
                temp(app.paramTD_table.Data{1,7} : app.paramTD_table.Data{1,8},4) = 1 * schedule(s,4);
                temp(:,5) = schedule(s,5);
                newSchedule(trial_length*(s-1)+1 : trial_length*s,:) = temp;
            end
            clearvars temp

            %% Initialize
            totalTime = size(newSchedule,1);
            y = zeros(totalTime,1);
            r = zeros(totalTime,1);
            x_bar = zeros(totalTime,3);
            x = zeros(totalTime,3);
            w = zeros(totalTime,3);

            %% Do Simulation
            trial = 1;
            for t = 1 : size(newSchedule,1)
                US_weight = newSchedule(t,5);
                US_presence = newSchedule(t,4);
                x(t,:) = newSchedule(t,1:3);
                r(t) = US_weight * US_presence;
                y(t) = r(t) + max(w(t,:) * x(t,:)',0);
                if t == 1
                    x_bar(t,:) = 0; %eligibility traces
                    w(t+1,:) = w(t,:) + app.paramTD_c.Value*(r(t) + app.paramTD_gamma.Value*max(w(t,:) * x(t,:)',0) )*x_bar(t,:);
                else
                    x_bar(t,:) = app.paramTD_beta.Value .* x_bar(t-1,:) + (1-app.paramTD_beta.Value) .* x(t-1,:); %eligibility traces
                    w(t+1,:) = w(t,:) + app.paramTD_c.Value.*(...
                        r(t) + app.paramTD_gamma.Value .* max(w(t,:) * x(t,:)',0) - max(w(t,:) * x(t-1,:)',0)...
                        )*x_bar(t,:); % during the CS presentaion, gamma value makes the delta w negative proportional to it's weight.
                end

                if rem(t, trial_length) == 0
                    app.V(trial,:) = w(t,:); % save the last weight value from every trial as V
                    trial = trial + 1;
                end
            end
            t = trial;
        case('Jeong')
            app.TabGroup.SelectedTab = app.Tab_J;

            % Do Simulation
            app.alpha(1,:) = [0,0,0];%[app.alpha_A.Value, app.alpha_B.Value, app.alpha_C.Value];
            S = [app.paramJ_SA.Value, app.paramJ_SB.Value, app.paramJ_SC.Value];
            J = zeros(size(schedule,1),3);
            for t = 1 : size(schedule,1)
                CS = schedule(t,1:3);
                US = schedule(t,4);

                V_dot = app.V_pos(t,:) - app.V_bar(t,:);
                Lambda = US .* schedule(t,5);
                Lambda_bar = sum(CS .* V_dot) - Lambda;

                p = max(1 - abs(min(max(CS .* V_dot,0),1) - Lambda), app.paramJ_minimum_p.Value);
            
                J(t+1,:) = t/(t+1).*J(t,:) - 1/(t+1).*log2(p);

                % alpha change
                if t == 1
                    oldAlpha = app.alpha(1,:);
                else
                    oldAlpha = app.alpha(t-1,:);
                end
                newAlpha = app.paramJ_gamma.Value * J(t,:) + app.paramJ_baseline.Value;
                newAlpha = min(max( newAlpha,[0,0,0]),[1,1,1]); 

                % Update alpha only when CS is present
                for s = 1 : 3
                    if CS(s)
                        app.alpha(t,s) = newAlpha(s);
                    else
                        app.alpha(t,s) = oldAlpha(s);
                    end
                end

                % V change
                deltaV_pos = CS .* S .* app.alpha(t,:) .* app.paramJ_beta_ex.Value .* Lambda;
                deltaV_bar = CS .* S .* app.alpha(t,:) .* app.paramJ_beta_in.Value .* Lambda_bar;

                app.V(t,:) = V_dot;
                app.V_pos(t+1,:) = app.V_pos(t,:) + deltaV_pos;
                app.V_bar(t+1,:) = app.V_bar(t,:) + deltaV_bar;
            end
    end
    app.numTrial = t;
    %%%%%%%%%%%%%%%%%%%%%%%%%%CCC_exported End %%%%%%%%%%%%%%%%%%%%%%%%%%
end
end       

