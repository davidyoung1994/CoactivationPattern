function BrainNet_CAP(brain_path,setting_path,vol_path,outpath,K)

for K_i = 1:K

    vol_path_K = [vol_path 'Group_CAP_' num2str(K_i)  '_z.nii'];
    outpath_K = [outpath 'Group_CAP_' num2str(K_i) '_z.tif'];

    pathstr = fileparts(outpath_K);
    if ~exist(pathstr)
        mkdir(pathstr)
    end     
    
    BrainNet_MapCfg(brain_path,vol_path_K,setting_path,outpath_K);
end
