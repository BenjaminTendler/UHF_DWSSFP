function [SNReff,bEff,SNReff_Dw] = DWSSFP_SNREfficiency(x,optSample,optScanner,b)
%%
% Calculates DW-SSFP SNR Efficiency
%
% input:
%	x          = array with diffusion gradient (mT/m), duration of diffusion gradient (ms), repetition time (ms) and flip angle (degrees)
%	optSample  = Sample Properties
%   optScanner = Scanner Properties
%	b          = Target effective b-value to Optimise (ms/um2) 
%
% output:
%	SNReff  = Estimated SNR Efficiency  (% of S0, not including diffusion-weighting)
%	bEff    = Estimated b-value
%   SNReff_Dw  = Estimated SNR Efficiency  (% of S0 incorporating diffusion-Weighting)
%%
%Define array parameters - As TR has to be greater than tau, optimise for the difference
G=x(1);
tau=x(2);
TR=tau+x(3)+optScanner.DeadTime;
alpha=x(4);
%%
%SSFP Signal Estimation
S=DWSSFP(G,tau,TR,alpha,optSample.D,optSample.T1,optSample.T2); 
S0=DWSSFP(G,tau,TR,alpha,0,optSample.T1,optSample.T2); 
%SSFP Readout Efficiency
Rho=sqrt(min(optScanner.MaxReadout,TR-tau-optScanner.DeadTime)/TR);
%%
%Define Echo Time
TE = (TR-tau-optScanner.DeadTime)/2+tau+optScanner.DeadTime; 
%%
%Estimate T2' decay
T2p=1./((1/optSample.T2s)-(1/optSample.T2));
ET2p=exp(-(TR-TE)./(T2p));
%%
%SSFP SNR Efficiency   
SNReff=S0.*ET2p.*Rho;      
%SSFP SNR Efficiency - Incorporating diffusion-weighting
SNReff_Dw=S.*ET2p.*Rho;      
%%
%Estimate effective b-value
bEff=-1./optSample.D.*log(S./S0);
%%
%For optimisation
if nargin==4
    SNReff=[1-SNReff,abs(bEff-b)./max(b,1)];
end