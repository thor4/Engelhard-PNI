% Created by Eugene M. Izhikevich, February 25, 2003
% Modified for VTA DA profile added by Bryan Conklin, September 6, 2019
% Excitatory neurons    Inhibitory neurons
Ne=800;                 Ni=200; % 4:1 ratio of excit:inhib
re=rand(Ne,1);          ri=rand(Ni,1);
% fast spiking (FS) (stimulus firing) a=0.1 (fast recovery) for inhib
% u decays with rate a, smaller values result in slower recovery
aFS=[0.02*ones(Ne,1);     0.1*ones(Ni,1)]; 
a=[0.02*ones(Ne,1);     0.02+0.08*ri]; 
% b describes sensitivity of u to subtreshold fluctuations of v. static 
% (0.2) for excit, rand for inhib (0.2<b<0.25). controls resting potential 
% of neuron to be bet -70 & -60mV. Greater values couple v and u more
% strongly resulting in possible subthres oscillations and low-thres
% spiking dynamics
b=[0.2*ones(Ne,1);      0.25-0.05*ri];
% regular spiking (RS) (background/tonic firing) c=-65mV, d=8 for excit
% c describes after-spike reset value of v caused by fast high-thres K+ 
% conductances
cRS=[-65*ones(Ne,1);        -65*ones(Ni,1)];
c=[-65+15*re.^2;        -65*ones(Ni,1)];
% d describes after-spike reset of u caused by slow high-thres Na+ & K+ 
% conductances
dRS=[8*ones(Ne,1);           2*ones(Ni,1)];
d=[8-6*re.^2;           2*ones(Ni,1)];
% S is random seed of synaptic weights bet neurons, 0<S<0.5 for excit and 
% -1<S<0 for inhib. firing of the jth neuron instantaneously changes var
% vi by sij
S=[0.5*rand(Ne+Ni,Ne),  -rand(Ne+Ni,Ni)];

% v is the membrane potential of the neuron (voltage)
v=-65*ones(Ne+Ni,1);    % Initial values of v at -65mV resting
% u is the membrane recovery variable, accounts for K+ activation & Na+
% inactivation. provides negative feedback to v
u=b.*v;                 % Initial values of u
firings=[];             % spike timings

for t=1:1000            % simulation of 1000 ms
  % normal dist with std of 5 for excit, std of 2 for inhib, much stronger
  % modulation for excitatory cells than inhibitory
  stimulus = 100:400; %time-step when stimulus occurs
  I=[5*randn(Ne,1);2*randn(Ni,1)]; % thalamic input, excit rows then inhib
  fired=find(v>=30);    % indices of spikes
  %for firings, 1st col is time step, 2nd col is neuron that spiked
  firings=[firings; t+0*fired,fired]; 
  %sum all the incoming cortical weights for the fired neurons and add to 
  %all the incoming thalamic input current (I)
  I=I+sum(S(:,fired),2); 
  if ismember(t,stimulus) % for FS neuron
      v(fired)=c(fired); % reset for v after spike 
      u(fired)=u(fired)+d(fired); % reset for u after spike 
      v=v+0.5*(0.04*v.^2+5*v+140-u+I); % step 0.5 ms 
      v=v+0.5*(0.04*v.^2+5*v+140-u+I); % for numerical stability
      u=u+aFS.*(b.*v-u);                 
  else % for RS neuron
      v(fired)=cRS(fired); % reset for v after spike 
      u(fired)=u(fired)+dRS(fired); % reset for u after spike 
      v=v+0.5*(0.04*v.^2+5*v+140-u+I); % step 0.5 ms 
      v=v+0.5*(0.04*v.^2+5*v+140-u+I); % for numerical stability
      u=u+a.*(b.*v-u);                 
  end
end
plot(firings(:,1),firings(:,2),'.');

%need to figure out how to do PSTH and get firing rate from it
