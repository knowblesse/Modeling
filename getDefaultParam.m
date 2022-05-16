function [param,opt_option] = getDefaultParam()
%% getDefaultParameters
% small script for default model parameters
% @Knowblesse 2021 21JUL21

param = struct(); % for parameters
opt_option = struct(); % for optimization algorithm
% Ax <= b ===> see fmincon for detail

param.alpha0.a = 0.5; 
param.alpha0.b = 0.5; 
param.alpha0.c = 0.5; 

%% Rescorla-Wagner Model
param.RW.lr_acq.value = 0.1;
param.RW.lr_acq.range = [0.05, 0.3];

param.RW.lr_ext.value = 0.05;
param.RW.lr_ext.range = [0.05, 0.3];

opt_option.RW.A = [-1,1]; % lr_acq >= lr_ext
opt_option.RW.b = [0];

%% Mackintosh Model
param.M.lr_acq.value = 0.08;
param.M.lr_acq.range = [0.05, 0.3];

param.M.lr_ext.value = 0.04;
param.M.lr_ext.range = [0.05, 0.3];

param.M.k.value = 0.05;
param.M.k.range = [0.05, 0.5];

param.M.epsilon.value = 0.02;
param.M.epsilon.range = [0.01, 0.5];

opt_option.M.A = [-1,1,0,0]; % lr_acq >= lr_ext
opt_option.M.b = [0];

%% Schmajuk-Pearson-Hall Model
param.SPH.S.value = 0.3;
param.SPH.S.range = [0.1, 1];

param.SPH.beta_ex.value = 0.3; %0.1
param.SPH.beta_ex.range = [0.05, 0.5];

param.SPH.beta_in.value = 0.09;
param.SPH.beta_in.range = [0.05, 0.5];

param.SPH.gamma.value = 0.2;
param.SPH.gamma.range = [0.05, 0.5];

opt_option.SPH.A = [0, -1, 1, 0]; % lr_acq >= lr_ext
opt_option.SPH.b = [0];

%% Esber Haselgrove Model
param.EH.lr1_acq.value = 0.05; % lr1 : when delta V >= 0 
param.EH.lr1_acq.range = [0.005, 0.7];

param.EH.lr2_acq.value = 0.03; 
param.EH.lr2_acq.range = [0.005, 0.7];

param.EH.lr1_ext.value = 0.04;
param.EH.lr1_ext.range = [0.005, 0.7];

param.EH.lr2_ext.value = 0.02;
param.EH.lr2_ext.range = [0.005, 0.7];

param.EH.k.value = 0.2;
param.EH.k.range = [0.1, 0.8];

param.EH.lr_pre.value = 0.05;
param.EH.lr_pre.range = [0.05, 0.5];

% According to the thesis, a condition, product of two acq lr > product of two ext lr,
% should be satisfied to simulate partial conditioning.
% However, I ignored the condition, and just made the acquisition learning rate is
% always equal or grater than the corresponding extinction learning rate
% param.EH.limitV = false;

opt_option.EH.A = [...
    -1, 0, 1, 0, 0, 0;...
     0,-1, 0, 1, 0, 0];
opt_option.EH.b = [0; 0];

end
