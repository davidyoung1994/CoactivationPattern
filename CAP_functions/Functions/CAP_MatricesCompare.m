function stats = CAP_MatricesCompare(fraction,persistence,counts,degree_in,degree_out,transitions,transitions_prob,resilience,cov,K,SZ_index,HC_index)

SZ_num = length(SZ_index);
HC_num = length(HC_index); 
%% fraction
fraction_SZ = fraction(:,SZ_index)';
fraction_HC = fraction(:,HC_index)';

for i = 1:K
    [t_fraction(i),p_fraction(i)] = ttestcov(fraction_SZ(:,i),fraction_HC(:,i),cov);
end

%% persistence
persistence_SZ = persistence(:,SZ_index)';
persistence_HC = persistence(:,HC_index)';

for i = 1:K
    [t_persistence(i),p_persistence(i)] = ttestcov(persistence_SZ(:,i),persistence_HC(:,i),cov);
end

%% counts
counts_SZ = counts(:,SZ_index)';
counts_HC = counts(:,HC_index)';

for i = 1:K
    [t_counts(i),p_counts(i)] = ttestcov(counts_SZ(:,i),counts_HC(:,i),cov);
end

%% degree_in
degree_in_SZ = degree_in(:,SZ_index)';
degree_in_HC = degree_in(:,HC_index)';

for i = 1:K
    [t_degree_in(i),p_degree_in(i)] = ttestcov(degree_in_SZ(:,i),degree_in_HC(:,i),cov);
end

%% degree_out
degree_out_SZ = degree_out(:,SZ_index)';
degree_out_HC = degree_out(:,HC_index)';

for i = 1:K
    [t_degree_out(i),p_degree_out(i)] = ttestcov(degree_out_SZ(:,i),degree_out_HC(:,i),cov);
end

%% transitions
transitions_SZ = transitions(:,:,SZ_index);
transitions_HC = transitions(:,:,HC_index);

t_transitions = nan(K,K);
p_transitions = nan(K,K);

for i = 1:K
    for j = 1:K
        SZ_zero = sum(squeeze(transitions_SZ(i,j,:)) == 0);
        HC_zero = sum(squeeze(transitions_HC(i,j,:)) == 0);
        if i == j
            t_transitions(i,j) = nan;
            p_transitions(i,j) = nan;
        elseif (SZ_zero > round(SZ_num * 0.25)) | (HC_zero > round(HC_num * 0.25))
                t_transitions(i,j) = nan;
                p_transitions(i,j) = nan;
            else                
                [t_transitions(i,j),p_transitions(i,j)] = ttestcov(squeeze(transitions_SZ(i,j,:)),squeeze(transitions_HC(i,j,:)),cov);
        end
    end
end

%% transitions_prob
transitions_prob_SZ = transitions_prob(:,:,SZ_index);
transitions_prob_HC = transitions_prob(:,:,HC_index);

t_transitions_prob = nan(K,K);
p_transitions_prob = nan(K,K);

for i = 1:K
    for j = 1:K
        SZ_zero = sum(squeeze(transitions_prob_SZ(i,j,:)) == 0);
        HC_zero = sum(squeeze(transitions_prob_HC(i,j,:)) == 0);
        if (SZ_zero > round(SZ_num * 0.25)) || (HC_zero > round(HC_num * 0.25))
            t_transitions_prob(i,j) = nan;
            p_transitions_prob(i,j) = nan;
        else
            [t_transitions_prob(i,j),p_transitions_prob(i,j)] = ttestcov(squeeze(transitions_prob_SZ(i,j,:)),squeeze(transitions_prob_HC(i,j,:)),cov);
        end
    end
end

%% resilience
resilience_SZ = resilience(:,SZ_index)';
resilience_HC = resilience(:,HC_index)';

for i = 1:K
    [t_resilience(i),p_resilience(i)] = ttestcov(resilience_SZ(:,i),resilience_HC(:,i),cov);
end

%%
stats.p_fraction = p_fraction;
stats.t_fraction = t_fraction;
stats.p_persistence = p_persistence;
stats.t_persistence = t_persistence;
stats.p_counts = p_counts;
stats.t_counts = t_counts;
stats.p_degree_in = p_degree_in;
stats.t_degree_in = t_degree_in;
stats.p_degree_out = p_degree_out;
stats.t_degree_out = t_degree_out;
stats.p_transitions = p_transitions;
stats.t_transitions = t_transitions;
stats.p_transitions_prob = p_transitions_prob;
stats.t_transitions_prob = t_transitions_prob;
stats.p_resilience = p_resilience;
stats.t_resilience = t_resilience;
