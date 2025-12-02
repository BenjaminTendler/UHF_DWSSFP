function [Optimised,SNR_eff_SSFP,bEff_SSFP,fit_out_SSFP] = DWSSFP_Optimisation(optSample,optScanner,optSSFP,b)
%%
%Perform DW-SSFP Parameter Optimisation
%%
%Define fitting options
options = optimoptions(@lsqnonlin,'Display','off','Algorithm','levenberg-marquardt','FunctionTolerance',1E-10,'OptimalityTolerance',1E-10,'StepTolerance',1E-10);
%%
%Define fitting function
f=@(x)DWSSFP_SNREfficiency(x,optSample,optScanner,b);
%Perform fitting
[fit_out_SSFP]=lsqnonlin(f,[optSSFP.G,optSSFP.tau,optSSFP.TR-optSSFP.tau-optScanner.DeadTime,optSSFP.alpha],[0,0,1,1],[optScanner.GMax,40,100,179],options);
%Reconstruct estimated SNR efficiency & effective b-value
[SNR_eff_SSFP,bEff_SSFP]=DWSSFP_SNREfficiency(fit_out_SSFP,optSample,optScanner);
%Define optimal parameters (G, tau, TR, alpha, q, TE)
Optimised.SSFP=[fit_out_SSFP(1),fit_out_SSFP(2),fit_out_SSFP(2)+fit_out_SSFP(3)+optScanner.DeadTime,fit_out_SSFP(4),optScanner.gamma.*fit_out_SSFP(2).*fit_out_SSFP(1)/(2*pi)/10^9,fit_out_SSFP(2)+fit_out_SSFP(3)/2+optScanner.DeadTime];
