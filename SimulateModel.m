function [outV, outAlpha] = SimulateModel(schedule, model, param)
%% SimulateModel
% Description :
%       Associative learning model simulation script
% Author : 
%       2021 Knowblesse
% 
% TODO : make faster. eliminate all sturct variables and don't use sum or .* functions
%% Parameters
if ~exist('param','var')
    param = getDefaultParam();
end

%% Experiement Variables
numTrial = size(schedule,1);
outV = zeros(numTrial,3);
outV_pos = zeros(numTrial,3); % V value for S-P-H model, V_dot(=V_pos - V_bar) is assigned to V instead
outV_bar = zeros(numTrial,3);
outAlpha = zeros(numTrial,3);
outAlpha(1,:) = [param.alpha0.a, param.alpha0.b, param.alpha0.c];
%% Run
% Schedule
% |------+------+------+------+--------|
% | Col1 | Col2 | Col3 | Col4 | Col5   |
% |------+------+------+------+--------|
% | CS A | CS B | CS C | US   | lambda |
% |------+------+------+------+--------|
% | bool | bool | bool | bool | double |
% |------+------+------+------+--------|

switch(model)
    case{'Rescorla-Wagner','RW'}
        for t = 1 : size(schedule,1)
            CS = schedule(t,1:3);
            US = schedule(t,4);

            Vtot = sum(outV(t,:) .* CS);

            Lambda = US .* schedule(t,5);

            if schedule(t,4) ~= 0 % US
                lr = param.RW.lr_acq.value;
            else
                lr = param.RW.lr_ext.value;
            end

            deltaV = outAlpha(t,:) .* CS .* (lr .* (Lambda - Vtot));

            outV(t + 1,:) = outV(t,:) + deltaV;
            outAlpha(t + 1, :) = outAlpha(t,:);
        end
    case{'Mackintosh', 'M'}
        % lr_acq, lr_ext, k, epsilon
        parameter = [param.M.lr_acq.value, param.M.lr_ext.value, param.M.k.value, param.M.epsilon.value];
        for t = 1 : size(schedule,1)
            
            CS = [schedule(t,1), schedule(t,2), schedule(t,3)];
            US = schedule(t,4);
            
            prevV = outV(t,:);
            prevAlpha = outAlpha(t,:);

            %Vtot = sum(prevV .* CS);
            Vtot = prevV(1) * CS(1) + prevV(2) * CS(2) + prevV(3) * CS(3);

            Lambda = US .* schedule(t,5);

            if schedule(t,4) ~= 0 % US
                lr = parameter(1);
            else
                lr = parameter(2);
            end

            deltaV = prevAlpha .* CS .* lr .* (Lambda - prevV); % not Vtot

            % alpha change
            deltaAlpha = [0, 0, 0];
            for s = 1 : 3
                D_x = abs(Lambda - (Vtot - prevV(s)));
                D_s = abs(Lambda - prevV(s));
                if D_s < D_x
                    deltaAlpha(s) = CS(s) * parameter(3) * (1-prevAlpha(s)) * (D_x - D_s) / 2;
                elseif D_s == D_x
                    deltaAlpha(s) = -1 * CS(s) * parameter(3) * parameter(4);
                else
                    deltaAlpha(s) = CS(s) * parameter(3) * prevAlpha(s) * (D_x - D_s) / 2;
                end
            end

            outV(t + 1,:) = prevV + deltaV;
            outAlpha(t + 1, :) = prevAlpha + deltaAlpha;
        end

    case{'Pearce-Hall', 'PH'}
        S = [param.PH.SA.value, param.PH.SB.value, param.PH.SC.value];
        for t = 1 : size(schedule,1)
            CS = schedule(t,1:3);
            US = schedule(t,4);

            V_pos_tot = sum(outV_pos(t,:) .* CS);
            V_bar_tot = sum(outV_bar(t,:) .* CS);

            Lambda = US .* schedule(t,5);
            Lambda_bar = (V_pos_tot - V_bar_tot) - Lambda;

            deltaV_pos = CS .* S .* outAlpha(t,:) .* Lambda;
            deltaV_bar = CS .* S .* outAlpha(t,:) .* Lambda_bar;

            % alpha change
            newAlpha = repmat(abs(Lambda - (V_pos_tot - V_bar_tot)),1,3);

            outV(t,:) = outV_pos(t,:) - outV_bar(t,:);
            outV_pos(t+1,:) = outV_pos(t,:) + deltaV_pos;
            outV_bar(t+1,:) = outV_bar(t,:) + deltaV_bar;
            outAlpha(t+1,:) = newAlpha;
        end

    case{'Schmajuk-P-H', 'SPH'}
        S = [param.SPH.SA.value, param.SPH.SB.value, param.SPH.SC.value];
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
            V = outV_pos(t,:) - outV_bar(t,:);
            Lambda = US .* schedule(t,5);
            Lambda_bar = sum(CS .* V) - Lambda;

            % alpha change
            if(t == 1) % if the first trial, use the initial value, not t-1
                newAlpha = param.SPH.gamma.value * abs(Lambda) + (1-param.SPH.gamma.value) * outAlpha(1,:);
                oldAlpha = outAlpha(1,:);
            else
                newAlpha = param.SPH.gamma.value * abs(Lambda - sum(CS .* outV(t-1,:))) + (1-param.SPH.gamma.value) * outAlpha(t-1,:);
                oldAlpha = outAlpha(t-1,:);
            end
            newAlpha = min(max(...
                newAlpha,[0,0,0]),[1,1,1]); % alpha value should be in range [0,1]. // Really??
            for s = 1 : 3
                if CS(s)
                    outAlpha(t,s) = newAlpha(s);
                else
                    outAlpha(t,s) = oldAlpha(s);
                end
            end

            % V change
            deltaV_pos = [0, 0, 0];
            deltaV_bar = [0, 0, 0];

            if Lambda - sum(CS .* V) > 0
                deltaV_pos = CS .* S .* outAlpha(t,:) .* param.SPH.beta_ex.value .* Lambda;
            else
                deltaV_bar = CS .* S .* outAlpha(t,:) .* param.SPH.beta_in.value .* Lambda_bar;
            end
            outV(t,:) = V;
            outV_pos(t+1,:) = outV_pos(t,:) + deltaV_pos;
            outV_bar(t+1,:) = outV_bar(t,:) + deltaV_bar;
        end
    case{'Esber-Haselgrove', 'EH'}
        phi = outAlpha(t,:);
        V_pre = [0, 0, 0];
        for t = 1 : size(schedule,1)
            CS = schedule(t,1:3);
            US = schedule(t,4);

            V_pos_tot = sum(outV_pos(t,:) .* CS);
            V_bar_tot = sum(outV_bar(t,:) .* CS);

            Lambda = US .* schedule(t,5);

            newAlpha = phi + (outV_pos(t,:) + outV_bar(t,:)) - param.EH.k.value * V_pre;

            if((Lambda - (V_pos_tot - V_bar_tot)) > 0)
                beta_pos = param.EH.lr1_acq.value;
                beta_bar = param.EH.lr2_acq.value;
            else
                beta_pos = param.EH.lr1_ext.value;
                beta_bar = param.EH.lr2_ext.value;
            end
            deltaV_pos = CS .* newAlpha .* beta_pos .* (Lambda - (V_pos_tot - V_bar_tot));
            deltaV_bar = CS .* newAlpha .* beta_bar .* ((V_pos_tot - V_bar_tot) - Lambda);

            outV(t,:) = outV_pos(t,:) - outV_bar(t,:);

            %if param.EH.limitV
            outV_pos(t+1,:) = min(max(outV_pos(t,:) + deltaV_pos,[0,0,0]),[1,1,1]);
            outV_bar(t+1,:) = min(max(outV_bar(t,:) + deltaV_bar,[0,0,0]),[1,1,1]);
%             else
%                 outV_pos(t+1,:) = outV_pos(t,:) + deltaV_pos;
%                 outV_bar(t+1,:) = outV_bar(t,:) + deltaV_bar;
%             end
            outAlpha(t,:) = newAlpha;
            V_pre = V_pre + param.EH.lr_pre.value * (CS - V_pre);
        end
end % switch end

outV = outV(1:numTrial,:);
outAlpha = outAlpha(1:numTrial, :);

end % func end
