function [Optimised,SNR_eff_STE,bEff_STE,fit_out_STE] = DWSTE_Optimisation(optSample,optScanner,optSTE,b)
%%
%Perform DW-SE Parameter Optimisation
%%
%Define fitting options
options = optimoptions(@lsqnonlin,'Display','off','Algorithm','levenberg-marquardt','FunctionTolerance',1E-10,'OptimalityTolerance',1E-10,'StepTolerance',1E-10);
%%
%Define fitting function
f=@(x)DWSTE_SNREfficiency(x,optSample,optScanner,b,1); 
%Perform fitting - Note that the fitting algorithm prefers when the input parameters (e.g. G, tau, TE & TR) are of the same scale. 
[fit_out_STE]=lsqnonlin(f,[optSTE.G/10,optSTE.tau/10,(optSTE.TE-2*optSTE.tau)/10,optSTE.TR/1000],[1/10,1/10,0,100/1000],[optScanner.GMax/10,40/10,50/10,10000/1000],options);
%Reconstruct estimated SNR efficiency & estimated b-value.
[SNR_eff_STE,bEff_STE,Tmix_STE]=DWSTE_SNREfficiency(fit_out_STE,optSample,optScanner,b);
%Define optimal parameters (G, tau, TE, TR, Mixing Time, Readout Duration)
Optimised.STE=[fit_out_STE(1)*10,fit_out_STE(2)*10,2*fit_out_STE(2)*10+fit_out_STE(3)*10,fit_out_STE(4)*1000,Tmix_STE,(2*fit_out_STE(2)*10+fit_out_STE(3)*10)-2*(optScanner.DeadTime+fit_out_STE(2)*10)];
       
