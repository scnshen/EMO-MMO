%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Implementation of a competitive swarm optimizer (CSO) for large scale optimization
%%
%%  See the details of CSO in the following paper
%%  R. Cheng and Y. Jin, A Competitive Swarm Optimizer for Large Scale Optmization,
%%  IEEE Transactions on Cybernetics, 2014
%%
%%  The test instances are the CEC'08 benchmark functions for large scale optimization
%%
%%  The source code CSO is implemented by Ran Cheng
%%
%%  If you have any questions about the code, please contact:
%%  Ran Cheng at r.cheng@surrey.ac.uk
%%  Prof. Yaochu Jin at yaochu.jin@surrey.ac.uk
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [bestx, bestf] = CSO(seedx, funcid, maxfes, lbounds, ubounds)
seedx = seedx';
d = length(seedx);
lu = [lbounds'; ubounds'];
% if(funcid <= 17)
%     m = 20;
% else
%     m = 60; % for high-dimensional problems, you may try larger swarm size
% end;
m = 20;
phi = 0;

% best results
bestx = seedx; 
bestf = -niching_func(seedx,funcid);

% initialization
XRRmin = repmat(lu(1, :), m, 1);
XRRmax = repmat(lu(2, :), m, 1);
%p = XRRmin + (XRRmax - XRRmin) .* rand(m, d);% Random
p = XRRmin + (XRRmax - XRRmin) .* lhsdesign(m,d); % Latin

p(1,:) = seedx;

fitness = -niching_func(p, funcid);
v = zeros(m,d);

FES = m;
gen = 0;

tic;
% main loop
while(FES < maxfes)

    % generate random pairs
    rlist = randperm(m);
    rpairs = [rlist(1:ceil(m/2)); rlist(floor(m/2) + 1:m)]';
    
    % calculate the center position
    center = ones(ceil(m/2),1)*mean(p);
    
    % do pairwise competitions
    mask = (fitness(rpairs(:,1)) > fitness(rpairs(:,2)));
    losers = mask.*rpairs(:,1) + ~mask.*rpairs(:,2);
    winners = ~mask.*rpairs(:,1) + mask.*rpairs(:,2);
    
    %random matrix
    randco1 = rand(ceil(m/2), d);
    randco2 = rand(ceil(m/2), d);
    randco3 = rand(ceil(m/2), d);
    
    % losers learn from winners
    v(losers,:) = randco1.*v(losers,:) ...,
        + randco2.*(p(winners,:) - p(losers,:)) ...,
        + phi*randco3.*(center - p(losers,:));
    p(losers,:) = p(losers,:) + v(losers,:);
    
    % boundary control
    for i = 1:ceil(m/2)
        p(losers(i),:) = max(p(losers(i),:), lu(1,:));
        p(losers(i),:) = min(p(losers(i),:), lu(2,:));
    end
    
    % fitness evaluation
    fitness(losers,:) = -niching_func(p(losers,:), funcid);
    % best solution
    [B,I] = min(fitness);
    if(B < bestf)
        bestf = B;
        bestx = p(I,:);
    end;
    FES = FES + ceil(m/2);
    
    gen = gen + 1;
end;

end

