% Created by Eugene M. Izhikevich, February 25, 2003
% Additional notes added by Bryan Conklin, September 6, 2019
% Excitatory neurons    Inhibitory neurons
Ne=800;                 Ni=200; % many more excit than inhib here
re=rand(Ne,1);          ri=rand(Ni,1);
% u decays with rate a, static (0.02) for excitatory, rand for inhib
% (0.02<a<0.1)
a=[0.02*ones(Ne,1);     0.02+0.08*ri]; 
% u's sensitivity controlled by b, static (0.2) for excit, rand for inhib 
% (0.2<b<0.25) 
b=[0.2*ones(Ne,1);      0.25-0.05*ri];
% v's reset is controlled by c, assume resting membrane potential of -65mV
% rand for excit (-50<c<-65), static for inhib (-65)
c=[-65+15*re.^2;        -65*ones(Ni,1)];
% u's reset is controlled by d, rand for excit(2<d<8), static for inhib(2)
d=[8-6*re.^2;           2*ones(Ni,1)];
% S is random seed of firing values, 0<S<0.5 for excit and -1<S<0 for inhib
% looks like neurons x neurons (excit then inhib)
S=[0.5*rand(Ne+Ni,Ne),  -rand(Ne+Ni,Ni)];

v=-65*ones(Ne+Ni,1);    % Initial values of v (voltage) at -65mV resting
u=b.*v;                 % Initial values of u
firings=[];             % spike timings

for t=1:1000            % simulation of 1000 ms
  % normal dist with std of 5 for excit, std of 2 for inhib
  I=[5*randn(Ne,1);2*randn(Ni,1)]; % thalamic input, excit rows then inhib
  fired=find(v>=30);    % indices of spikes
  firings=[firings; t+0*fired,fired];
  v(fired)=c(fired); % reset for v after spike
  u(fired)=u(fired)+d(fired); % reset for u after spike
  I=I+sum(S(:,fired),2);
  v=v+0.5*(0.04*v.^2+5*v+140-u+I); % step 0.5 ms
  v=v+0.5*(0.04*v.^2+5*v+140-u+I); % for numerical
  u=u+a.*(b.*v-u);                 % stability
end;
plot(firings(:,1),firings(:,2),'.');
