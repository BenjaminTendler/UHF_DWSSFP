function [GArr,qArr,tauArr] = qValue(Dimension,tau,GMax,gamma)
%Dimension - mm
%%
%Define Maximum q-value (radians / mm)
qMax=(gamma*tau*GMax)/10^9;
%%
%Define fraction of q-max that gives rise to dephasing of 2 pi / mm
qFrac_2pi=2*pi/qMax;
%%
%Scale by qMax & target dimension
qMin=qFrac_2pi.*qMax./Dimension;
%%
%Define q-value array. Scale by 2*pi to get units of mm^-1
qArr=(qMin:qMin:qMax)./(2*pi);
%corresponding gradient amplitudes
GArr=GMax*(qMin./qMax):GMax*(qMin./qMax):GMax;
%corresponding Diffusion Time amplitudes
tauArr=tau*(qMin./qMax):tau*(qMin./qMax):tau;
