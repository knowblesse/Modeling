function param = getDefaultParam()
%% getDefaultParameters
% small script for default model parameters
% @Knowblesse 2021 21JUL21

param = struct();

%% Default : Matched Acq/Ext learning curve
param.alpha0.a = 0.5; 
param.alpha0.b = 0.5; 
param.alpha0.c = 0.5; 

% Rescorla-Wagner Model
param.RW.lr_acq.value = 0.1;
param.RW.lr_acq.range = 0.02 : 0.02 : 0.3;

param.RW.lr_ext.value = 0.05;
param.RW.lr_ext.range = 0.02 : 0.02 : 0.3;

% Mackintosh Model
param.M.lr_acq.value = 0.08;
param.M.lr_acq.range = 0.02 : 0.02 : 0.2;

param.M.lr_ext.value = 0.04;
param.M.lr_ext.range = 0.02 : 0.02 : 0.2;

param.M.k.value = 0.05;
param.M.k.range = 0.02 : 0.02 : 0.2;

param.M.epsilon.value = 0.02;
param.M.epsilon.range = 0.01 : 0.01 : 0.1;

% Pearce-Hall Model
param.PH.SA.value = 0.04;
param.PH.SB.value = 0.04;
param.PH.SC.value = 0.04;

% Esber Haselgrove Model
param.EH.lr1_acq.value = 0.05; % lr1 : when delta V >= 0 
param.EH.lr1_acq.range = 0.01 : 0.01 : 0.2;

param.EH.lr2_acq.value = 0.03; % product of two acq lr > product of two ext lr
param.EH.lr2_acq.range = 0.01 : 0.01 : 0.2;

param.EH.lr1_ext.value = 0.04;
param.EH.lr1_ext.range = 0.01 : 0.01 : 0.2;

param.EH.lr2_ext.value = 0.02;
param.EH.lr2_ext.range = 0.01 : 0.01 : 0.2;

param.EH.k.value = 0.2;
param.EH.k.range = 0.1:0.1:0.5;

param.EH.lr_pre.value = 0.02;
param.EH.lr_pre.range = 0.01 : 0.01 : 0.2;

% param.EH.limitV = false;

% Schmajuk-Pearson-Hall Model
param.SPH.SA.value = 0.3;
param.SPH.SA.range = 0.1 : 0.05 : 0.5;

param.SPH.SB.value = 0.3;
param.SPH.SB.range = 0.1 : 0.05 : 0.5;

% param.SPH.SC.range = 0.3;
% param.SPH.SC.value = 0.1 : 0.05 : 0.5;

param.SPH.beta_ex.value = 0.1;
param.SPH.beta_ex.range = 0.01 : 0.01 : 0.2;

param.SPH.beta_in.value = 0.09;
param.SPH.beta_in.range = 0.01 : 0.01 : 0.2;

param.SPH.gamma.value = 0.2;
param.SPH.gamma.range = 0.05 : 0.05 : 0.3;

% TD Model
param.TD.table.Data = table(1,4,1,4,1,4,9,10,50);
param.TD.beta = 0.875;
param.TD.c = 0.08;
param.TD.gamma = 0.95;
end
