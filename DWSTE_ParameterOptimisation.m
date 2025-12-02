clear all
%%
%Identify optimal SNR Efficient Parameters for a target DW-SE b-value
%%
%Define target b-value to optimise (ms/um^2 - multiply by 1,000 for s/mm^2)
b=6;
%%
%Define Initial Parameters
[optScanner,optSample,~,optSTE,~] = ParameterOptions();
%%
%Perform DW-SSFP Parameter Optimisation
[Optimised,SNR_eff_STE,bEff_STE,fit_out_STE] = DWSTE_Optimisation(optSample,optScanner,optSTE,b);
%%
%Print Outputs
fprintf('\n')
fprintf('DW-STE\n')
fprintf('SNR Efficiency = %.3g%%. Target b-value = %.3g. Effective b-value = %.3g.\n', SNR_eff_STE*100,b,bEff_STE)
fprintf('Gradient Strength = %.3g mT/m. Gradient Duration = %.3g ms. Mixing Time = %.3g s. TE = %.3g ms. TR = %.3g ms.  Readout Duration = %.3g ms.\n\n', Optimised.STE(1), Optimised.STE(2), Optimised.STE(5), Optimised.STE(3), Optimised.STE(4), Optimised.STE(6))