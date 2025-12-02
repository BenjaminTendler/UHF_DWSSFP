function [optScanner,optSample,optSSFP,optSTE,optSE] = ParameterOptions()
%%
%Scanner properties
optScanner.MaxReadout=30;                       % Maximum Readout Duration (ms)
optScanner.GMax=52;                             % Maximum Gradient Stength (mT/m)
optScanner.gamma=2*pi*42.58*10^6;               % Gyromagnetic ratio
optScanner.DeadTime=5;                          % Minimum Time between Diffusion Gradient and Readout (ms)
%%
%Sample Properties
optSample.T1=1350;                              % T1 (ms)
optSample.T2=28;                                % T2 (ms)
optSample.T2s=optSample.T2/2;                   % T2 star (ms) - used to estimate signal-loss due to non-centred DW-SSFP echo. Set equal to T2 to ignore contribution
optSample.D=0.2;                                % Diffusion coefficient (um2/ms)
%%
%Acquisition Resolution
optSSFP.Resolution=0.4;                         % Define Target Resolution (mm) (SSFP optimisation can do a post-step to ensure 2*pi*n dephasing)

%%
%Initialisation Parameters for Optimisation
%The following parameters can be left as is unless you are optimising in a very different relaxation/diffusion/b-value regime
%%
%Initial sequence parameters - SSFP
optSSFP.G=optScanner.GMax;                      % Diffusion Gradient Amplitude (mT/m)
optSSFP.tau=13.56;                              % Diffusion Gradient Duration (ms)
optSSFP.TR=28;                                  % Repetition Time (ms)
optSSFP.alpha=24;                               % Flip angle (o)
%%
%Initial sequence parameters - SE (Note: Mixing time estimated in STE code from b-value definition)
optSTE.G=optScanner.GMax;                       % Diffusion Gradient Amplitude (mT/m)
optSTE.tau=10;                                  % Diffusion Gradient Duration (ms)
optSTE.TR=1000;                                 % Repetition Time (ms)
optSTE.TE=2*optSTE.tau+10;                      % Echo Time (ms) - Only used for STE optimisation
%%
%Initial sequence parameters - SE (Note: Diffusion time estimated in SE code from b-value definition)
optSE.G=optScanner.GMax;                       % Diffusion Gradient Amplitude (mT/m)
optSE.tau=10;                                  % Diffusion Gradient Duration (ms)
optSE.TR=1000;                                 % Repetition Time (ms)




