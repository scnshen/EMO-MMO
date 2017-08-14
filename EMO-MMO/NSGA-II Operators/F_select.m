function [OffspringX, OffspringF] = F_select(Population, FunctionValue, N)
% the environmental selection in NSGA-II
OffspringX = []; OffspringF = [];

[FrontValue,MaxFront] = P_sort(FunctionValue,'half');
Next = zeros(1,N);
NoN = numel(FrontValue,FrontValue<MaxFront);
Next(1:NoN) = find(FrontValue<MaxFront);

Last = find(FrontValue==MaxFront);

CrowdDistance = F_distance(FunctionValue,FrontValue);
[~,Rank] = sort(CrowdDistance(Last),'descend');

Next(NoN+1:N) = Last(Rank(1:N-NoN));
OffspringX = [OffspringX; Population(Next,:)];
OffspringF = [OffspringF; FunctionValue(Next,:)];
    
end

