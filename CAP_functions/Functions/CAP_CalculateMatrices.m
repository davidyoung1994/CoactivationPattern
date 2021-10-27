function [CAP_matrices] = CAP_CalculateMatrices(clust,TP_sub,K,sub_num)
% -------------------------------------------------------------------------------------------
% Input:
% clust: cluster index
% TP_sub: time point information for all subjects
% K: cluster number
% sub_num: subject number
% -------------------------------------------------------------------------------------------
% Output:
% fraction of time: the proportion of scan spent in that network state
% persistence: volume-to-volume maintenance of a network state
% counts: volume-to-volume maintenance of a network state
% transitions: frequency of moving from state A to state B (state to state)
% transitions_prob: probability of moving from state A to state B (volume to volume)
% resilience: the likelihood that remain in the same state from time t to t+1
% in_degree: frequency of moving into state A
% out_degree: frequency of leveing from state A
% -------------------------------------------------------------------------------------------
% Author: David Young
% 2020/09/09
% -------------------------------------------------------------------------------------------

fraction = zeros(K,sub_num);
persistence = zeros(K,sub_num);
counts = zeros(K,sub_num);
transitions = zeros(K,K,sub_num);
transitions_prob = zeros(K,K,sub_num);
resilience = zeros(K,sub_num);
in_degree = zeros(K,sub_num);
out_degree = zeros(K,sub_num);


for sub_i = 1:sub_num
    
    TP_sub_i_idx = find(TP_sub == sub_i); % time point index for subject i
    TP_sub_i_num = length(TP_sub_i_idx); % number of (time point index for subject i)
    clust_sub_i = clust(TP_sub_i_idx); % cluster results for subject i
    
    for clust_i = 1:K
        
        clust_i_idx = find(clust_sub_i == clust_i); % index of i_th cluster for subject i
        clust_i_num = length(clust_i_idx); % length of i_th cluster for subject i
        
        clust_i_sequence = double(clust_sub_i == clust_i);
        clust_i_sequence_diff = diff([0; clust_i_sequence; 0]); % get the onset and end of each cluster block
        
        clust_i_sequence_onset{clust_i} = find(clust_i_sequence_diff == 1);
        clust_i_sequence_end{clust_i} = find(clust_i_sequence_diff == -1) - 1;
        
        if length(clust_i_sequence_onset{clust_i}) ~= length(clust_i_sequence_end{clust_i})
            fprintf('Error: The length of onset and end are different !!! \n')
        end
        
        clust_i_sequence_num{clust_i} = length(clust_i_sequence_onset{clust_i});
        clust_i_sequence_duration{clust_i} = clust_i_sequence_end{clust_i} - clust_i_sequence_onset{clust_i} + 1;
               
       %% fraction of time:  proportion of scan spent in that network state; 
        ... persistence: volume-to-volume maintenance of a network state;
        counts(clust_i,sub_i) =  clust_i_sequence_num{clust_i};
        fraction(clust_i,sub_i) = clust_i_num/TP_sub_i_num;
        persistence(clust_i,sub_i) = mean(clust_i_sequence_duration{clust_i});
                
    end
    
    %% Calculate transitions: frequency of moving from state A to state B.
    
    for clust_i = 1:K
        
        seq_num = clust_i_sequence_num{clust_i};
        seq_onset = clust_i_sequence_onset{clust_i};
        seq_end = clust_i_sequence_end{clust_i};
        
        for seq_i = 1:seq_num
            seq_end_i = seq_end(seq_i);
            
            if seq_end_i < TP_sub_i_num
                clust_next = clust_sub_i(seq_end_i + 1);
                transitions(clust_i,clust_next,sub_i) = transitions(clust_i,clust_next,sub_i) + 1;
            end
            
        end       
        
    end
    
    %% Calculate the probility of transitions

    end_clust = clust_sub_i(TP_sub_i_num);
    TP_num_clust = fraction(:,sub_i)*TP_sub_i_num;
    TP_num_clust(end_clust) = TP_num_clust(end_clust)-1;
        
    for clust_i = 1:K
             
        transitions_prob(clust_i,:,sub_i) = transitions(clust_i,:,sub_i) ./ TP_num_clust(clust_i);
        transitions_prob(clust_i,clust_i,sub_i) = 1 - sum(transitions_prob(clust_i,:,sub_i));
    
    end
    
    transitions_prob_sub_i = transitions_prob(:,:,sub_i);
    resilience(:,sub_i) = transitions_prob_sub_i(1:K+1:end);
    
end

in_degree = squeeze(sum(transitions,1));
out_degree = squeeze(sum(transitions,2));

%%
CAP_matrices.fraction = fraction';
CAP_matrices.persistence = persistence';
CAP_matrices.counts = counts';
CAP_matrices.transitions = permute(transitions,[3 1 2]);
CAP_matrices.transitions_prob = permute(transitions_prob,[3 1 2]);
CAP_matrices.resilience = resilience';
CAP_matrices.in_degree = in_degree';
CAP_matrices.out_degree = out_degree';