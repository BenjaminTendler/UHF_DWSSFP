clear all
%%
%Identify optimal SNR Efficient Parameters for a target DW-SSFP b-value
%%
%Define target effective b-value to optimise (ms/um^2 - multiply by 1,000 for s/mm^2)
b=6;
%%
%Define Initial Parameters
[optScanner,optSample,optSSFP,~,~] = ParameterOptions();
%%
%Perform DW-SSFP Parameter Optimisation
[Optimised,SNR_eff_SSFP,bEff_SSFP,fit_out_SSFP] = DWSSFP_Optimisation(optSample,optScanner,optSSFP,b);
%Print Outputs
fprintf('\n')
fprintf('DW-SSFP\n')
fprintf('SNR Efficiency = %.3g%%. Target b-value = %.3g. Effective b-value = %.3g.\n', SNR_eff_SSFP*100,b,bEff_SSFP)
fprintf('Gradient Strength = %.3g mT/m. Gradient Duration = %.3g ms. q = %.3g /mm.  flip angle = %.3g degrees. TR = %.3g ms. TE = %.3g ms.\n\n', Optimised.SSFP(1), Optimised.SSFP(2), Optimised.SSFP(5), Optimised.SSFP(4), Optimised.SSFP(3), Optimised.SSFP(6))
%%
%Perform correction to account for 2*pi dephasing condition
[Optimised,SNR_eff_SSFP_2pi,bEff_SSFP_2pi,fit_out_SSFP_2pi] = DWSSFP_Optimisation_2piDephasing(optSample,optScanner,optSSFP,Optimised,fit_out_SSFP);
fprintf('DW-SSFP (2pi dephasing condition) \n')
fprintf('SNR Efficiency = %.3g%%. Target b-value = %.3g. Effective b-value = %.3g.\n', SNR_eff_SSFP_2pi*100,b,bEff_SSFP_2pi)
fprintf('Gradient Strength = %.3g mT/m. Gradient Duration = %.3g ms. q = %.3g /mm.  flip angle = %.3g degrees. TR = %.3g ms. TE = %.3g ms.\n\n', Optimised.SSFP_2pi(1), Optimised.SSFP_2pi(2), Optimised.SSFP_2pi(5), Optimised.SSFP_2pi(4), Optimised.SSFP_2pi(3), Optimised.SSFP_2pi(6))
%%
%Provide reduced gradient amplitudes that achieve 2*pi*n dephasing with all other properties matched (useful for multi-shell acquisitions or identification of 'b0'-equivalent scans)
[GArr,qArr,~] = qValue(optSSFP.Resolution,fit_out_SSFP_2pi(2),fit_out_SSFP_2pi(1),optScanner.gamma);
%Calculate effective b-value for each gradient amplitude
fprintf('Table of gradient amplitudes that lead to 2*pi*n dephasing with all other parameters matched (useful for multi-shell acquisitions) \n \n')
for k=1:length(GArr)
    [~,bEff_SSFP_2pi_G(k)]=DWSSFP_SNREfficiency([GArr(k),fit_out_SSFP_2pi(2:end)],optSample,optScanner);
    fprintf('Diffusion Gradient Amplitude G = %.3g. mT/m. q = %.3g. /mm, dephasing = %i*pi, Effective b-value = %.3g.\n', GArr(k), qArr(k), k*2, bEff_SSFP_2pi_G(k))
end