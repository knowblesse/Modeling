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

% Pearson-Hall Model
app.paramPH_SA.Value = 0.02;
app.paramPH_SB.Value = 0.02;
app.paramPH_SC.Value = 0.02;

% Esber Haselgrove Model
app.paramEH_lr1_acq.Value = 0.04; % lr1 : when delta V >= 0 
app.paramEH_lr2_acq.Value = 0.03; % Phi(2 acq lr) must be larger than Phi(2 ext lr)
app.paramEH_lr1_ext.Value = 0.01;
app.paramEH_lr2_ext.Value = 0.01;
app.paramEH_k = 0.2;
app.paramEH_lr_pre = 0.02;

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

%% Setup
% 'Rescorla-Wagner' 'Mackintosh' 'Pearson-Hall' 'Schmajuk-P-H' 'Esber-Haselgrove'

% Schedule
% +------+------+------+------+----------+---------+---------+--------+
% | Col1 | Col2 | Col3 | Col4 |   Col5   |  Col6   |  Col7   |  Col8  |
% +------+------+------+------+----------+---------+---------+--------+
% | CS A | CS B | CS C | US   | alpha A  | alpha B | alpha C | lambda |
% +------+------+------+------+----------+---------+---------+--------+
schedule_acq_ext = [...
    repmat([1,0,0,1,0.5,0.5,0.5,1], 100,1);...
    repmat([1,0,0,0,0.5,0.5,0.5,0], 100,1)...
    ];

schedule_blocking = [...
    repmat([1,0,0,1,0.5,0.5,0.5,1], 20,1);...
    repmat([1,1,0,1,0.5,0.5,0.5,1], 100,1)...
    ];

schedule_latent_inhibition = [...
    repmat([1,0,0,0,0.5,0.5,-0.5,0], 100,1);...
    repmat([1,0,0,1,0.5,0.5,0.5,1], 100,1)...
    ];

% 100x0.25 000x0.75 % EV = 25 Shannon E = 0.8113
schedule1 = [...
    1,0,0,1,0.2,0.2,0.2,1;...
    1,0,0,0,0.2,0.2,0.2,0;...
    1,0,0,0,0.2,0.2,0.2,0;...
    1,0,0,0,0.2,0.2,0.2,0;...
    ];

% 50x0.25 30x0.25 10x0.50 % EV = 25 Shannon E = 1.5
schedule2 = [...
    1,0,0,1,0.2,0.2,0.2,0.50;...
    1,0,0,1,0.2,0.2,0.2,0.30;...
    1,0,0,1,0.2,0.2,0.2,0.10;...
    1,0,0,1,0.2,0.2,0.2,0.10;...
    ];

% 90x0.25 75x0.25 25x0.25 10x0.25 % EV = 50 Shannon E = 2
schedule3 = [...
    1,0,0,1,0.2,0.2,0.2,0.90;...
    1,0,0,1,0.2,0.2,0.2,0.75;...
    1,0,0,1,0.2,0.2,0.2,0.25;...
    1,0,0,1,0.2,0.2,0.2,0.10;...
    ];

% 90x0.25 75x0.25 25x0.25 10x0.25 % EV = 50 Shannon E = 2
% schedule4 = [...
%     1,0,0,1,0.2,0.2,0.2,0.90;...
%     1,0,0,1,0.2,0.2,0.2,0.90;...
%     1,0,0,1,0.2,0.2,0.2,0.90;...
%     1,0,0,1,0.2,0.2,0.2,0.90;...
%     1,0,0,1,0.2,0.2,0.2,0.90;...
%     1,0,0,1,0.2,0.2,0.2,0.90;...
%     1,0,0,1,0.2,0.2,0.2,0.90;...
%     1,0,0,1,0.2,0.2,0.2,0.75;...
%     1,0,0,1,0.2,0.2,0.2,0.25;...
%     1,0,0,1,0.2,0.2,0.2,0.10;...
%     ];

schedule4 = [...
    1,0,0,1,0.2,0.2,0.2,0.74;...
    ];


schedule5 = [...
    1,0,0,1,0.2,0.2,0.2,0.25;...
    ];

schedule_continuous_1 = [...
    1,0,0,1,0.5,0.5,0.5,1;...
    1,0,0,1,0.5,0.5,0.5,1;...
    ];
schedule_partial_2 = [...
    1,0,0,0,0.5,0.5,0.5,1;...
    1,0,0,1,0.5,0.5,0.5,2;...
    ];
schedule_continuous_2 = [...
    1,0,0,1,0.5,0.5,0.5,2;...
    1,0,0,1,0.5,0.5,0.5,2;...
    ];
