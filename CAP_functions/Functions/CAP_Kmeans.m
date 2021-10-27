function [clust,C,sumD,D,s,eva] = CAP_Kmeans(data,k_range,distance_func,replicate_num)

num_k = length(k_range);
clust = zeros(size(data,1),num_k);
s = zeros(size(data,1),num_k);

for i = 1:num_k
    fprintf('Kmeans: %d clusters... \n',k_range(i));
    [clust(:,i), C{i}, sumD{i}, D{i}] = kmeans(data,k_range(i),'Distance',distance_func,'replicate',replicate_num);
%     clust(:,i) = kmeans(data,k_range(i),'Distance',distance_func,'replicate',replicate_num);
    s(:,i) = silhouette(data,clust(:,i),distance_func);
end

eva = evalclusters(data,clust,'silhouette','Distance',distance_func);

