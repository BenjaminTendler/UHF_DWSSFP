function [S] = DWSSFP(G,tau,TR,alpha,D,T1,T2)
%%
% Calculates DW-SSFP signal based on the model by Freed et al. Steady-state free precession experiments and exact treatment of diffusion in a uniform gradient, J. Chem. Phys. 115, 4249 (2001); https://doi.org/10.1063/1.1389859
%
% Input:
%	G   = strength of diffusion gradient (mT/m)
%	tau = duration of diffusion gradient (ms)
%	TR  = repetition time (ms)
%	alpha = flip angle (degrees)
%	D   = diffusion coefficient (um2/ms)
%	T1  = longitudinal relaxation time (ms)
%	T2  = transverse relaxation time (ms)
%
% Output:
%	S = Measured signal
%%
%Define Parameters
gamma = 4258*2*pi;      % Hz/G
TR = TR*10^-3;          % convert to s
tau = tau*10^-3;        % convert to s
T1 = T1*10^-3;          % convert to s
T2 = T2*10^-3;          % convert to s
G = G*10^-2;            % convert to G/mm
alpha = alpha*pi/180;   % convert to radians
D=D*10^-3;              % convert to mm2/s
%%
%Implement Signal Model
cosa = cos(alpha);
sina = sin(alpha);
E1p = @(p)(exp(-TR/T1-D*gamma^2*G^2*tau^2*TR.*p.^2));
E2p = @(p)(exp(-TR/T2-D*gamma^2*G^2*tau^2.*((p^2+p+1/3)*(tau)+(p+1)^2*(TR-tau))));
Ap=@(p)(1/2.*(E1p(p)-1).*(1+cosa));
Bp=@(p)(1/2.*(E1p(p)+1).*(1-cosa));
Cp=@(p)(E1p(p)-cosa);
np=@(p)(-E2p(-p).*E2p(p-1).*(Ap(p).^2).*Bp(p-1)./Bp(p));
dp=@(p)((Ap(p)-Bp(p))+E2p(-p-1).*E2p(p).*Bp(p).*Cp(p+1)./Bp(p+1));
ep=@(p)(-E2p(p).*E2p(-p-1).*Bp(p).*Cp(p+1)./Bp(p+1));
%%
%Perform Recursive Operation
x1=0;
for k=10000:-1:1
    if k==10000
        x1=np(k)./(dp(k)+ep(k));
    else
        x1=np(k)./(dp(k)+x1);
    end
end
%%
%Estimate r1
r1=x1./(E2p(-1).*Bp(0))+(E2p(0).*Cp(1))./Bp(1);
%%
%Calculate Signal
S=abs(r1.*sina.*(1-E1p(0)).*E2p(-1)./(Ap(0)-Bp(0)+E2p(-1).*Cp(0).*r1));