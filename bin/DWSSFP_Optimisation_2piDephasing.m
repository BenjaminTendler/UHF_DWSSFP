function [Optimised,SNR_eff_SSFP_2pi,bEff_SSFP_2pi,fit_out_SSFP_2pi] = DWSSFP_Optimisation_2piDephasing(optSample,optScanner,optSSFP,Optimised,fit_out_SSFP)
%%
%Perform correction for DW-SSFP 2*pi dephasing condition
%%
%Initialise arrays
fit_out_SSFP_2pi = fit_out_SSFP;
Optimised.SSFP_2pi = Optimised.SSFP;
%%
%Identify maximum diffusion gradient duration that gives rise to 2*pi*n dephasing for target b-value
[~,qArr,tauArr] = qValue(optSSFP.Resolution,fit_out_SSFP(2),fit_out_SSFP(1),optScanner.gamma);
%%
%Update diffusion gradient duration
fit_out_SSFP_2pi(2) = tauArr(end);
Optimised.SSFP_2pi(2) =  tauArr(end);
%Update q-value
Optimised.SSFP_2pi(5) = qArr(end);
%%
%Reconstruct estimated SNR efficiency & effective b-value
[SNR_eff_SSFP_2pi,bEff_SSFP_2pi]=DWSSFP_SNREfficiency(fit_out_SSFP_2pi,optSample,optScanner);

