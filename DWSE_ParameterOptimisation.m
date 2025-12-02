clear all
%%
%Identify optimal SNR Efficient Parameters for a target DW-SE b-value
%%
%Define target b-value to optimise (ms/um^2 - multiply by 1,000 for s/mm^2)
b=6;
%%
%Define Initial Parameters
[optScanner,optSample,~,~,optSE] = ParameterOptions();
%%
%Perform DW-SSFP Parameter Optimisation
[Optimised,SNR_eff_SE,bEff_SE,fit_out_SE] = DWSE_Optimisation(optSample,optScanner,optSE,b);
%%
%Print Outputs
fprintf('\n')
fprintf('DW-SE\n')
fprintf('SNR Efficiency = %.3g%%. Target b-value = %.3g. Effective b-value = %.3g.\n', SNR_eff_SE*100,b,bEff_SE)
fprintf('Gradient Strength = %.3g mT/m. Gradient Duration = %.3g ms. Diffusion Time = %.3g ms. TE = %.3g ms. TR = %.3g ms. Readout Duration = %.3g ms.\n\n', Optimised.SE(1), Optimised.SE(2), Optimised.SE(4), Optimised.SE(5), Optimised.SE(3), Optimised.SE(6))