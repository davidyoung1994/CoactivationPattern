function [index_choose,index_exclude] = compare_two_groups(A,B)
% A (n*2) B (m*2), n >> m
% row_1: age; row_2: gender
index_A_Man = find(A(:,2)==1);
index_A_Woman = find(A(:,2)==0);
index_B_Man = find(B(:,2)==1);
index_B_Woman = find(B(:,2)==0);

A_Man = A(index_A_Man,1);
A_Woman = A(index_A_Woman,1);
B_Man = B(index_B_Man,1);
B_Woman = B(index_B_Woman,1);

D = pdist2(A_Man,B_Man,'euclidean');
E = -(D - max(D(:)));
[val_Man m1_Man m2_Man] = bipartite_matching(E);
A_Man_choose = A_Man(m1_Man);
index_A_Man_choose = index_A_Man(m1_Man);

D = pdist2(A_Woman,B_Woman,'euclidean');
E = -(D - max(D(:)));
[val_Woman m1_Woman m2_Woman] = bipartite_matching(E);
A_Woman_choose = A_Woman(m1_Woman);
index_A_Woman_choose = index_A_Woman(m1_Woman);

index_choose = sort([index_A_Man_choose;index_A_Woman_choose]);
A_choose = A(index_choose,:);
index_exclude = setdiff(1:length(A),index_choose)';

mean(A_choose(:,1))
std(A_choose(:,1))
mean(B(:,1))
std(B(:,1))
mean(A_choose(find(A_choose(:,2)==0),1))
std(A_choose(find(A_choose(:,2)==0),1))
mean(A_choose(find(A_choose(:,2)==1),1))
std(A_choose(find(A_choose(:,2)==1),1))

% test another method
% [a,b] = sort(abs(A_Man - mean(B_Man)));
% mean(A_Man(b(1:33)))
% std(A_Man(b(1:33)))