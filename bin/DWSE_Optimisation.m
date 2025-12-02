function [Optimised,SNR_eff_SE,bEff_SE,fit_out_SE] = DWSE_Optimisation(optSample,optScanner,optSE,b)
%%
%Perform DW-SE Parameter Optimisation
%%
%Define fitting options
options = optimoptions(@lsqnonlin,'Display','off','Algorithm','levenberg-marquardt','FunctionTolerance',1E-10,'OptimalityTolerance',1E-10,'StepTolerance',1E-10);
%%
%Define fitting function
f=@(x)DWSE_SNREfficiency(x,optSample,optScanner,b,1);
%Perform fitting - Note that the fitting algorithm prefers when the input parameters (e.g. G, tau & TR) are of the same scale.
[fit_out_SE]=lsqnonlin(f,[optSE.G/10,optSE.tau/10,optSE.TR/1000],[1/10,1/10,100/1000],[optScanner.GMax/10,40/10,10000/1000],options);
%Reconstruct estimated SNR efficiency, estimated b-value and diffusion time
[SNR_eff_SE,bEff_SE,Delta_SE]=DWSE_SNREfficiency(fit_out_SE,optSample,optScanner,b);
%Define optimal parameters (G, tau, TR, Delta, TE, Readout)
Optimised.SE=[fit_out_SE(1)*10,fit_out_SE(2)*10,fit_out_SE(3)*1000,Delta_SE,Delta_SE*2,(Delta_SE-optScanner.DeadTime-fit_out_SE(2)*10)*2];
