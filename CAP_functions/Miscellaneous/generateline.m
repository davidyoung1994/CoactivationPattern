function [x1, y1, x2, y2] = generateline(n,m)

x1 = 0.5:1:n+1;
x1 = [ x1; x1; repmat(nan,1,(n+1)) ];
y1 = [ 0.5 m+0.5 nan ].';
y1 = repmat(y1,1,(n+1));

x2 = [ 0.5 n+0.5 nan ].';
x2 = repmat(x2,1,(m+1));
y2 = 0.5:1:m+1;
y2 = [ y2; y2; repmat(nan,1,(m+1)) ];

% x = 1.5:1:n;
% x = [ x; x; repmat(nan,1,(n-1)) ];
% y = [ 0.5 n+0.5 nan ].';
% y = repmat(y,1,(n-1));

% ymaj = [ -5 n+5.5 nan]';
% For short grid (same as the figure boundary)
% ymaj = [ 0.5 n+0.5 nan]';
% ymaj = repmat(ymaj,1,(n-1));