clear all
%%
%Identify optimal SNR Efficiency as function of b-value and resolution for the DW-SSFP sequence
%%
%Define Output Path for Figure
OutputPath='YOUR/OUTPUT/PATH/';
%%
%Define Parameters
[optScanner,~,optSSFP,optSTE] = ParameterOptions();
%%
%Update Sample Properties
[optSample] = ExperimentalSampleParameters();
%%
%Define array of b-values to optimise (ms/um^2 - multiply by 1,000 for s/mm^2)
b=[1:10];
%%
%Define fitting options
options = optimoptions(@lsqnonlin,'Display','off','Algorithm','levenberg-marquardt','FunctionTolerance',1E-10,'OptimalityTolerance',1E-10,'StepTolerance',1E-10);
%%
%SSFP Optimisation
for k=1:length(b)
    %Define fitting function
    f=@(x)DWSSFP_SNREfficiency(x,optSample,optScanner,b(k));
    %Perform fitting
    [fit_out_SSFP(k,:)]=lsqnonlin(f,[optSSFP.G,optSSFP.tau,optSSFP.TR-optSSFP.tau-optScanner.DeadTime,optSSFP.alpha],[0,0,1,1],[optScanner.GMax,40,100,179],options);
    %Reconstruct estimated SNR efficiency & effective b-value
    [~,~,SNR_eff_SSFP_Dw(k)]=DWSSFP_SNREfficiency(fit_out_SSFP(k,:),optSample,optScanner);
    %Update Initial Parameters
    optSSFP.G=fit_out_SSFP(k,1);optSSFP.tau=fit_out_SSFP(k,2);optSSFP.TR=fit_out_SSFP(k,2)+fit_out_SSFP(k,3)+optScanner.DeadTime;optSSFP.alpha=fit_out_SSFP(k,4);
  end
%%
%Perform Comparison of SNR with relative spatial resolution
%Define Resolution Array
ResolutionArr = 0.05:0.05:0.4;
%Peform calculation
for k = 1:length(ResolutionArr)
    SNR_eff_SSFP_Dw_Res(k,:) = SNR_eff_SSFP_Dw * (ResolutionArr(k).^3); 
end
%%
%Convert to an SNR value based on a predicted scaling factor estimated from experimental and simulated data
Scale = 11.12;
SNR_eff_SSFP_Dw_SNR = SNR_eff_SSFP_Dw_Res./SNR_eff_SSFP_Dw_Res(end,6)*Scale;
%%
%Plot
figure;imagesc(SNR_eff_SSFP_Dw_SNR,[0,32]); colormap pink
xlabel('b (x10^3 s/mm^2)');
ylabel('Resolution (mm iso.)');
yticklabels({ResolutionArr})
cb = colorbar(); 
ylabel(cb,'SNR')
set(findall(gcf,'-property','FontSize'),'FontSize',14)
exportgraphics(gcf,[OutputPath,'Figure11.png'],Resolution=300)
savefig([OutputPath,'Figure10.fig'])