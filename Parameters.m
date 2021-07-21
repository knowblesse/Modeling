%% CCC parameters
% small script for model parameter tracking
% @Knowblesse 2021 21JUL21

app = struct();

%% Default : Matched Acq/Ext learning curve
app.alpha_A.Value = 0.5; 
app.alpha_B.Value = 0.5; 
app.alpha_C.Value = 0.5; 

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
