function offsX = myDE(x, popsize, D, lu, F, CR, funcnum)

offsX = x;

%.... "rand/1" strategy ....%
for i = 1 : popsize
    
    % Choose the indices for mutation
    nouse_ = 1 : popsize;
    nouse_(i) = [];
    
    % Choose the first index
    temp = floor(rand * (popsize - 1)) + 1;
    nouse(1) = nouse_(temp);
    nouse_(temp) = [];
    
    % Choose the second index
    temp = floor( rand * (popsize - 2))+1;
    nouse(2) = nouse_(temp );
    nouse_(temp) = [];
    
    % Choose the third index
    temp = floor(rand * (popsize - 3)) + 1;
    nouse(3) = nouse_(temp);
    
    v = x(nouse(1), : )+ F .* (x(nouse(2), :) - x(nouse(3), :));
    
    
%     %多项式变异
%     ProM = 0.01;
%     DisM = 20;
%     MaxValue = lu(2,:);
%     MinValue = lu(1,:);
%     k = rand(1,D);
%     miu = rand(1,D);
%     Temp = (k<=ProM & miu<0.5);
%     v(Temp) = v(Temp)+(MaxValue(Temp)-MinValue(Temp)).*((2.*miu(Temp)+(1-2.*miu(Temp)).*(1-(v(Temp)-MinValue(Temp))./(MaxValue(Temp)-MinValue(Temp))).^(DisM+1)).^(1/(DisM+1))-1);
%     Temp = (k<=ProM & miu>=0.5);
%     v(Temp) = v(Temp)+(MaxValue(Temp)-MinValue(Temp)).*(1-(2.*(1-miu(Temp))+2.*(miu(Temp)-0.5).*(1-(MaxValue(Temp)-v(Temp))./(MaxValue(Temp)-MinValue(Temp))).^(DisM+1)).^(1/(DisM+1)));  
    
    % Handle the elements of the mutant vector which violate the boundary
    w = find(v < lu(1, :));
    if ~isempty(w)
        if rand < 0.5
            v(1, w) = 2 * lu(1, w) -  v(1, w);
            w1 = find( v(1, w) > lu(2, w));
            if ~isempty(w1)
                v(1, w(w1)) = lu(2, w(w1));
            end
        else
            %                         v(1, w) = (lu(1, w) + x(i, w)) / 2;
            v(1, w) = lu(1, w);
        end
    end
    
    y = find(v > lu(2, :));
    if ~isempty(y)
        if rand < 0.5
            v(1, y) =  2 * lu(2, y) - v(1, y);
            y1 = find(v(1, y) < lu(1, y));
            if ~isempty(y1)
                v(1, y(y1)) = lu(1, y(y1));
            end
        else
            %                         v(1, y) = (lu(2, y) + x(i, y)) / 2;
            v(1, y) = lu(2, y);
        end
    end
    
    % Binomial crossover
    t = rand(1, D) < CR;
    j_rand = floor(rand * D) + 1;
    t(1, j_rand) = 1;
    t_ = 1 - t;
    
   offsX(i, :) = t .* v + t_ .* x(i, :);

%     if(niching_func(offsX(i, :), funcnum) < niching_func(v, funcnum))
%         offsX(i, :) = v;
%     end;
    
end
