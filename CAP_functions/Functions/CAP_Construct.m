function group_nii_clust_i_z = CAP_Construct(clust,K,roi_signal_all,roi,roi_header,CAP_path)
% roi = aal; roi_header = v_aal;

%% Construct the group average CAP
group_CAP_path = CAP_path.group;
for clust_i = 1:K        
    clust_i_idx = find(clust == clust_i);
    group_nii_clust_i{clust_i} = roi_signal_all(clust_i_idx,:);
    group_nii_clust_i_mean(:,clust_i) = mean(group_nii_clust_i{clust_i});
    group_nii_clust_i_std(:,clust_i) = std(group_nii_clust_i{clust_i});
    group_nii_clust_i_z(:,clust_i) = group_nii_clust_i_mean(:,clust_i)./group_nii_clust_i_std(:,clust_i);
    
    mean_fname = [group_CAP_path 'Group_CAP_' num2str(clust_i) '_mean.nii'];
    mat2roi(group_nii_clust_i_mean(:,clust_i),roi,roi_header,mean_fname);    

    std_fname = [group_CAP_path 'Group_CAP_' num2str(clust_i) '_std.nii'];
    mat2roi(group_nii_clust_i_std(:,clust_i),roi,roi_header,std_fname);    
    
    z_fname = [group_CAP_path 'Group_CAP_' num2str(clust_i) '_z.nii'];
    mat2roi(group_nii_clust_i_z(:,clust_i),roi,roi_header,z_fname);
end

group_nii_clust_path = [group_CAP_path 'Group_CAP.mat'];
save(group_nii_clust_path,'group_nii_clust_i','group_nii_clust_i_mean','group_nii_clust_i_std','group_nii_clust_i_z')
