classdef ClassicalConditioningCloset_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        ClassicalConditioningClosetFigure  matlab.ui.Figure
        HelpMenu                        matlab.ui.container.Menu
        DocMenu                         matlab.ui.container.Menu
        AboutMenu                       matlab.ui.container.Menu
        StageConfigurationPanel         matlab.ui.container.Panel
        CSAButton                       matlab.ui.control.StateButton
        CSBButton                       matlab.ui.control.StateButton
        CSCButton                       matlab.ui.control.StateButton
        ShockButton                     matlab.ui.control.StateButton
        RepeatSpinnerLabel              matlab.ui.control.Label
        RepeatSpinner                   matlab.ui.control.Spinner
        Label_2                         matlab.ui.control.Label
        lambda                          matlab.ui.control.Spinner
        AddButton                       matlab.ui.control.Button
        RemoveButton                    matlab.ui.control.Button
        SetRepeatButton                 matlab.ui.control.Button
        AddStageButton                  matlab.ui.control.Button
        alpha_C                         matlab.ui.control.Spinner
        alpha_B                         matlab.ui.control.Spinner
        InitialLabel                    matlab.ui.control.Label
        alpha_A                         matlab.ui.control.Spinner
        CSALabel                        matlab.ui.control.Label
        CSBLabel                        matlab.ui.control.Label
        CSCLabel                        matlab.ui.control.Label
        UIAxes                          matlab.ui.control.UIAxes
        UITable                         matlab.ui.control.Table
        Knowblesse2021Label             matlab.ui.control.Label
        ModelConfigurationPanel         matlab.ui.container.Panel
        TabGroup                        matlab.ui.container.TabGroup
        Tab_RW                          matlab.ui.container.Tab
        acqLabel                        matlab.ui.control.Label
        paramRW_lr_acq                  matlab.ui.control.Spinner
        extLabel_2                      matlab.ui.control.Label
        paramRW_lr_ext                  matlab.ui.control.Spinner
        Image_6                         matlab.ui.control.Image
        Tab_M                           matlab.ui.container.Tab
        acqLabel_2                      matlab.ui.control.Label
        paramM_lr_acq                   matlab.ui.control.Spinner
        extLabel_3                      matlab.ui.control.Label
        paramM_lr_ext                   matlab.ui.control.Spinner
        kLabel                          matlab.ui.control.Label
        paramM_k                        matlab.ui.control.Spinner
        Image_7                         matlab.ui.control.Image
        Label_7                         matlab.ui.control.Label
        paramM_epsilon                  matlab.ui.control.Spinner
        Tab_PH                          matlab.ui.container.Tab
        SALabel                         matlab.ui.control.Label
        paramPH_SA                      matlab.ui.control.Spinner
        SBLabel                         matlab.ui.control.Label
        paramPH_SB                      matlab.ui.control.Spinner
        SCLabel                         matlab.ui.control.Label
        paramPH_SC                      matlab.ui.control.Spinner
        Image_8                         matlab.ui.control.Image
        Tab_EH                          matlab.ui.container.Tab
        paramEH_lr1_acq                 matlab.ui.control.Spinner
        paramEH_lr1_ext                 matlab.ui.control.Spinner
        paramEH_lr2_acq                 matlab.ui.control.Spinner
        paramEH_lr2_ext                 matlab.ui.control.Spinner
        Image_9                         matlab.ui.control.Image
        paramEH_limitV                  matlab.ui.control.CheckBox
        kLabel_2                        matlab.ui.control.Label
        paramEH_k                       matlab.ui.control.Spinner
        beta_preLabel                   matlab.ui.control.Label
        paramEH_lr_pre                  matlab.ui.control.Spinner
        beta1Label                      matlab.ui.control.Label
        beta2Label                      matlab.ui.control.Label
        acquisitionLabel                matlab.ui.control.Label
        extinctionLabel                 matlab.ui.control.Label
        Tab_SPH                         matlab.ui.container.Tab
        SALabel_2                       matlab.ui.control.Label
        paramSPH_SA                     matlab.ui.control.Spinner
        SBLabel_2                       matlab.ui.control.Label
        paramSPH_SB                     matlab.ui.control.Spinner
        SCLabel_2                       matlab.ui.control.Label
        paramSPH_SC                     matlab.ui.control.Spinner
        Image_4                         matlab.ui.control.Image
        exLabel                         matlab.ui.control.Label
        paramSPH_beta_ex                matlab.ui.control.Spinner
        inLabel                         matlab.ui.control.Label
        paramSPH_beta_in                matlab.ui.control.Spinner
        Label_4                         matlab.ui.control.Label
        paramSPH_gamma                  matlab.ui.control.Spinner
        Tab_TD                          matlab.ui.container.Tab
        Image_10                        matlab.ui.control.Image
        paramTD_table                   matlab.ui.control.Table
        Label_5                         matlab.ui.control.Label
        paramTD_beta                    matlab.ui.control.Spinner
        cLabel                          matlab.ui.control.Label
        paramTD_c                       matlab.ui.control.Spinner
        Label_6                         matlab.ui.control.Label
        paramTD_gamma                   matlab.ui.control.Spinner
        ModelButtonGroup                matlab.ui.container.ButtonGroup
        RescorlaWagnerButton            matlab.ui.control.RadioButton
        MackintoshButton                matlab.ui.control.RadioButton
        PearceHallButton                matlab.ui.control.RadioButton
        EsberHaselgroveButton           matlab.ui.control.RadioButton
        SchmajukPHButton                matlab.ui.control.RadioButton
        TDButton                        matlab.ui.control.RadioButton
        RunButton                       matlab.ui.control.Button
        ExperimentTemplateListBoxLabel  matlab.ui.control.Label
        ExperimentTemplateListBox       matlab.ui.control.ListBox
        ExperimentScheduleListBoxLabel  matlab.ui.control.Label
        ExperimentScheduleListBox       matlab.ui.control.ListBox
        LoadButton                      matlab.ui.control.Button
        ClearScheduleButton             matlab.ui.control.Button
        AllCheckBox                     matlab.ui.control.CheckBox
        CSACheckBox                     matlab.ui.control.CheckBox
        CSBCheckBox                     matlab.ui.control.CheckBox
        CSCCheckBox                     matlab.ui.control.CheckBox
        alphaACheckBox                  matlab.ui.control.CheckBox
        alphaBCheckBox                  matlab.ui.control.CheckBox
        alphaCCheckBox                  matlab.ui.control.CheckBox
        YaxisSpinnerLabel               matlab.ui.control.Label
        YaxisBottom                     matlab.ui.control.Spinner
        YaxisTop                        matlab.ui.control.Spinner
    end

    
    properties (Access = private)
        
        V = zeros(1000,3);
        V_pos = zeros(1000,3); % V value for S-P-H model, V_dot(=V_pos - V_bar) is assigned to V instead
        V_bar = zeros(1000,3);
        alpha = zeros(1000,3);
        numStage
        numTrial
        previous_lambda % temporal storage for UI function of the US button
        CC = struct;
    end
    methods (Access = private)
        function InitializeVariables(app)
            % Association
            app.numStage = 0;
            app.numTrial = 1;
            app.previous_lambda = 1; 
            
            app.V = zeros(1000,3);
            app.V_pos = zeros(1000,3); % V value for S-P-H model, V_dot(=V_pos - V_bar) is assigned to V instead
            app.V_bar = zeros(1000,3);
            app.alpha = zeros(1000,3);
            
            cla(app.UIAxes);
            app.UITable.Data = [];
        end
        function UpdateTable(app)
            % Update Table Contents
            Trials = 1 : app.numTrial-1;
            app.UITable.Data = table(Trials',...
                app.V(1:app.numTrial-1,1),...
                app.V(1:app.numTrial-1,2),...
                app.V(1:app.numTrial-1,3),...
                app.alpha(1:app.numTrial-1,1),...
                app.alpha(1:app.numTrial-1,2),...
                app.alpha(1:app.numTrial-1,3));
        end
    
        function UpdateGraph(app)
            % Update Graph Contents
            cla(app.UIAxes);
            legend(app.UIAxes,'off');
            legendtext = {'CS A', 'CS B', 'CS C', 'alpha A', 'alpha B', 'alpha C'};
            legendOption = false(1,6);
            hold(app.UIAxes,'on');
            if app.CSACheckBox.Value == true
                plot(app.UIAxes,app.V(1:app.numTrial-1,1),'Color',app.CC.CS1,'LineWidth',2);
                legendOption(1) = true;
            end
            if app.CSBCheckBox.Value == true
                plot(app.UIAxes,app.V(1:app.numTrial-1,2),'Color',app.CC.CS2,'LineWidth',2);
                legendOption(2) = true;
            end
            if app.CSCCheckBox.Value == true
                plot(app.UIAxes,app.V(1:app.numTrial-1,3),'Color',app.CC.CS3,'LineWidth',2);
                legendOption(3) = true; 
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if app.alphaACheckBox.Value == true
                plot(app.UIAxes,app.alpha(1:app.numTrial-1,1),'Color',app.CC.CS1,'LineStyle','-.','LineWidth',2);
                legendOption(4) = true;
            end
            if app.alphaBCheckBox.Value == true
                plot(app.UIAxes,app.alpha(1:app.numTrial-1,2),'Color',app.CC.CS2,'LineStyle','-.','LineWidth',2);
                legendOption(5) = true;
            end
            if app.alphaCCheckBox.Value == true
                plot(app.UIAxes,app.alpha(1:app.numTrial-1,3),'Color',app.CC.CS3,'LineStyle','-.','LineWidth',2);
                legendOption(6) = true; 
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
            legend(app.UIAxes,legendtext{legendOption},'Location','northwest');
            ylim(app.UIAxes,[app.YaxisBottom.Value,app.YaxisTop.Value]);
        end
        
        
        function result = fillWidth(~,str)
            % Fill '-' and match the width of the str 
            WIDTH = 24;
            numString = numel(str);
            if rem(WIDTH-numString,2) == 0
                result = strcat(repmat('-',1,(WIDTH - numString)/2), str, repmat('-',1,(WIDTH - numString)/2));
            else
                result = strcat(repmat('-',1,(WIDTH - numString-1)/2+1), str, repmat('-',1,(WIDTH - numString-1)/2));
            end
        end
        
        function addStage(app,index)
            if index == 0 
                app.ExperimentScheduleListBox.Items = {...
                    app.fillWidth('Stage 01'),...
                    app.fillWidth('x 1'),...
                    };
                index = 1;
            else
                app.ExperimentScheduleListBox.Items = [app.ExperimentScheduleListBox.Items(1:index-1),...
                    app.fillWidth('Stage 01'),...
                    app.fillWidth('x 1'),...
                    app.ExperimentScheduleListBox.Items(index:end)];
            end
            app.ExperimentScheduleListBox.ItemsData = 1 : numel(app.ExperimentScheduleListBox.Items);
            app.ExperimentScheduleListBox.Value = index;
            
            app.rearrangeSchedule();
        end
        
        function rearrangeSchedule(app)
            app.ExperimentScheduleListBox.ItemsData = 1 : numel(app.ExperimentScheduleListBox.Items);
            temp = 1;
            app.numStage = 0;
            for i = 1 : numel(app.ExperimentScheduleListBox.Items)
                if contains(app.ExperimentScheduleListBox.Items{i},'Stage')
                    app.numStage = app.numStage + 1;
                    [s,e] = regexp(app.ExperimentScheduleListBox.Items{i},'\d*');
                    app.ExperimentScheduleListBox.Items{i} = char(strcat(...
                        app.ExperimentScheduleListBox.Items{i}(1:s-2), " ", num2str(temp,'%02d'), app.ExperimentScheduleListBox.Items{i}(e+1:end)...
                        ));
                    temp = temp + 1;
                end
            end
        end
        
        function [start,last] = findStartEndOfStage(app,index)
            % Find the starting and ending index of the stage
            items = app.ExperimentScheduleListBox.Items;
            % Find Start
            if contains(items{index},'Stage')
                start = index;
            else
                temp = index - 1;
                while ~contains(items{temp},'Stage')
                    temp = temp - 1;
                end
                start = temp;
                clearvars temp
            end
            
            % Find End
            if contains(items{index},'x')
                last = index;
            else
                temp = index + 1;
                while ~contains(items{temp},'x')
                    temp = temp + 1;
                end
                last = temp;
                clearvars temp
            end
        end
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.InitializeVariables();
            app.addStage(0);
            app.CC.CS1 = [113,204,255]/255;
            app.CC.CS2 = [130,196,124]/255;
            app.CC.CS3 = [238,121,72]/255;
            app.CC.US  = [234,129,147]/255;
            app.paramTD_table.Data = table(1,4,1,4,1,4,9,10,50);
        end

        % Button pushed function: RunButton
        function RunButtonPushed(app, event)
            
            app.InitializeVariables();
            
            % Parse Experiment Schedule
            items = app.ExperimentScheduleListBox.Items;
            schedule = []; % TODO : memory preallocation
            for i = 1 : numel(items)
                if contains(items{i},'Stage') % Stange Start
                    stage_buffer = [];
                elseif contains(items{i},'x') % Stage End
                    temp = regexp(items{i},'\d*','match');
                    num_repeat = str2double(temp);
                    schedule = [schedule; repmat(stage_buffer,num_repeat,1)];
                    clearvars temp
                else % In Stage
                    % test = 'AB+|0.9';
                    sp = strsplit(items{i},'|');
                    if (numel(sp) ~= 2)
                        error('Experiement Schedule Parsing Error');
                    end
                    stage_buffer = [stage_buffer;...
                        contains(sp{1},'A'),contains(sp{1},'B'),contains(sp{1},'C'),contains(sp{1},'+'), str2double(sp{2})];
                end 
            end
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
                end
                app.numTrial = t;
                %%%%%%%%%%%%%%%%%%%%%%%%%%CCC_exported End %%%%%%%%%%%%%%%%%%%%%%%%%%
                % Update Graph
                app.UpdateGraph();
                
                % Update Table
                app.UpdateTable();
            end
        end

        % Callback function
        function NewRatButtonPushed(app, event)
            
        end

        % Callback function
        function GraphButtonGroupSelectionChanged(app, event)
            app.UpdateGraph();            
        end

        % Callback function
        function LoadExperimentButtonValueChanged(app, event)
            value = app.LoadExperimentButton.Value;
            app.TabGroup.TabLocation
        end

        % Button pushed function: RemoveButton
        function RemoveButtonPushed(app, event)
            items = app.ExperimentScheduleListBox.Items;
            i_items = app.ExperimentScheduleListBox.Value;
            
            if or(contains(items{i_items},'Stage'), contains(items{i_items},'x'))
                answer = questdlg('Delete Stage?','Delete Stage','Yes','No','No');
                if strcmp(answer,'Yes')
                    % delete whole stage
                    if app.numStage == 1
                        msgbox('This is the last stage');
                    else
                        if contains(items{i_items},'Stage')
                            [~,last] = app.findStartEndOfStage(i_items);
                            app.ExperimentScheduleListBox.Items(i_items:last) = [];
                            app.ExperimentScheduleListBox.Value = max(1,i_items-1);
                        else
                            [first,~] = app.findStartEndOfStage(i_items);
                            app.ExperimentScheduleListBox.Items(first:i_items) = [];
                            app.ExperimentScheduleListBox.Value = max(1,first-1);
                        end
                        app.rearrangeSchedule();
                    end
                end
            else
                app.ExperimentScheduleListBox.Items(i_items) = [];
                app.ExperimentScheduleListBox.Value = i_items;
                app.ExperimentScheduleListBox.ItemsData = 1 : numel(items)-1;
            end
        end

        % Selection changed function: ModelButtonGroup
        function ModelButtonGroupSelectionChanged(app, event)
            selectedButton = app.ModelButtonGroup.SelectedObject;
            switch(selectedButton.Text)
                case('Rescorla-Wagner')
                    app.TabGroup.SelectedTab = app.Tab_RW;
                case('Mackintosh')
                    app.TabGroup.SelectedTab = app.Tab_M;
                case('Pearce-Hall')
                    app.TabGroup.SelectedTab = app.Tab_PH;
                case('Esber-Haselgrove')
                    app.TabGroup.SelectedTab = app.Tab_EH;
                case('Schmajuk-P-H')
                    app.TabGroup.SelectedTab = app.Tab_SPH;
                case('Temporal-Difference')
                    app.TabGroup.SelectedTab = app.Tab_TD;
            end
        end

        % Value changed function: ShockButton
        function ShockButtonValueChanged(app, event)
            if app.ShockButton.Value
                app.lambda.Enable = true;
                app.lambda.Value = app.previous_lambda;
            else
                app.lambda.Enable = false;
                app.previous_lambda = app.lambda.Value;
                app.lambda.Value = 0;
            end
        end

        % Button pushed function: AddButton
        function AddButtonPushed(app, event)
            if sum([app.CSAButton.Value,app.CSBButton.Value,app.CSCButton.Value]) == 0
                msgbox('Please select at least 1 CS')
            else
                % Find insert index and the stage number for the new Data
                items = app.ExperimentScheduleListBox.Items;
                i_items = app.ExperimentScheduleListBox.Value;
                if contains(items{i_items},'Stage') % Stange Start
                    index = i_items + 1;
                elseif contains(items{i_items},'x')
                    index = i_items;
                    clearvars temp
                else
                    index = i_items + 1;
                    temp = i_items - 1;
                    while(~contains(items{temp},'Stage'))
                        temp = temp - 1;
                    end
                    clearvars temp
                end
                
                % Translate the Configuration
                templateStr = 'ABC';
                if app.ShockButton.Value
                    USStr = '+';
                else
                    USStr = '-';
                end
                expStr = strcat(...
                    templateStr([app.CSAButton.Value, app.CSBButton.Value, app.CSCButton.Value]),...
                    USStr,...
                    '|',...
                    num2str(app.lambda.Value,'%.2f '));
                
                % Insert
                app.ExperimentScheduleListBox.Items = [items(1:index-1), expStr, items(index:end)];
                app.ExperimentScheduleListBox.Value = index;
                app.rearrangeSchedule();
                
            end
            
        end

        % Button pushed function: AddStageButton
        function AddStageButtonPushed(app, event)
            if(contains(app.ExperimentScheduleListBox.Items{app.ExperimentScheduleListBox.Value},'Stage')) % add before the selection if selection is Stage marker
                app.addStage(app.ExperimentScheduleListBox.Value);
            else
                [~, last] = app.findStartEndOfStage(app.ExperimentScheduleListBox.Value);
                app.addStage(last + 1);
            end
        end

        % Button pushed function: SetRepeatButton
        function SetRepeatButtonPushed(app, event)
            [~, last] = app.findStartEndOfStage(app.ExperimentScheduleListBox.Value);
            app.ExperimentScheduleListBox.Items{last} = app.fillWidth(char(strcat('x', " ", num2str(app.RepeatSpinner.Value))));
        end

        % Button pushed function: LoadButton
        function LoadButtonPushed(app, event)
            switch(app.ExperimentTemplateListBox.Value)
                case('Acq/Ext')
                    app.ExperimentScheduleListBox.Items = {...
                        app.fillWidth('Stage 01'),...
                        'A+|1',...
                        app.fillWidth('x 100'),...
                        app.fillWidth('Stage 02'),...
                        'A-|1',...
                        app.fillWidth('x 100')...
                        };
                case('Blocking')
                    app.ExperimentScheduleListBox.Items = {...
                        app.fillWidth('Stage 01'),...
                        'A+|1',...
                        app.fillWidth('x 20'),...
                        app.fillWidth('Stage 02'),...
                        'AB+|1',...
                        app.fillWidth('x 100')...
                        };
                case('Conditioned Inhibition')
                    app.ExperimentScheduleListBox.Items = {...
                        app.fillWidth('Stage 01'),...
                        'A+|1',...
                        app.fillWidth('x 100'),...
                        app.fillWidth('Stage 02'),...
                        'AB-|0',...
                        app.fillWidth('x 100'),...
                        };
                case('Latent Inhibition')
                    app.ExperimentScheduleListBox.Items = {...
                        app.fillWidth('Stage 01'),...
                        'A-|0',...
                        app.fillWidth('x 100'),...
                        app.fillWidth('Stage 02'),...
                        'A+|1',...
                        app.fillWidth('x 100'),...
                        };
                case('Partial Reinforcement')
                    app.ExperimentScheduleListBox.Items = {...
                        app.fillWidth('Stage 01'),...
                        'A+|1',...
                        app.fillWidth('x 100'),...
                        app.fillWidth('Stage 02'),...
                        'B+|1',...
                        'B-|1',...
                        app.fillWidth('x 100')...
                        };
                case('PR_w/better predictor')
                    app.ExperimentScheduleListBox.Items = {...
                        app.fillWidth('Stage 01'),...
                        'AB+|1',...
                        'AC-|0',...
                        app.fillWidth('x 100'),...
                        };
                case('PR_w/o better predictor')
                    app.ExperimentScheduleListBox.Items = {...
                        app.fillWidth('Stage 01'),...
                        'A+|1',...
                        'A-|0',...
                        app.fillWidth('x 100'),...
                        };

            end
            app.rearrangeSchedule();
            
        end

        % Button pushed function: ClearScheduleButton
        function ClearScheduleButtonPushed(app, event)
            app.ExperimentScheduleListBox.Items = {};
            app.ExperimentScheduleListBox.ItemsData = [];
            app.addStage(0);
        end

        % Value changed function: AllCheckBox
        function AllCheckBoxValueChanged(app, event)
            value = app.AllCheckBox.Value;
            app.CSACheckBox.Value = value;
            app.CSBCheckBox.Value = value;
            app.CSCCheckBox.Value = value;
            app.alphaACheckBox.Value = value;
            app.alphaBCheckBox.Value = value;
            app.alphaCCheckBox.Value = value;
            app.UpdateGraph();
        end

        % Value changed function: CSACheckBox, CSBCheckBox, 
        % CSCCheckBox, alphaACheckBox, alphaBCheckBox, 
        % alphaCCheckBox
        function CheckBoxValueChanged(app, event)
            if app.CSACheckBox.Value && app.CSBCheckBox.Value && app.CSCCheckBox.Value && app.alphaACheckBox.Value && app.alphaBCheckBox.Value && app.alphaCCheckBox.Value
                app.AllCheckBox.Value = true;
            else
                app.AllCheckBox.Value = false;
            end
            app.UpdateGraph();
        end

        % Value changed function: YaxisBottom, YaxisTop
        function YaxisValueChanged(app, event)
            if app.YaxisBottom.Value < app.YaxisTop.Value
                ylim(app.UIAxes,[app.YaxisBottom.Value,app.YaxisTop.Value]);
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create ClassicalConditioningClosetFigure and hide until all components are created
            app.ClassicalConditioningClosetFigure = uifigure('Visible', 'off');
            app.ClassicalConditioningClosetFigure.Color = [0.902 0.902 0.902];
            app.ClassicalConditioningClosetFigure.Position = [100 100 1135 760];
            app.ClassicalConditioningClosetFigure.Name = 'ClassicalConditioningCloset';

            % Create HelpMenu
            app.HelpMenu = uimenu(app.ClassicalConditioningClosetFigure);
            app.HelpMenu.Text = 'Help';

            % Create DocMenu
            app.DocMenu = uimenu(app.HelpMenu);
            app.DocMenu.Text = 'Doc';

            % Create AboutMenu
            app.AboutMenu = uimenu(app.HelpMenu);
            app.AboutMenu.Text = 'About';

            % Create StageConfigurationPanel
            app.StageConfigurationPanel = uipanel(app.ClassicalConditioningClosetFigure);
            app.StageConfigurationPanel.TitlePosition = 'centertop';
            app.StageConfigurationPanel.Title = 'Stage Configuration';
            app.StageConfigurationPanel.Position = [748 546 379 168];

            % Create CSAButton
            app.CSAButton = uibutton(app.StageConfigurationPanel, 'state');
            app.CSAButton.Text = 'CS A';
            app.CSAButton.Position = [9 116 62 22];

            % Create CSBButton
            app.CSBButton = uibutton(app.StageConfigurationPanel, 'state');
            app.CSBButton.Text = 'CS B';
            app.CSBButton.Position = [80 116 62 22];

            % Create CSCButton
            app.CSCButton = uibutton(app.StageConfigurationPanel, 'state');
            app.CSCButton.Text = 'CS C';
            app.CSCButton.Position = [151 116 62 22];

            % Create ShockButton
            app.ShockButton = uibutton(app.StageConfigurationPanel, 'state');
            app.ShockButton.ValueChangedFcn = createCallbackFcn(app, @ShockButtonValueChanged, true);
            app.ShockButton.Text = 'Shock(US)';
            app.ShockButton.Position = [222 116 77 22];

            % Create RepeatSpinnerLabel
            app.RepeatSpinnerLabel = uilabel(app.StageConfigurationPanel);
            app.RepeatSpinnerLabel.HorizontalAlignment = 'right';
            app.RepeatSpinnerLabel.Position = [15 51 44 22];
            app.RepeatSpinnerLabel.Text = 'Repeat';

            % Create RepeatSpinner
            app.RepeatSpinner = uispinner(app.StageConfigurationPanel);
            app.RepeatSpinner.Limits = [1 Inf];
            app.RepeatSpinner.Position = [65 51 62 22];
            app.RepeatSpinner.Value = 1;

            % Create Label_2
            app.Label_2 = uilabel(app.StageConfigurationPanel);
            app.Label_2.HorizontalAlignment = 'right';
            app.Label_2.Enable = 'off';
            app.Label_2.Position = [308 116 11 22];
            app.Label_2.Text = '�';

            % Create lambda
            app.lambda = uispinner(app.StageConfigurationPanel);
            app.lambda.Step = 0.01;
            app.lambda.Limits = [0 2];
            app.lambda.ValueDisplayFormat = '%4.2f';
            app.lambda.Enable = 'off';
            app.lambda.Position = [322 115 57 22];
            app.lambda.Value = 1;

            % Create AddButton
            app.AddButton = uibutton(app.StageConfigurationPanel, 'push');
            app.AddButton.ButtonPushedFcn = createCallbackFcn(app, @AddButtonPushed, true);
            app.AddButton.Position = [90 85 93 22];
            app.AddButton.Text = 'Add';

            % Create RemoveButton
            app.RemoveButton = uibutton(app.StageConfigurationPanel, 'push');
            app.RemoveButton.ButtonPushedFcn = createCallbackFcn(app, @RemoveButtonPushed, true);
            app.RemoveButton.Position = [225 85 93 22];
            app.RemoveButton.Text = 'Remove';

            % Create SetRepeatButton
            app.SetRepeatButton = uibutton(app.StageConfigurationPanel, 'push');
            app.SetRepeatButton.ButtonPushedFcn = createCallbackFcn(app, @SetRepeatButtonPushed, true);
            app.SetRepeatButton.Position = [151 51 93 22];
            app.SetRepeatButton.Text = 'Set Repeat';

            % Create AddStageButton
            app.AddStageButton = uibutton(app.StageConfigurationPanel, 'push');
            app.AddStageButton.ButtonPushedFcn = createCallbackFcn(app, @AddStageButtonPushed, true);
            app.AddStageButton.Position = [267 52 93 22];
            app.AddStageButton.Text = 'Add Stage';

            % Create alpha_C
            app.alpha_C = uispinner(app.StageConfigurationPanel);
            app.alpha_C.Step = 0.1;
            app.alpha_C.Limits = [0 2];
            app.alpha_C.ValueDisplayFormat = '%4.2f';
            app.alpha_C.Position = [255 7 61 22];
            app.alpha_C.Value = 0.5;

            % Create alpha_B
            app.alpha_B = uispinner(app.StageConfigurationPanel);
            app.alpha_B.Step = 0.1;
            app.alpha_B.Limits = [0 2];
            app.alpha_B.ValueDisplayFormat = '%4.2f';
            app.alpha_B.Position = [175 7 61 22];
            app.alpha_B.Value = 0.5;

            % Create InitialLabel
            app.InitialLabel = uilabel(app.StageConfigurationPanel);
            app.InitialLabel.HorizontalAlignment = 'right';
            app.InitialLabel.Position = [44 7 44 22];
            app.InitialLabel.Text = 'Initial �';

            % Create alpha_A
            app.alpha_A = uispinner(app.StageConfigurationPanel);
            app.alpha_A.Step = 0.1;
            app.alpha_A.Limits = [0 2];
            app.alpha_A.ValueDisplayFormat = '%4.2f';
            app.alpha_A.Position = [95 7 61 22];
            app.alpha_A.Value = 0.5;

            % Create CSALabel
            app.CSALabel = uilabel(app.StageConfigurationPanel);
            app.CSALabel.Position = [108 25 34 22];
            app.CSALabel.Text = 'CS A';

            % Create CSBLabel
            app.CSBLabel = uilabel(app.StageConfigurationPanel);
            app.CSBLabel.Position = [189 25 34 22];
            app.CSBLabel.Text = 'CS B';

            % Create CSCLabel
            app.CSCLabel = uilabel(app.StageConfigurationPanel);
            app.CSCLabel.Position = [269 25 34 22];
            app.CSCLabel.Text = 'CS C';

            % Create UIAxes
            app.UIAxes = uiaxes(app.ClassicalConditioningClosetFigure);
            xlabel(app.UIAxes, 'Trials')
            ylabel(app.UIAxes, 'Association')
            app.UIAxes.Box = 'on';
            app.UIAxes.XGrid = 'on';
            app.UIAxes.XMinorGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.YMinorGrid = 'on';
            app.UIAxes.Position = [12 11 724 457];

            % Create UITable
            app.UITable = uitable(app.ClassicalConditioningClosetFigure);
            app.UITable.ColumnName = {'#'; 'CS_A'; 'CS_B'; 'CS_C'; '�_A'; '�_B'; '�_C'};
            app.UITable.RowName = {};
            app.UITable.Position = [748 32 379 248];

            % Create Knowblesse2021Label
            app.Knowblesse2021Label = uilabel(app.ClassicalConditioningClosetFigure);
            app.Knowblesse2021Label.Position = [1017 11 112 22];
            app.Knowblesse2021Label.Text = '@Knowblesse 2021';

            % Create ModelConfigurationPanel
            app.ModelConfigurationPanel = uipanel(app.ClassicalConditioningClosetFigure);
            app.ModelConfigurationPanel.TitlePosition = 'centertop';
            app.ModelConfigurationPanel.Title = 'Model Configuration';
            app.ModelConfigurationPanel.Position = [12 506 724 214];

            % Create TabGroup
            app.TabGroup = uitabgroup(app.ModelConfigurationPanel);
            app.TabGroup.TabLocation = 'left';
            app.TabGroup.Position = [10 13 698 179];

            % Create Tab_RW
            app.Tab_RW = uitab(app.TabGroup);
            app.Tab_RW.Title = 'RW';

            % Create acqLabel
            app.acqLabel = uilabel(app.Tab_RW);
            app.acqLabel.HorizontalAlignment = 'right';
            app.acqLabel.Position = [475 103 38 22];
            app.acqLabel.Text = '�_acq';

            % Create paramRW_lr_acq
            app.paramRW_lr_acq = uispinner(app.Tab_RW);
            app.paramRW_lr_acq.Step = 0.005;
            app.paramRW_lr_acq.Limits = [0 1];
            app.paramRW_lr_acq.Position = [520 103 61 22];
            app.paramRW_lr_acq.Value = 0.1;

            % Create extLabel_2
            app.extLabel_2 = uilabel(app.Tab_RW);
            app.extLabel_2.HorizontalAlignment = 'right';
            app.extLabel_2.Position = [477 57 35 22];
            app.extLabel_2.Text = '�_ext';

            % Create paramRW_lr_ext
            app.paramRW_lr_ext = uispinner(app.Tab_RW);
            app.paramRW_lr_ext.Step = 0.005;
            app.paramRW_lr_ext.Limits = [0 1];
            app.paramRW_lr_ext.Position = [519 57 61 22];
            app.paramRW_lr_ext.Value = 0.05;

            % Create Image_6
            app.Image_6 = uiimage(app.Tab_RW);
            app.Image_6.BackgroundColor = [1 1 1];
            app.Image_6.Position = [85 2 381 171];
            app.Image_6.ImageSource = 'RW_equation.png';

            % Create Tab_M
            app.Tab_M = uitab(app.TabGroup);
            app.Tab_M.Title = 'M';

            % Create acqLabel_2
            app.acqLabel_2 = uilabel(app.Tab_M);
            app.acqLabel_2.HorizontalAlignment = 'right';
            app.acqLabel_2.Position = [476 145 38 22];
            app.acqLabel_2.Text = '�_acq';

            % Create paramM_lr_acq
            app.paramM_lr_acq = uispinner(app.Tab_M);
            app.paramM_lr_acq.Step = 0.005;
            app.paramM_lr_acq.Limits = [0 1];
            app.paramM_lr_acq.Position = [521 145 61 22];
            app.paramM_lr_acq.Value = 0.08;

            % Create extLabel_3
            app.extLabel_3 = uilabel(app.Tab_M);
            app.extLabel_3.HorizontalAlignment = 'right';
            app.extLabel_3.Position = [479 109 35 22];
            app.extLabel_3.Text = '�_ext';

            % Create paramM_lr_ext
            app.paramM_lr_ext = uispinner(app.Tab_M);
            app.paramM_lr_ext.Step = 0.005;
            app.paramM_lr_ext.Limits = [0 1];
            app.paramM_lr_ext.Position = [521 109 61 22];
            app.paramM_lr_ext.Value = 0.04;

            % Create kLabel
            app.kLabel = uilabel(app.Tab_M);
            app.kLabel.HorizontalAlignment = 'right';
            app.kLabel.Position = [489 76 25 22];
            app.kLabel.Text = 'k';

            % Create paramM_k
            app.paramM_k = uispinner(app.Tab_M);
            app.paramM_k.Step = 0.005;
            app.paramM_k.Limits = [0 1];
            app.paramM_k.Position = [521 76 61 22];
            app.paramM_k.Value = 0.05;

            % Create Image_7
            app.Image_7 = uiimage(app.Tab_M);
            app.Image_7.BackgroundColor = [1 1 1];
            app.Image_7.Position = [85 2 381 171];
            app.Image_7.ImageSource = 'M_equation.png';

            % Create Label_7
            app.Label_7 = uilabel(app.Tab_M);
            app.Label_7.HorizontalAlignment = 'right';
            app.Label_7.Position = [489 38 25 22];
            app.Label_7.Text = '�';

            % Create paramM_epsilon
            app.paramM_epsilon = uispinner(app.Tab_M);
            app.paramM_epsilon.Step = 0.005;
            app.paramM_epsilon.Limits = [0 1];
            app.paramM_epsilon.Position = [521 38 61 22];
            app.paramM_epsilon.Value = 0.02;

            % Create Tab_PH
            app.Tab_PH = uitab(app.TabGroup);
            app.Tab_PH.Title = 'PH';

            % Create SALabel
            app.SALabel = uilabel(app.Tab_PH);
            app.SALabel.HorizontalAlignment = 'right';
            app.SALabel.Position = [506 107 25 22];
            app.SALabel.Text = 'SA';

            % Create paramPH_SA
            app.paramPH_SA = uispinner(app.Tab_PH);
            app.paramPH_SA.Step = 0.05;
            app.paramPH_SA.Limits = [0 1];
            app.paramPH_SA.Position = [538 107 61 22];
            app.paramPH_SA.Value = 0.04;

            % Create SBLabel
            app.SBLabel = uilabel(app.Tab_PH);
            app.SBLabel.HorizontalAlignment = 'right';
            app.SBLabel.Position = [506 77 25 22];
            app.SBLabel.Text = 'SB';

            % Create paramPH_SB
            app.paramPH_SB = uispinner(app.Tab_PH);
            app.paramPH_SB.Step = 0.05;
            app.paramPH_SB.Limits = [0 1];
            app.paramPH_SB.Position = [538 77 61 22];
            app.paramPH_SB.Value = 0.04;

            % Create SCLabel
            app.SCLabel = uilabel(app.Tab_PH);
            app.SCLabel.HorizontalAlignment = 'right';
            app.SCLabel.Position = [506 47 25 22];
            app.SCLabel.Text = 'SC';

            % Create paramPH_SC
            app.paramPH_SC = uispinner(app.Tab_PH);
            app.paramPH_SC.Step = 0.05;
            app.paramPH_SC.Limits = [0 1];
            app.paramPH_SC.Position = [538 47 61 22];
            app.paramPH_SC.Value = 0.04;

            % Create Image_8
            app.Image_8 = uiimage(app.Tab_PH);
            app.Image_8.BackgroundColor = [1 1 1];
            app.Image_8.Position = [85 2 381 171];
            app.Image_8.ImageSource = 'PH_equation.png';

            % Create Tab_EH
            app.Tab_EH = uitab(app.TabGroup);
            app.Tab_EH.Title = 'EH';

            % Create paramEH_lr1_acq
            app.paramEH_lr1_acq = uispinner(app.Tab_EH);
            app.paramEH_lr1_acq.Step = 0.01;
            app.paramEH_lr1_acq.Limits = [0 1];
            app.paramEH_lr1_acq.Position = [507 131 55 22];
            app.paramEH_lr1_acq.Value = 0.05;

            % Create paramEH_lr1_ext
            app.paramEH_lr1_ext = uispinner(app.Tab_EH);
            app.paramEH_lr1_ext.Step = 0.01;
            app.paramEH_lr1_ext.Limits = [0 1];
            app.paramEH_lr1_ext.Position = [568 131 55 22];
            app.paramEH_lr1_ext.Value = 0.04;

            % Create paramEH_lr2_acq
            app.paramEH_lr2_acq = uispinner(app.Tab_EH);
            app.paramEH_lr2_acq.Step = 0.01;
            app.paramEH_lr2_acq.Limits = [0 1];
            app.paramEH_lr2_acq.Position = [507 98 55 22];
            app.paramEH_lr2_acq.Value = 0.03;

            % Create paramEH_lr2_ext
            app.paramEH_lr2_ext = uispinner(app.Tab_EH);
            app.paramEH_lr2_ext.Step = 0.01;
            app.paramEH_lr2_ext.Limits = [0 1];
            app.paramEH_lr2_ext.Position = [568 98 55 22];
            app.paramEH_lr2_ext.Value = 0.02;

            % Create Image_9
            app.Image_9 = uiimage(app.Tab_EH);
            app.Image_9.BackgroundColor = [1 1 1];
            app.Image_9.Position = [85 2 381 171];
            app.Image_9.ImageSource = 'EH_equation.png';

            % Create paramEH_limitV
            app.paramEH_limitV = uicheckbox(app.Tab_EH);
            app.paramEH_limitV.Text = 'limit V&Vbar to [0,1]';
            app.paramEH_limitV.Position = [475 7 128 22];

            % Create kLabel_2
            app.kLabel_2 = uilabel(app.Tab_EH);
            app.kLabel_2.HorizontalAlignment = 'right';
            app.kLabel_2.Position = [525 63 17 22];
            app.kLabel_2.Text = 'k';

            % Create paramEH_k
            app.paramEH_k = uispinner(app.Tab_EH);
            app.paramEH_k.Step = 0.005;
            app.paramEH_k.Limits = [0 1];
            app.paramEH_k.Position = [555 63 55 22];
            app.paramEH_k.Value = 0.2;

            % Create beta_preLabel
            app.beta_preLabel = uilabel(app.Tab_EH);
            app.beta_preLabel.HorizontalAlignment = 'right';
            app.beta_preLabel.Position = [489 34 53 22];
            app.beta_preLabel.Text = 'beta_pre';

            % Create paramEH_lr_pre
            app.paramEH_lr_pre = uispinner(app.Tab_EH);
            app.paramEH_lr_pre.Step = 0.005;
            app.paramEH_lr_pre.Limits = [0 1];
            app.paramEH_lr_pre.Position = [555 34 55 22];
            app.paramEH_lr_pre.Value = 0.02;

            % Create beta1Label
            app.beta1Label = uilabel(app.Tab_EH);
            app.beta1Label.HorizontalAlignment = 'right';
            app.beta1Label.Position = [469 131 36 22];
            app.beta1Label.Text = 'beta1';

            % Create beta2Label
            app.beta2Label = uilabel(app.Tab_EH);
            app.beta2Label.HorizontalAlignment = 'right';
            app.beta2Label.Position = [469 98 36 22];
            app.beta2Label.Text = 'beta2';

            % Create acquisitionLabel
            app.acquisitionLabel = uilabel(app.Tab_EH);
            app.acquisitionLabel.HorizontalAlignment = 'center';
            app.acquisitionLabel.Position = [504 151 62 22];
            app.acquisitionLabel.Text = 'acquisition';

            % Create extinctionLabel
            app.extinctionLabel = uilabel(app.Tab_EH);
            app.extinctionLabel.HorizontalAlignment = 'center';
            app.extinctionLabel.Position = [565 152 56 22];
            app.extinctionLabel.Text = 'extinction';

            % Create Tab_SPH
            app.Tab_SPH = uitab(app.TabGroup);
            app.Tab_SPH.Title = 'SPH';

            % Create SALabel_2
            app.SALabel_2 = uilabel(app.Tab_SPH);
            app.SALabel_2.HorizontalAlignment = 'right';
            app.SALabel_2.Position = [488 148 25 22];
            app.SALabel_2.Text = 'SA';

            % Create paramSPH_SA
            app.paramSPH_SA = uispinner(app.Tab_SPH);
            app.paramSPH_SA.Step = 0.1;
            app.paramSPH_SA.Limits = [0 1];
            app.paramSPH_SA.Position = [520 148 61 22];
            app.paramSPH_SA.Value = 0.3;

            % Create SBLabel_2
            app.SBLabel_2 = uilabel(app.Tab_SPH);
            app.SBLabel_2.HorizontalAlignment = 'right';
            app.SBLabel_2.Position = [488 124 25 22];
            app.SBLabel_2.Text = 'SB';

            % Create paramSPH_SB
            app.paramSPH_SB = uispinner(app.Tab_SPH);
            app.paramSPH_SB.Step = 0.1;
            app.paramSPH_SB.Limits = [0 1];
            app.paramSPH_SB.Position = [520 124 61 22];
            app.paramSPH_SB.Value = 0.3;

            % Create SCLabel_2
            app.SCLabel_2 = uilabel(app.Tab_SPH);
            app.SCLabel_2.HorizontalAlignment = 'right';
            app.SCLabel_2.Position = [488 100 25 22];
            app.SCLabel_2.Text = 'SC';

            % Create paramSPH_SC
            app.paramSPH_SC = uispinner(app.Tab_SPH);
            app.paramSPH_SC.Step = 0.1;
            app.paramSPH_SC.Limits = [0 1];
            app.paramSPH_SC.Position = [520 100 61 22];
            app.paramSPH_SC.Value = 0.3;

            % Create Image_4
            app.Image_4 = uiimage(app.Tab_SPH);
            app.Image_4.BackgroundColor = [1 1 1];
            app.Image_4.Position = [85 2 381 171];
            app.Image_4.ImageSource = 'SPH_equation.png';

            % Create exLabel
            app.exLabel = uilabel(app.Tab_SPH);
            app.exLabel.HorizontalAlignment = 'right';
            app.exLabel.Position = [481 76 32 22];
            app.exLabel.Text = '�_ex';

            % Create paramSPH_beta_ex
            app.paramSPH_beta_ex = uispinner(app.Tab_SPH);
            app.paramSPH_beta_ex.Step = 0.005;
            app.paramSPH_beta_ex.Limits = [0 1];
            app.paramSPH_beta_ex.Position = [520 76 61 22];
            app.paramSPH_beta_ex.Value = 0.1;

            % Create inLabel
            app.inLabel = uilabel(app.Tab_SPH);
            app.inLabel.HorizontalAlignment = 'right';
            app.inLabel.Position = [485 52 28 22];
            app.inLabel.Text = '�_in';

            % Create paramSPH_beta_in
            app.paramSPH_beta_in = uispinner(app.Tab_SPH);
            app.paramSPH_beta_in.Step = 0.005;
            app.paramSPH_beta_in.Limits = [0 1];
            app.paramSPH_beta_in.Position = [520 52 61 22];
            app.paramSPH_beta_in.Value = 0.09;

            % Create Label_4
            app.Label_4 = uilabel(app.Tab_SPH);
            app.Label_4.HorizontalAlignment = 'right';
            app.Label_4.Position = [488 28 25 22];
            app.Label_4.Text = '�';

            % Create paramSPH_gamma
            app.paramSPH_gamma = uispinner(app.Tab_SPH);
            app.paramSPH_gamma.Step = 0.005;
            app.paramSPH_gamma.Limits = [0 1];
            app.paramSPH_gamma.Position = [520 28 61 22];
            app.paramSPH_gamma.Value = 0.2;

            % Create Tab_TD
            app.Tab_TD = uitab(app.TabGroup);
            app.Tab_TD.Title = 'TD';

            % Create Image_10
            app.Image_10 = uiimage(app.Tab_TD);
            app.Image_10.BackgroundColor = [1 1 1];
            app.Image_10.Position = [73 97 381 79];
            app.Image_10.ImageSource = 'TD_equation.png';

            % Create paramTD_table
            app.paramTD_table = uitable(app.Tab_TD);
            app.paramTD_table.ColumnName = {'A Start'; 'A End'; 'B Start'; 'B End'; 'C Start'; 'C End'; 'US Start'; 'US End'; 'ITT'};
            app.paramTD_table.ColumnWidth = {60, 60, 60, 60, 60, 60, 60, 60, 60};
            app.paramTD_table.RowName = {};
            app.paramTD_table.FontSize = 6;
            app.paramTD_table.Position = [73 13 545 78];

            % Create Label_5
            app.Label_5 = uilabel(app.Tab_TD);
            app.Label_5.HorizontalAlignment = 'right';
            app.Label_5.Position = [469 152 25 22];
            app.Label_5.Text = '�';

            % Create paramTD_beta
            app.paramTD_beta = uispinner(app.Tab_TD);
            app.paramTD_beta.Step = 0.005;
            app.paramTD_beta.Limits = [0 1];
            app.paramTD_beta.Position = [504 152 61 22];
            app.paramTD_beta.Value = 0.875;

            % Create cLabel
            app.cLabel = uilabel(app.Tab_TD);
            app.cLabel.HorizontalAlignment = 'right';
            app.cLabel.Position = [469 124 25 22];
            app.cLabel.Text = 'c';

            % Create paramTD_c
            app.paramTD_c = uispinner(app.Tab_TD);
            app.paramTD_c.Step = 0.005;
            app.paramTD_c.Limits = [0 1];
            app.paramTD_c.Position = [504 124 61 22];
            app.paramTD_c.Value = 0.08;

            % Create Label_6
            app.Label_6 = uilabel(app.Tab_TD);
            app.Label_6.HorizontalAlignment = 'right';
            app.Label_6.Position = [469 96 25 22];
            app.Label_6.Text = '�';

            % Create paramTD_gamma
            app.paramTD_gamma = uispinner(app.Tab_TD);
            app.paramTD_gamma.Step = 0.005;
            app.paramTD_gamma.Limits = [0 1];
            app.paramTD_gamma.Position = [504 96 61 22];
            app.paramTD_gamma.Value = 0.95;

            % Create ModelButtonGroup
            app.ModelButtonGroup = uibuttongroup(app.ModelConfigurationPanel);
            app.ModelButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @ModelButtonGroupSelectionChanged, true);
            app.ModelButtonGroup.Title = 'Model';
            app.ModelButtonGroup.Position = [9 13 139 179];

            % Create RescorlaWagnerButton
            app.RescorlaWagnerButton = uiradiobutton(app.ModelButtonGroup);
            app.RescorlaWagnerButton.Text = 'Rescorla-Wagner';
            app.RescorlaWagnerButton.Position = [11 133 115 22];
            app.RescorlaWagnerButton.Value = true;

            % Create MackintoshButton
            app.MackintoshButton = uiradiobutton(app.ModelButtonGroup);
            app.MackintoshButton.Text = 'Mackintosh';
            app.MackintoshButton.Position = [11 109 83 22];

            % Create PearceHallButton
            app.PearceHallButton = uiradiobutton(app.ModelButtonGroup);
            app.PearceHallButton.Text = 'Pearce-Hall';
            app.PearceHallButton.Position = [11 85 85 22];

            % Create EsberHaselgroveButton
            app.EsberHaselgroveButton = uiradiobutton(app.ModelButtonGroup);
            app.EsberHaselgroveButton.Text = 'Esber-Haselgrove';
            app.EsberHaselgroveButton.Position = [11 62 118 22];

            % Create SchmajukPHButton
            app.SchmajukPHButton = uiradiobutton(app.ModelButtonGroup);
            app.SchmajukPHButton.Text = 'Schmajuk-P-H';
            app.SchmajukPHButton.Position = [11 39 99 22];

            % Create TDButton
            app.TDButton = uiradiobutton(app.ModelButtonGroup);
            app.TDButton.Text = 'Temporal-Difference';
            app.TDButton.Position = [11 17 130 22];

            % Create RunButton
            app.RunButton = uibutton(app.ClassicalConditioningClosetFigure, 'push');
            app.RunButton.ButtonPushedFcn = createCallbackFcn(app, @RunButtonPushed, true);
            app.RunButton.Position = [964 288 129 26];
            app.RunButton.Text = 'Run!';

            % Create ExperimentTemplateListBoxLabel
            app.ExperimentTemplateListBoxLabel = uilabel(app.ClassicalConditioningClosetFigure);
            app.ExperimentTemplateListBoxLabel.HorizontalAlignment = 'center';
            app.ExperimentTemplateListBoxLabel.Position = [973 519 118 22];
            app.ExperimentTemplateListBoxLabel.Text = 'Experiment Template';

            % Create ExperimentTemplateListBox
            app.ExperimentTemplateListBox = uilistbox(app.ClassicalConditioningClosetFigure);
            app.ExperimentTemplateListBox.Items = {'Acq/Ext', 'Blocking', 'Conditioned Inhibition', 'Latent Inhibition', 'Partial Reinforcement', 'PR_w/better predictor', 'PR_w/o better predictor'};
            app.ExperimentTemplateListBox.Position = [946 356 172 164];
            app.ExperimentTemplateListBox.Value = 'Acq/Ext';

            % Create ExperimentScheduleListBoxLabel
            app.ExperimentScheduleListBoxLabel = uilabel(app.ClassicalConditioningClosetFigure);
            app.ExperimentScheduleListBoxLabel.HorizontalAlignment = 'right';
            app.ExperimentScheduleListBoxLabel.Position = [774 519 120 22];
            app.ExperimentScheduleListBoxLabel.Text = 'Experiment Schedule';

            % Create ExperimentScheduleListBox
            app.ExperimentScheduleListBox = uilistbox(app.ClassicalConditioningClosetFigure);
            app.ExperimentScheduleListBox.Items = {};
            app.ExperimentScheduleListBox.FontName = 'Consolas';
            app.ExperimentScheduleListBox.Position = [748 323 173 197];
            app.ExperimentScheduleListBox.Value = {};

            % Create LoadButton
            app.LoadButton = uibutton(app.ClassicalConditioningClosetFigure, 'push');
            app.LoadButton.ButtonPushedFcn = createCallbackFcn(app, @LoadButtonPushed, true);
            app.LoadButton.Position = [979 323 100 22];
            app.LoadButton.Text = 'Load';

            % Create ClearScheduleButton
            app.ClearScheduleButton = uibutton(app.ClassicalConditioningClosetFigure, 'push');
            app.ClearScheduleButton.ButtonPushedFcn = createCallbackFcn(app, @ClearScheduleButtonPushed, true);
            app.ClearScheduleButton.Position = [789 288 90 26];
            app.ClearScheduleButton.Text = 'Clear Schedule';

            % Create AllCheckBox
            app.AllCheckBox = uicheckbox(app.ClassicalConditioningClosetFigure);
            app.AllCheckBox.ValueChangedFcn = createCallbackFcn(app, @AllCheckBoxValueChanged, true);
            app.AllCheckBox.Text = 'All';
            app.AllCheckBox.Position = [215 475 35 22];
            app.AllCheckBox.Value = true;

            % Create CSACheckBox
            app.CSACheckBox = uicheckbox(app.ClassicalConditioningClosetFigure);
            app.CSACheckBox.ValueChangedFcn = createCallbackFcn(app, @CheckBoxValueChanged, true);
            app.CSACheckBox.Text = 'CS A';
            app.CSACheckBox.Position = [276 475 50 22];
            app.CSACheckBox.Value = true;

            % Create CSBCheckBox
            app.CSBCheckBox = uicheckbox(app.ClassicalConditioningClosetFigure);
            app.CSBCheckBox.ValueChangedFcn = createCallbackFcn(app, @CheckBoxValueChanged, true);
            app.CSBCheckBox.Text = 'CS B';
            app.CSBCheckBox.Position = [352 475 50 22];
            app.CSBCheckBox.Value = true;

            % Create CSCCheckBox
            app.CSCCheckBox = uicheckbox(app.ClassicalConditioningClosetFigure);
            app.CSCCheckBox.ValueChangedFcn = createCallbackFcn(app, @CheckBoxValueChanged, true);
            app.CSCCheckBox.Text = 'CS C';
            app.CSCCheckBox.Position = [427 475 51 22];
            app.CSCCheckBox.Value = true;

            % Create alphaACheckBox
            app.alphaACheckBox = uicheckbox(app.ClassicalConditioningClosetFigure);
            app.alphaACheckBox.ValueChangedFcn = createCallbackFcn(app, @CheckBoxValueChanged, true);
            app.alphaACheckBox.Text = '� (A)';
            app.alphaACheckBox.Position = [503 475 48 22];
            app.alphaACheckBox.Value = true;

            % Create alphaBCheckBox
            app.alphaBCheckBox = uicheckbox(app.ClassicalConditioningClosetFigure);
            app.alphaBCheckBox.ValueChangedFcn = createCallbackFcn(app, @CheckBoxValueChanged, true);
            app.alphaBCheckBox.Text = '� (B)';
            app.alphaBCheckBox.Position = [576 475 48 22];
            app.alphaBCheckBox.Value = true;

            % Create alphaCCheckBox
            app.alphaCCheckBox = uicheckbox(app.ClassicalConditioningClosetFigure);
            app.alphaCCheckBox.ValueChangedFcn = createCallbackFcn(app, @CheckBoxValueChanged, true);
            app.alphaCCheckBox.Text = '� (C)';
            app.alphaCCheckBox.Position = [649 475 49 22];
            app.alphaCCheckBox.Value = true;

            % Create YaxisSpinnerLabel
            app.YaxisSpinnerLabel = uilabel(app.ClassicalConditioningClosetFigure);
            app.YaxisSpinnerLabel.HorizontalAlignment = 'right';
            app.YaxisSpinnerLabel.Position = [28 475 38 22];
            app.YaxisSpinnerLabel.Text = 'Y-axis';

            % Create YaxisBottom
            app.YaxisBottom = uispinner(app.ClassicalConditioningClosetFigure);
            app.YaxisBottom.Step = 0.1;
            app.YaxisBottom.ValueDisplayFormat = '%4.2f';
            app.YaxisBottom.ValueChangedFcn = createCallbackFcn(app, @YaxisValueChanged, true);
            app.YaxisBottom.Position = [72 475 59 22];

            % Create YaxisTop
            app.YaxisTop = uispinner(app.ClassicalConditioningClosetFigure);
            app.YaxisTop.Step = 0.1;
            app.YaxisTop.ValueDisplayFormat = '%4.2f';
            app.YaxisTop.ValueChangedFcn = createCallbackFcn(app, @YaxisValueChanged, true);
            app.YaxisTop.Position = [130 475 57 22];
            app.YaxisTop.Value = 1;

            % Show the figure after all components are created
            app.ClassicalConditioningClosetFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ClassicalConditioningCloset_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.ClassicalConditioningClosetFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.ClassicalConditioningClosetFigure)
        end
    end
end
