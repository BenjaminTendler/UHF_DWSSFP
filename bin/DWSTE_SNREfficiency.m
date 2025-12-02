function [SNReff,bEff,Tmix] = DWSTE_SNREfficiency(x,optSample,optScanner,b,~)
%%
% calculates DW-STE SNR Efficiency
%
% input:
%	x          = Array with diffusion gradient (mT/m), duration of diffusion gradient (ms), echo time (ms) and repetition time (ms)
%	optSample  = Sample Properties
%   optScanner = Scanner Properties
%	b          = Target b-value to Optimise (ms/um2) 
%	~          = If variable passed return optimisation estimates
%
% output:
%	SNReff  = Estimated SNR Efficiency (% of S0, not including diffusion-weighting)
%	bEff    = Estimated b-value
%	Tmix    = Estimated Mixing Time
%%
%Define array parameters & correct scalings- As TE has to be greater than 2*tau, optimise for the difference.
G=x(1)*10;
tau=x(2)*10;
TE=2*tau+x(3)*10;
TR=x(4)*1000;
%%
%STE Signal Estimation
[S,bEff,Tmix]=DWSTE(G,tau,b,TE,TR,optSample.D,optSample.T1,optSample.T2);
%STE Readout Efficiency
Rho=sqrt(max(0,min(TE-2*(tau+optScanner.DeadTime),optScanner.MaxReadout))/TR);
%STE SNR Efficiency   
SNReff=S.*Rho;  
%%
%For optimisation - Note that whilst b-value is defined for DW-STE, the additional optimisation term prevents a negative mixing time. It is important when b-values are low, and has a negligable effect when b-values are high.
if nargin==5
    SNReff=[1-SNReff,abs(bEff-b)./max(b,1)];
end