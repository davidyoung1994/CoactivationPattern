function CAP_Framework_HC(working_dir,subjfolder,Data_Path,K_Means_Para)

%% Load Subject_List, ROI_Template

if ~exist(working_dir)
    mkdir(working_dir)
end

[ROI, v_ROI] = y_Read(Data_Path.ROI);

sub_num = length(subjfolder);

%% Load fMRI data and Head_Motion
% ... Extract BOLD signal using the ROI_Template and Z-score

roi_signal_all = [];
for subji = 1:sub_num
    data = y_ReadAll([Data_Path.Sub 'HC' filesep subjfolder(subji).name]);
    [~,~,~,TP_num] = size(data);
    roi_signal = extract_roi_signal(data,ROI);
    roi_signal_zscore = zscore(roi_signal);
    roi_signal_all = [roi_signal_all;roi_signal_zscore];
end
save([working_dir 'roi_signal_all.mat'],'roi_signal_all')

TP_sub = repmat(1:sub_num,[TP_num,1]);
TP_sub = TP_sub(:);

%% K-means clustering
k_range = K_Means_Para.Range;
k_num = K_Means_Para.Num;
distance_func = K_Means_Para.DistanceFunc;
replicate_num = K_Means_Para.ReplicateNum;

[clust,C,sumD,D,s,eva] = CAP_Kmeans(roi_signal_all,k_range,distance_func,replicate_num);

save([working_dir 'clust.mat'],'clust','C','sumD','D','s','eva')

%% Construct the individual level clustering results 

for K_idx = 1:k_num
    K = k_range(K_idx);
    clust_i = clust(:,K_idx);
    
    CAP_path.group = [working_dir 'CAP' num2str(K) filesep];
    CAP_path.subjfolder = subjfolder;

    if ~exist(CAP_path.group)
        mkdir(CAP_path.group)
    end

    CAP_Construct(clust_i,K,roi_signal_all,ROI,v_ROI,CAP_path);
end

%% Calculate the CAP matrices
load([working_dir 'clust.mat'])

for k_i = 1:k_num
    K = k_range(k_i);
    clust_i = clust(:,k_i);
    
    CAP_matrices = CAP_CalculateMatrices(clust_i,TP_sub,K,sub_num);    

    save([working_dir 'CAP' num2str(K) filesep 'CAP_matrices.mat'],'CAP_matrices');
end
