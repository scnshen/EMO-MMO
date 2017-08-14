function [slice_x, slice_f] = landscape_cutting(all_x, all_f, cutting_ratio)     
    % remove duplicate solutions
    [all_x, ia, ~] = unique(all_x,'rows');
    all_f = all_f(ia,:);
    
    % generate cutting slice
    minf = min(all_f);
    maxf = max(all_f);
    [valid_idx] = find(all_f < (minf + cutting_ratio*(maxf - minf)));
    slice_f = all_f(valid_idx);
    slice_x = all_x(valid_idx,:);
    
    % to void memeory overflow, the cutting slice can not be too large
    N = size(slice_x, 1); 
    if(N > 5000)
        % warning('initial cutting too large, please use smaller \eta');
        sel_idx = randperm(N);
        sel_idx = sel_idx(1:min(5000, length(sel_idx)));
        slice_f = slice_f(sel_idx);
        slice_x = slice_x(sel_idx,:);
    end;
end