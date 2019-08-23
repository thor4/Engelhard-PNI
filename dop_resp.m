%%%% Dopaminergic response profile model
%%%% Type 1 neurons identified by Cohen et al., 2012

% dopaminergic firing rate of a single neuron is surrogate of prediction 
% error (rpe)
% 5 Hz baseline, then order of magnitude increase during reward processing
% you get 5Hz by randomly choosing from normal dist with mean of 5, std 1

trainN = 750; % number of training examples

time_steps=50; % trial length
% assume each time step is 100ms, presample: [0-500ms], sample:
% [501-2500ms], delay: [2501-3500ms], reward: 3501ms, post-reward:
% [3600-5000ms]. pre: [0-4], sample: [5-25], delay: [25-35], reward: 35,
% post-reward: [36-50]

% keep track of whether a spike occurs for each time step
spikes = zeros(1,time_steps); 
% keep record of each value for all trials
spikes_mat = zeros(trainN,time_steps);

for tN = 1:trainN % which trial
    for timeN = 1:time_steps % which time step of current trial
        if (5 <= timeN) && (timeN < 7) % 1st part of sample onset window
            spikes(timeN) = normrnd(5,1)*1.2; % begin to ramp
        elseif (7 <= timeN) && (timeN < 9) % sample onset window
            spikes(timeN) = normrnd(5,1)*1.4; % ramping
        elseif (9 <= timeN) && (timeN < 11) % sample onset window
            spikes(timeN) = normrnd(5,1)*1.6; % ramping
        elseif (11 <= timeN) && (timeN < 13) % sample onset window
            spikes(timeN) = normrnd(5,1)*1.8; % ramping
        elseif (13 <= timeN) && (timeN < 16) % middle of sample onset
            spikes(timeN) = normrnd(5,1)*2; % double firing rate
        elseif (16 <= timeN) && (timeN < 18) % end of sample onset
            spikes(timeN) = normrnd(5,1)*1.8; % ramp down
        elseif (18 <= timeN) && (timeN < 20) % end of sample onset
            spikes(timeN) = normrnd(5,1)*1.6; % ramp down
        elseif (20 <= timeN) && (timeN < 22) % end of sample onset
            spikes(timeN) = normrnd(5,1)*1.4; % ramp down
        elseif (22 <= timeN) && (timeN <= 24) % end of sample onset
            spikes(timeN) = normrnd(5,1)*1.2; % ramp down
        elseif (35 <= timeN) && (timeN < 37)% reward time
            spikes(timeN) = normrnd(5,1)*1.3; % begin to ramp
        elseif (37 <= timeN) && (timeN < 39)% reward time
            spikes(timeN) = normrnd(5,1)*2; % double firing rate
        elseif (39 <= timeN) && (timeN < 41)% reward time
            spikes(timeN) = normrnd(5,1)*1.3; % ramp down
        else % baseline, delay and post-reward
            spikes(timeN) = normrnd(5,1); % tonic firing
        end 
    end
    spikes_mat(tN,:) = spikes; % save trial firing rates
end


% plot 1: avg firing rate across all trials with shaded error bar
figure(1),clf
shadedErrorBar(1:size(spikes_mat,2),mean(spikes_mat),std(spikes_mat),'lineprops',{'r-o','markerfacecolor','r'})
hold on
xline(5,'--','Sample Onset','Color',[0.75 0.75 0.75]);
xline(25,'--','Delay','Color',[0.75 0.75 0.75]);
xline(35,'--','Reward','Color','b');
xticks([0 10 20 30 40 50]); xticklabels({'0','1','2','3','4','5'});
xlabel('Time (s)','FontSize',14), ylabel('Firing rate (spikes/s)','FontSize',14)
title(sprintf('Dopaminergic Response Profile Using %d Trials',trainN),'FontSize',18)
export_fig trial_avg.png -transparent % no background