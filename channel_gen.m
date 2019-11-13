clear all; close all; clc

%% Generate channel responses in a specifi cell

% This file contains the code to generate channel responses, which follows the
% principles of geometry-based stochastic channel model :
% Molisch, Andreas F., et al. "Geometry based directional model for mobile radio channels¡ªprinciples and implementation." 
% European Transactions on Telecommunications 14.4 (2003): 351-359.
% And utilize the parameters from 3GPP technical report:
% 3GPP TR 25.996 version 11.0.0 Release 11

% Please refer to the following paper for the details:
% Ding, Yacong, and Bhaskar D. Rao. "Dictionary Learning Based Sparse Channel Representation and Estimation for FDD Massive MIMO Systems." 
% arXiv preprint arXiv:1612.06553 (2016).
%% cell specific parameters
%% Yasser 


Nts = 4;                    % number of total scattering clusters
Nfs = 3;                    % number of fixed location scattering clusters
Nsub = 20;                  % number of subpaths in each scattering cluster
alpha=0.5;                  % use half wavelength as antenna spacing

% locations of fixed scattering clusters:
% [distance from the BS    AOA/AOD relative to the broadside of BS]
fsc_pos=[300 60; 
         300 30; 
         300 -30; 
         300 -60; 
         450 45;
         450 -45;
         450 0];       
     
% parameter related to the cell
load('sigma.mat')

%% antenna specific parameters

Nb = 100;                       % number of antennas at base station
Nu = 1;                         % number of antennas at user side
gain = ones(Nb,1);              % antenna gains : equal gain
ante_loc = (0: 1: Nb-1)';       % antenna positions : equal spacing

%% generate channel responses

L = 10000;      % number of channel snapshots
H=zeros(Nb,L);
paramh.Nb = Nb;
paramh.Nu = Nu;
paramh.Nts = Nts;
paramh.Nsub = Nsub;
paramh.Nfs = Nfs;
paramh.fsc_pos = fsc_pos;
paramh.alpha = alpha;
paramh.sigma_AS = sigma_AS;
paramh.sigma_DS = sigma_DS; 
paramh.sigma_SF = sigma_SF;
paramh.gain = gain;
paramh.ante_loc = ante_loc;

% generate the channel
for k = 1 : L
    % user locations
    user_pos(1,1)=rand(1,1)*700+500;    % distance from the BS
    user_pos(1,2)=rand(1,1)*180-90;     % AOA/AOD relative to the broadside of BS array
    
    % channel sanpshots
    H(:,k) = gen_scm(user_pos, paramh);
    H(:,k)=H(:,k)/norm(H(:,k));
end

save('paramh.mat','paramh') 
save('ChannelTraining.mat','H');
