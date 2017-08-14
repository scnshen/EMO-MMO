function [K, peaks, I] = peak_detection(archive_x)
[N, D] = size(archive_x);
peaks = cell(0,0);
I = zeros(N,1);

% normalization of the archived decision vectors
t_archive_x = normc(archive_x);

% distances between normalized decision vectors
Dmat = pdist2(t_archive_x, t_archive_x, 'minkowski', 1);
Dmat(logical(eye(N))) = 1e20;

% locate peaks
K = 0; B = ones(1,N);
while(sum(B) > 1)
    K = K + 1;
    one_peak = [];
    % threshhold calculation
    MinDat = min(Dmat, [], 2);
    sigma = max(MinDat(MinDat ~= 1e20));
    % locate the one to start
    starter = find(MinDat == sigma, 1, 'first');
    neighbors = starter;
    %    neighbors = find(B, 1, 'first');
    while(~isempty(neighbors))
        % add the first element to the curren peak
        one_peak = [one_peak; archive_x(neighbors(1),:)]; I(neighbors(1)) = K;
        % discover new neighbors of the first element
        new_neighbors = find(Dmat(neighbors(1),:) <= max(sigma, 1e-3) & Dmat(neighbors(1),:) > 0);
        % disable connections of solutions in new neighborhood
        Dmat(neighbors,new_neighbors) = 1e20;
        Dmat(new_neighbors, neighbors) = 1e20;
        Dmat(new_neighbors, new_neighbors) = 1e20;
        % add new neighrbors
        neighbors = [neighbors, new_neighbors];
        % remove the first element from the neighbors and B
        B(neighbors(1)) = 0;
        neighbors(1) = [];
    end;
    Dmat(find(I == K), :) = 1e20;
    Dmat(:, find(I == K)) = 1e20;
    peaks(K) = {one_peak};
end

% last peak
if(sum(B) == 1)
    K = K + 1;
    idx = find(B);
    I(idx) = K;
    peaks(K) = {archive_x(idx,:)};
end;

end