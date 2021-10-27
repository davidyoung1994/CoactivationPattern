function corr_CAP(CAP_1,CAP_2,fig_title,x_title,y_title,thr,outpath,abs_flag,mycolor)

if nargin < 8
    abs_flag = 0;
end

load(CAP_1)
Group_CAP_1 = group_nii_clust_i_mean;

load(CAP_2)
Group_CAP_2 = group_nii_clust_i_mean;

x = corr(Group_CAP_1,Group_CAP_2);

plot_corr_CAP(x,fig_title,x_title,y_title,thr,abs_flag,mycolor)

pathstr = fileparts(outpath);
if ~exist(pathstr)
    mkdir(pathstr)
end

print(gcf,'-dtiff','-r300',outpath)