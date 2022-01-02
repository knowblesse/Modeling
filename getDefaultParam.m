function [param,opt_option] = getDefaultParam()
%% getDefaultParameters
% small script for default model parameters
% @Knowblesse 2021 21JUL21

param = struct(); % for parameters
opt_option = struct(); % for optimization algorithm
% Ax <= b ===> see fmincon for detail

%% Default : Matched Acq/Ext learning curve
param.alpha0.a = 0.5; 
param.alpha0.b = 0.5; 
param.alpha0.c = 0.5; 

% Rescorla-Wagner Model
param.RW.lr_acq.value = 0.1;
param.RW.lr_acq.range = 0.1 : 0.05 : 0.3;

param.RW.lr_ext.value = 0.05;
param.RW.lr_ext.range = 0.05 : 0.05 : 0.3;

opt_option.RW.A = [-1,1];
opt_option.RW.b = [0];

% Mackintosh Model
param.M.lr_acq.value = 0.08;
param.M.lr_acq.range = 0.08 : 0.04 : 0.2;

param.M.lr_ext.value = 0.04;
param.M.lr_ext.range = 0.04 : 0.04 : 0.2;

param.M.k.value = 0.05;
param.M.k.range = 0.05 : 0.05 : 0.5;

param.M.epsilon.value = 0.02;
param.M.epsilon.range = 0.02 : 0.02 : 0.5;

opt_option.M.A = [-1,1,0,0]; % lr_acq >= lr_ext
opt_option.M.b = [0];

% Esber Haselgrove Model
param.EH.lr1_acq.value = 0.05; % lr1 : when delta V >= 0 
param.EH.lr1_acq.range = 0.01 : 0.02 : 0.07;

param.EH.lr2_acq.value = 0.03; % product of two acq lr > product of two ext lr
param.EH.lr2_acq.range = 0.01 : 0.02 : 0.07;

param.EH.lr1_ext.value = 0.04;
param.EH.lr1_ext.range = 0.01 : 0.02 : 0.07;

param.EH.lr2_ext.value = 0.02;
param.EH.lr2_ext.range = 0.01 : 0.02 : 0.07;

param.EH.k.value = 0.2;
param.EH.k.range = 0.1:0.1:0.4;

param.EH.lr_pre.value = 0.02;
param.EH.lr_pre.range = 0.01 : 0.01 : 0.05;

% param.EH.limitV = false;

opt_option.EH.A = [...
    -1, 0, 1, 0, 0, 0;
    0, -1, 0, 1, 0, 0];
opt_option.EH.b = [0,0];

% Schmajuk-Pearson-Hall Model
param.SPH.S.value = 0.3;
param.SPH.S.range = 0.1 : 0.1 : 1;

param.SPH.beta_ex.value = 0.3; %0.1
param.SPH.beta_ex.range = 0.05 : 0.05 : 0.2;

param.SPH.beta_in.value = 0.09;
param.SPH.beta_in.range = 0.05 : 0.05 : 0.2;

param.SPH.gamma.value = 0.2;
param.SPH.gamma.range = 0.1 : 0.1 : 0.3;

opt_option.SPH.A = [0, -1, 1, 0];
opt_option.SPH.b = [0];

end
