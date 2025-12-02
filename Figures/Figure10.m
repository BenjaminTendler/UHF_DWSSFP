%%
%Identify optimal SNR Efficiency as function of b-value for the DW-SSFP, DW-SE and DW-STE sequence 
%Comparison of original & updated relaxation times
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
for l=1:2
    %%
    %SSFP Optimisation
    for k=1:length(b)
        %Perform Optimisation
        [~,SNR_eff_SSFP(k,l),bEff_SSFP(k,l),fit_out_SSFP(k,:,l)] = DWSSFP_Optimisation(optSample,optScanner,optSSFP,b(k));
        %Update Initial Parameters
        optSSFP.G=fit_out_SSFP(k,1,l);optSSFP.tau=fit_out_SSFP(k,2,l);optSSFP.TR=fit_out_SSFP(k,2,l)+fit_out_SSFP(k,3,l)+optScanner.DeadTime;optSSFP.alpha=fit_out_SSFP(k,4,l);
    end
    %%
    %STE Optimisation
    for k=1:length(b)
        %Perform Optimisation    
        [~,SNR_eff_STE(k,l),bEff_STE(k,l),fit_out_STE(k,:,l)] = DWSTE_Optimisation(optSample,optScanner,optSTE,b(k));
        %Update Initial Parameters
        optSTE.G=fit_out_STE(k,1,l)*10;optSTE.tau=fit_out_STE(k,2,l)*10;optSTE.TE=2*fit_out_STE(k,2,l)*10+fit_out_STE(k,3,l)*10;optSTE.TR=fit_out_STE(k,4,l)*1000;
    end
    %%
    %SE Optimisation
    %Reset Parameter opt
    for k=1:length(b)
        %Perform Optimisation
        [~,SNR_eff_SE(k,l),bEff_SE(k,l),fit_out_SE(k,:,l)] = DWSE_Optimisation(optSample,optScanner,optSE,b(k));
        %Update Initial Parameters
        optSE.G=fit_out_SE(k,1,l)*10;optSE.tau=fit_out_SE(k,2,l)*10;optSE.TR=fit_out_SE(k,3,l)*1000;
    end
    %%
    %Reintiialise Parameters
    [optScanner,~,optSSFP,optSTE,optSE] = ParameterOptions();
    %Update Sample Properties
    [optSample] = ExperimentalSampleParameters();
end
%%
%Estimate increase in SNR efficiency
fprintf('Average increase in SNR efficiency (DW-SSFP) = %.3g%% \n', mean(SNR_eff_SSFP(:,2)./SNR_eff_SSFP(:,1))*100)
fprintf('Average increase in SNR efficiency (DW-SE) = %.3g%% \n', mean(SNR_eff_SE(:,2)./SNR_eff_SE(:,1))*100)
fprintf('Average increase in SNR efficiency (DW-STE) = %.3g%% \n', mean(SNR_eff_STE(:,2)./SNR_eff_STE(:,1))*100)
%%
%Plot
RGB =  get(groot,"FactoryAxesColorOrder");
figure;plot(b,SNR_eff_SSFP(:,2)*100,'linewidth',4,'color',RGB(1,:))
hold all;plot(b,SNR_eff_STE(:,2)*100,'linewidth',4,'color',RGB(2,:))
hold all;plot(b,SNR_eff_SE(:,2)*100,'linewidth',4,'color',RGB(3,:))
hold all;plot(b,SNR_eff_SSFP(:,1)*100,'--','linewidth',4,'color',[RGB(1,:),0.3])
hold all;plot(b,SNR_eff_STE(:,1)*100,'--','linewidth',4,'color',[RGB(2,:),0.3])
hold all;plot(b,SNR_eff_SE(:,1)*100,'--','linewidth',4,'color',[RGB(3,:),0.3])
legend('DW-SSFP','DW-STE','DW-SE');
title('SNR Efficiency')
xlabel('b (x10^3 s/mm^2)');
ylabel('SNR Efficiency (% of S_0)');
xlim([1,10]);
set(findall(gcf,'-property','FontSize'),'FontSize',16)
%%
%Save Figure
exportgraphics(gcf,[OutputPath,'Figure10.png'],Resolution=300)
savefig([OutputPath,'Figure10.fig'])