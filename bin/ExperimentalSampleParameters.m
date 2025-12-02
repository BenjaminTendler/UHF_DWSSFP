function [optSample] = ExperimentalSampleParameters()
%Incorporate Experimental Sample Properties
%%
optSample.T1=1046;                              % T1 (ms)
optSample.T2=53.4;                              % T2 (ms)
optSample.T2s=23.65;                            % T2 star (ms) - used to estimate signal-loss due to non-centred DW-SSFP echo. Set equal to T2 to ignore contribution
optSample.D=0.2;                                % Diffusion coefficient (um2/ms)
