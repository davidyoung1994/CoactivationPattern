function clust = CAP_Kmeans_corr(data,k_range,distance_func,CAP_HC_path)
%% 

TP_sub_num = length(data);
k_num = length(k_range);

clust = zeros(TP_sub_num,k_num); 

for K_idx = 1:k_num
    K = k_range(K_idx);
    CAP_mat_path = [CAP_HC_path 'CAP' num2str(K) filesep 'Group_CAP.mat'];
    load(CAP_mat_path,'group_nii_clust_i_mean')
%     CAP_corr = corr(data',group_nii_clust_i_mean);
    CAP_corr = 1 - pdist2(data,group_nii_clust_i_mean',distance_func);
    [~,sort_index] = sort(CAP_corr,2,'descend');
    clust(:,K_idx) = sort_index(:,1);
end