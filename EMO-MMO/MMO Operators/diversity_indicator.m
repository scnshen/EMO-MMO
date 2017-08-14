function Diver = diversity_indicator(p, theta)
%%%%%%%%%%%%%%%%%%%%%
% Grid Diversity %
%%%%%%%%%%%%%%%%%%%%%

% Transformation to Grid Coordinates
[N,D] = size(p);
Zmin = min(p, [], 1); Zmax = max(p, [], 1);
T = (N/2) - 1;
d = (Zmax - Zmin)/(T);
G = floor((p - repmat(Zmin, [N 1]))./repmat(d, [N 1]));

% Grid Based Diversity Indicator
GD =  pdist2(G, G, 'minkowski', 1); %'minkowski', 1
GD(logical(eye(N))) = 1e20;
S = theta*max(min(GD, [], 2));
GD(logical(eye(N))) = 0;
mask = GD < S;
R = zeros(N, N);
R = R + mask.*(-(GD./S));
Dx = sum(mask,2) + sum(R, 2);
Diver = -Dx;

%%%%%%%%%%%%%%%%%%%%%%%%
% Euclidean diversity %
%%%%%%%%%%%%%%%%%%%%%%%%
% [N,~] = size(p);
% ED =  pdist2(p, p);
% Dx = sum(ED,2)/N;
% Diver = -Dx;
end
