function MatingPool = F_mating(Population,FrontValue,CrowdDistance, delta)

    [N,D] = size(Population);
    MatingPool = Population;
    
    % random mating
    MatingPool = Population(randperm(N),:);
    

    if(mod(size(MatingPool,1), 2) == 1)
        MatingPool = [MatingPool; MatingPool(1,:)];
    end;
    
end

