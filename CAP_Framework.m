%% Coactivation patterns pipeline
% This script is used to run the CAP analysis pipeline
% Citation: Yang et al., 2021 NeuroImage 
% Reproducible coactivation patterns of functional brain networks reveal the aberrant dynamic state transition in schizophrenia.
% Author: Hang Yang
% 2021/10/11
%% Default settings
clear
clc

Data_Path.Sub =  'E:\Data\CAP_project\'; % set the subject folder
Data_Path.ROI = 'E:\CoactivationPatterns\CAP_functions\Miscellaneous\yeo_400_3mm.nii'; % set the ROI template filepath for BOLD signal extraction

working_dir = 'E:\Project\CAP\'; % set the working directory, all results and figures will be saved in this folder

% set the paremeters for kmeans
K_Means_Para.Range = [2:1:11]; % the range of K, e.g., from 2 to 11 with step length = 1
K_Means_Para.Num = length(K_Means_Para.Range);
K_Means_Para.DistanceFunc = 'correlation'; % distance function, e.g., 'sqeuclidean' | 'cityblock' | 'cosine' | 'correlation' | 'hamming'
K_Means_Para.ReplicateNum = 100; % replicate number

%% CAP - HC, CAP pipeline for the HC group
CAP_HC_path = [working_dir 'Results' filesep 'HC' filesep]; % create the HC folder to save their CAP results
mkdir(CAP_HC_path)

subjfolder_HC = dir([Data_Path.Sub 'HC']); % the data folder of HC
subjfolder_HC(1:2) = [];

% run the CAP pipeline in the HC group
CAP_Framework_HC(CAP_HC_path,subjfolder_HC,Data_Path,K_Means_Para)

%% CAP - PAT, CAP pipeline for the Patient group
CAP_PAT_path = [working_dir 'Results' filesep 'PAT' filesep];% create the PAT folder to save their CAP results
mkdir(CAP_PAT_path)

subjfolder_PAT = dir([Data_Path.Sub 'PAT']); % the data folder of PAT
subjfolder_PAT(1:2) = [];

% run the CAP pipeline in the Patient group
CAP_Framework_PAT(CAP_PAT_path,subjfolder_PAT,Data_Path,CAP_HC_path,K_Means_Para)

%-----------------------------------------------------------------------------------%
%----------------------------        PLOT RESULTS       ----------------------------%
%-----------------------------------------------------------------------------------%
%% Plot K-means curve
plot_path =  [working_dir 'Plots' filesep];
mkdir(plot_path)

outpath = [plot_path 'clust_curve.tif'];

load([CAP_HC_path 'clust.mat'],'eva')
plot(eva)

pathstr = fileparts(outpath);
if ~exist(pathstr)
    mkdir(pathstr)
end    
print(gcf,'-dtiff','-r300',outpath)
close all

%% Plot CAP correlations
% thr = 0.5;
thr = 0;
load('E:\CoactivationPatterns\CAP_functions\Miscellaneous\CAP_colormap.mat','CAP_colormap') % set the colormap

for K_i = 1:K_Means_Para.Num
    K = K_Means_Para.Range(K_i);
    CAP_str = ['CAP' num2str(K)];
    CAP_1 = [CAP_HC_path CAP_str filesep 'Group_CAP.mat'];
    CAP_2 = [CAP_PAT_path CAP_str filesep 'Group_CAP.mat'];

    fig_title = 'Spatial Similarity between States';
    x_title = ['PAT - ' CAP_str];
    y_title = ['HC - ' CAP_str];
    outpath = [plot_path filesep 'Corr_CAP' filesep 'PAT_HC_' CAP_str '.tif'];

    abs_flag = 0;
    corr_CAP(CAP_1,CAP_2,fig_title,x_title,y_title,thr,outpath,abs_flag,CAP_colormap)
    
    outpath = [plot_path filesep 'Corr_CAP' filesep 'HC_HC_' CAP_str '.tif'];
    abs_flag = 1;
    corr_CAP(CAP_1,CAP_1,fig_title,y_title,y_title,thr,outpath,abs_flag,CAP_colormap)
    close all
end

%% Plot CAP spatial patterns
brain_path = 'E:\CoactivationPatterns\CAP_functions\Miscellaneous\BrainNetViewer_20191031\Data\SurfTemplate\BrainMesh_ICBM152_smoothed.nv';
setting_path = 'E:\CoactivationPatterns\CAP_functions\Plots\CAP_BrainNet.mat'; % set the BrainNet Viewer options

for K_i = 1 : K_Means_Para.Num
    K = K_Means_Para.Range(K_i);
    CAP_str = ['CAP' num2str(K)];
    vol_path = [CAP_HC_path CAP_str filesep]; % voloume path for the group averaged CAPs
    outpath = [plot_path CAP_str filesep];
        
    BrainNet_CAP(brain_path,setting_path,vol_path,outpath,K)
end
close all

