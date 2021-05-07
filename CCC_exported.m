function app = CCC_exported(schedule, mode)
%% Classical Conditioning Closet Core
% Description :
%       The Core script of the Classical Conditioning Closet App for testing purpose 
% Author : 
%       2021 Knowblesse
% 

%% Parameters
app = struct();
% Rescorla-Wager Model
app.paramRW_lr_acq.Value = 0.1;%
app.paramRW_lr_ext.Value = 0.05;%

% Mackintosh Model
app.paramM_lr_acq.Value = 0.1;
app.paramM_lr_ext.Value = 0.05;
app.paramM_k.Value = 0.01;
app.paramM_e.Value = 0.02;

% Pearson-Hall Model
app.paramPH_SA.Value = 0.02;
app.paramPH_SB.Value = 0.02;
app.paramPH_SC.Value = 0.02;

% Esber Haselgrove Model
app.paramEH_lr1_acq.Value = 0.07; % lr1 : when delta V >= 0 
app.paramEH_lr2_acq.Value = 0.01; % Phi(2 acq lr) must be larger than Phi(2 ext lr)
app.paramEH_lr1_ext.Value = 0.05;
app.paramEH_lr2_ext.Value = 0.01;
app.paramEH_k.Value = 0.2;
app.paramEH_lr_pre.Value = 0.02;
app.paramEH_limitV.Value = false;

% Schmajuk-Pearson-Hall Model
app.paramSPH_SA.Value = 0.3;
app.paramSPH_SB.Value = 0.3;
app.paramSPH_SC.Value = 0.3;
app.paramSPH_beta_ex.Value = 0.1;
app.paramSPH_beta_in.Value = 0.05;
app.paramSPH_gamma.Value = 0.1;

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
app.ModelButtonGroup = struct();


%% Helper Function
app.ModelButtonGroup.SelectedObject = struct();
switch(mode)
    case(1)
        app.ModelButtonGroup.SelectedObject.Text = 'Rescorla-Wagner';
    case(2)
        app.ModelButtonGroup.SelectedObject.Text = 'Mackintosh';
    case(3)
        app.ModelButtonGroup.SelectedObject.Text = 'Schmajuk-P-H';
    case(4)
        app.ModelButtonGroup.SelectedObject.Text = 'Esber-Haselgrove';
end


%% Run
app.V = zeros(size(schedule,1)+1,3);
app.V_pos = zeros(size(schedule,1)+1,3); % V value for S-P-H model, V_dot(=V_pos - V_bar) is assigned to V instead
app.V_bar = zeros(size(schedule,1)+1,3);
app.alpha = zeros(size(schedule,1)+1,3);
app.numTrial = 1;

% Schedule
% +------+------+------+------+----------+---------+---------+--------+
% | Col1 | Col2 | Col3 | Col4 |   Col5   |  Col6   |  Col7   |  Col8  |
% +------+------+------+------+----------+---------+---------+--------+
% | CS A | CS B | CS C | US   | alpha A  | alpha B | alpha C | lambda |
% +------+------+------+------+----------+---------+---------+--------+

selectedButton = app.ModelButtonGroup.SelectedObject;
switch(selectedButton.Text)
    case('Rescorla-Wagner')
        app.TabGroup.SelectedTab = app.Tab_RW;
        app.alpha(1,:) = schedule(1,5:7);
        % Do Simulation
        for t = 1 : size(schedule,1)
            CS = schedule(t,1:3);
            US = schedule(t,4);

            Vtot = sum(app.V(t,:) .* CS);

            Lambda = US .* schedule(t,8);

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
        app.alpha(1,:) = schedule(1,5:7);
        for t = 1 : size(schedule,1)
            CS = schedule(t,1:3);
            US = schedule(t,4);

            Vtot = sum(app.V(t,:) .* CS);

            Lambda = US .* schedule(t,8);

            if schedule(t,4) ~= 0 % US
                lr = app.paramM_lr_acq.Value;
            else
                lr = app.paramM_lr_ext.Value;
            end

            deltaV = app.alpha(t,:) .* CS .* lr .* (Lambda - app.V(t,:)); % not Vtot

            % alpha change
            deltaAlpha = CS * app.paramM_k.Value .* (abs(Lambda - (Vtot - app.V(t,:))) - abs(Lambda - app.V(t,:)));
            newAlpha = min(max(app.alpha(t,:) + deltaAlpha,[0,0,0]),[1,1,1]); % alpha value should be in range [0,1]

            app.V(t + 1,:) = app.V(t,:) + deltaV;
            app.alpha(t + 1, :) =newAlpha;
        end
    case('Pearson-Hall')
        app.TabGroup.SelectedTab = app.Tab_PH;
        % Do Simulation
        app.alpha(1,:) = schedule(1,5:7);
        for t = 1 : size(schedule,1)
            CS = schedule(t,1:3);
            US = schedule(t,4);
            S = [app.paramPH_SA.Value, app.paramPH_SB.Value, app.paramPH_SC.Value];

            V_pos_tot = sum(app.V_pos(t,:) .* CS);
            V_bar_tot = sum(app.V_bar(t,:) .* CS);

            Lambda = US .* schedule(t,8);
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
        app.alpha(1,:) = schedule(1,5:7);
        phi = schedule(1,5:7);
        V_pre = [0, 0, 0];
        for t = 1 : size(schedule,1)
            CS = schedule(t,1:3);
            US = schedule(t,4);

            V_pos_tot = sum(app.V_pos(t,:) .* CS);
            V_bar_tot = sum(app.V_bar(t,:) .* CS);

            Lambda = US .* schedule(t,8);

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
        app.alpha(1,:) = schedule(1,5:7);
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
            Lambda = US .* schedule(t,8);
            Lambda_bar = sum(CS .* V) - Lambda;

            % alpha change
            if(t == 1) % if the first trial, use the initial value, not t-1
                newAlpha = app.paramSPH_gamma.Value * abs(Lambda) + (1-app.paramSPH_gamma.Value) * app.alpha(1,:);
            else
                newAlpha = app.paramSPH_gamma.Value * abs(Lambda - sum(CS .* app.V(t-1,:))) + (1-app.paramSPH_gamma.Value) * app.alpha(t-1,:);
            end
            newAlpha = min(max(...
                newAlpha,[0,0,0]),[1,1,1]); % alpha value should be in range [0,1]. // Really??
            app.alpha(t, :) = newAlpha;

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
end
end       

