function plot_corr_CAP(corr_matrix,fig_title,x_title,y_title,thr,abs_flag,mycolor)

if nargin < 6
    abs_flag = 0;
end

[Y,X] = size(corr_matrix);

figure
AX = axes;

imagesc(corr_matrix);
title(fig_title,'FontSize',13,'FontWeight','bold','LineWidth',1)
xlabel(x_title,'FontSize',13,'FontWeight','bold','LineWidth',1); 
ylabel(y_title,'FontSize',13,'FontWeight','bold','LineWidth',1);
axis equal
xlim([0.5,X+0.5])
ylim([0.5,Y+0.5])
xticks(1:X);
yticks(1:Y);
colorbar; caxis([-1,1]);

if nargin == 7
    colormap(mycolor)
end

% abs_flag = 1; thr = 0;

if abs_flag == 1
    [y_idx,x_idx] = find(abs(corr_matrix) >= thr);
else
    [y_idx,x_idx] = find(corr_matrix >= thr);
end

for i = 1:length(x_idx)
   text(x_idx(i),y_idx(i),num2str(corr_matrix(y_idx(i),x_idx(i)),'%.2f'),'HorizontalAlignment','center','FontSize',13) 
end

AX.Layer = 'Bottom';

[x1, y1, x2, y2] = generateline(X,Y);
patch(x1, y1,'w', 'edgecolor', 'k', 'Linewidth', 1, 'EdgeAlpha', 1)
patch(x2, y2,'w', 'edgecolor', 'k', 'Linewidth', 1, 'EdgeAlpha', 1)

set(gcf,'Position',[100 100 450 450]);
set(gca,'FontSize',13,'LineWidth',1);