schedule_partial_1 = [...
    1,0,0,0,0.5,0.5,0.5,1;...
    1,0,0,1,0.5,0.5,0.5,1;...
    ];

%mode = 3;
num_schedule = 1;

%schedule = eval(strcat('repmat(schedule',num2str(num_schedule),', 50,1);'));
sche_names = {'schedule_continuous_1','schedule_continuous_2','schedule_partial_1','schedule_partial_2'};


colorData = {'#4DBEEE', '#0072BD', 	'#A2142F', '#D95319'};
%schedule = schedule_blocking;
plot_multiCS = false;
ppp = 4;


fig2 = figure(2);
%fig2.Position = [0,300,900,600];
clf(fig2);
for ppp = 1 : 4
    schedule = eval(strcat('[repmat(',sche_names{ppp},',50,1);repmat([1,0,0,0,0.5,0.5,0.5,1],50,1)];'));
    for mode = 1 : 4
        ax = subplot(2,2,mode,'Parent',fig2);
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


        %% Run Multiple Times
        numRepeat = 100;
        rep = struct();
        rep.V = zeros(size(schedule,1)+1,3,numRepeat);
        rep.V_pos = zeros(size(schedule,1)+1,3,numRepeat); % V value for S-P-H model, V_dot(=V_pos - V_bar) is assigned to V instead
        rep.V_bar = zeros(size(schedule,1)+1,3,numRepeat);
        rep.alpha = zeros(size(schedule,1)+1,3,numRepeat);


        %% Run
        for rrr = 1 : numRepeat
            app.V = zeros(size(schedule,1)+1,3);
            app.V_pos = zeros(size(schedule,1)+1,3); % V value for S-P-H model, V_dot(=V_pos - V_bar) is assigned to V instead
            app.V_bar = zeros(size(schedule,1)+1,3);
            app.alpha = zeros(size(schedule,1)+1,3);
            app.numTrial = 1;

            %schedule = schedule(randperm(size(schedule,1)),:);

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

            rep.V(:,:,rrr) = app.V;
            rep.alpha(:,:,rrr) = app.alpha;
        end
        %% Plot 
        if plot_multiCS
            plot_shade(ax,mean(squeeze(rep.V(:,1,:)),2),std(squeeze(rep.V(:,1,:)),0,2));
            plot_shade(ax,mean(squeeze(rep.V(:,2,:)),2),std(squeeze(rep.V(:,2,:)),0,2),'Color','#4DBEEE','Shade',false);

            if mode == 4 
                yyaxis right;
                ax = gca;
                ax.YAxis(1).Color = 'k';
                ax.YAxis(2).Color = 'k';
                ylabel('alpha');
            end
            plot_shade(ax,mean(squeeze(rep.alpha(:,1,:)),2),std(squeeze(rep.alpha(:,1,:)),0,2),'LineStyle','-.','Shade',false);
            plot_shade(ax,mean(squeeze(rep.alpha(:,2,:)),2),std(squeeze(rep.alpha(:,2,:)),0,2),'LineStyle','--','Color','#4DBEEE','Shade',false);

            if mode == 4
                ylim([0,2]);
            else
                ylim([0,1]);
            end
            %legend({'V_A', '1 sd', 'V_B', '1 sd', 'alpha_A', '1 sd','alpha_B','1 sd'});
            legend({'V_A', 'V_B', 'alpha_A','alpha_B',});
            xlim([0,size(schedule,1)]);
        else
            plot_shade(ax,mean(squeeze(rep.V(:,1,:)),2),std(squeeze(rep.V(:,1,:)),0,2),'Shade',false,'Color',colorData{ppp});

    %         if mode == 4 
    %             yyaxis right;
    %             ax.YAxis(1).Color = 'k';
    %             ax.YAxis(2).Color = 'k';
    %             ylabel('alpha');
    %         end
            %plot_shade(ax,mean(squeeze(rep.alpha(:,1,:)),2),std(squeeze(rep.alpha(:,1,:)),0,2),'LineStyle','--','Shade',false,'Color',colorData{ppp});
            if mode == 4
                ylim([0,2]);
            else
                ylim([0,1]);
            end
            legend({'V_A','alpha_A'});
            %legend({'V', '1 sd', 'alpha A', '1 sd'});
            xlim([0,size(schedule,1)]);
            legend({'Continuous-1','Continuous-2','Partial-1','Partial-2'});
            ylim([0,2]);
        end
        title(strcat(selectedButton.Text))
    end
end

%saveas(fig2,strcat(selectedButton.Text,'_',num2str(num_schedule)),'png');
