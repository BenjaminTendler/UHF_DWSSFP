%%
%Identify optimal SNR Efficiency as function of b-value for the DW-SSFP, DW-SE and DW-STE sequence
%%
%Define Output Path for Figure
OutputPath='YOUR/OUTPUT/PATH/';
%%
%Define Parameters
[optScanner,optSample,optSSFP,optSTE,optSE] = ParameterOptions();
%%
%Define array of b-values to optimise (ms/um^2 - multiply by 1,000 for s/mm^2)
b=[1:10];
%%
%SSFP Optimisation
for k=1:length(b)
    %Perform Optimisation
    [~,SNR_eff_SSFP(k),bEff_SSFP(k),fit_out_SSFP(k,:)] = DWSSFP_Optimisation(optSample,optScanner,optSSFP,b(k));
    %Update Initial Parameters
    optSSFP.G=fit_out_SSFP(k,1);optSSFP.tau=fit_out_SSFP(k,2);optSSFP.TR=fit_out_SSFP(k,2)+fit_out_SSFP(k,3)+optScanner.DeadTime;optSSFP.alpha=fit_out_SSFP(k,4);
end
%%
%STE Optimisation
for k=1:length(b)
    %Perform Optimisation    
    [~,SNR_eff_STE(k),bEff_STE(k),fit_out_STE(k,:)] = DWSTE_Optimisation(optSample,optScanner,optSTE,b(k));
    %Update Initial Parameters
    optSTE.G=fit_out_STE(k,1)*10;optSTE.tau=fit_out_STE(k,2)*10;optSTE.TE=2*fit_out_STE(k,2)*10+fit_out_STE(k,3)*10;optSTE.TR=fit_out_STE(k,4)*1000;
end
%%
%SE Optimisation
%Reset Parameter opt
for k=1:length(b)
    %Perform Optimisation
    [~,SNR_eff_SE(k),bEff_SE(k),fit_out_SE(k,:)] = DWSE_Optimisation(optSample,optScanner,optSE,b(k));
    %Update Initial Parameters
    optSE.G=fit_out_SE(k,1)*10;optSE.tau=fit_out_SE(k,2)*10;optSE.TR=fit_out_SE(k,3)*1000;
end
%%
%Plot
figure;plot(b,SNR_eff_SSFP*100,'linewidth',4)
hold all;plot(b,SNR_eff_STE*100,'linewidth',4)
hold all;plot(b,SNR_eff_SE*100,'linewidth',4)
legend('DW-SSFP','DW-STE','DW-SE');
title('SNR Efficiency')
xlabel('b (x10^3 s/mm^2)');
ylabel('SNR Efficiency (% of S_0)');
xlim([1,10]);
set(findall(gcf,'-property','FontSize'),'FontSize',16)
%%
%Save Figure
exportgraphics(gcf,[OutputPath,'Figure3.png'],Resolution=300)
savefig([OutputPath,'Figure3.fig'])