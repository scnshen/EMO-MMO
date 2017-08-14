%NSGA-II
function MAIN(Problem,Run)
close all;
clc;format compact;tic;
%-----------------------------------------------------------------------------------------
 
%参数设定
SOP = Problem(6:end);
[~, ~, FEs, N, D] =  SOP_Init(SOP);
funcnum = str2num(Problem(15:end));
%-----------------------------------------------------------------------------------------
%算法开始
%初始化
[Population,Boundary] = P_objective('init',SOP,N, 1);
FunctionValue = P_objective('value',SOP,Population, 1);
FrontValue = P_sort(FunctionValue);
CrowdDistance = F_distance(FunctionValue,FrontValue);
all_x = [];
all_f = [];

% Parameters
G_Div = 0.5; % percentage of FEs allocated to fitness landscape approximation
eta = 0.1; % initial cutting ratio
Generations = G_Div*ceil(FEs/N);


%%%%%%%%%%%%%%%%%%%%%%%%% NSGA-II Based MOFLA %%%%%%%%%%%%%%%%%%%%%
for Gene = 1 : Generations
   
    % reproduction
    % SBX + polynomial mutation
    MatingPool = F_mating(Population,FrontValue,CrowdDistance, Gene/Generations);
    Offspring = P_generator(MatingPool,Boundary,'Real',N);
    
    % Localized DE 
%     F  = .5;
%     CR = .7;
%     Offspring = myDE(Population, N, D, [Boundary(2,:); Boundary(1,:)], F, CR, funcnum);

    Population = [Population;Offspring];
    
    % fitness evaluation
    theta = (1 - ((Gene - 1)/Generations))^1;
    FunctionValue = P_objective('value',SOP,Population, theta);
    
    % selection
    [Population, FunctionValue] = F_select(Population, FunctionValue, N);
    
    % archiving
    all_x = [all_x; Population];
    all_f = [all_f; FunctionValue(:,1)];
    
    clc; 
    fprintf('Problem: %s, Run: %s \n',Problem(6:end),num2str(Run));
    fprintf('Fitness Landscape Approximation %4s%% \n',num2str(roundn(Gene/Generations*100,-1)));
end

%%%%%%%%%%%%%%%%%%%%%%%%% Binary cutting based peak detection %%%%%%%%%%%%%%%%%%%%%
fprintf('Peak Detection... \n');
peaks = [];
[slice_x, slice_f] = landscape_cutting(all_x, all_f, eta); %initial_cutting

% peak detection
while(~isempty(slice_f))
    [~, temp_peaks, ~] = peak_detection(slice_x);
    peaks = [peaks, temp_peaks];
    [slice_x, slice_f] = landscape_cutting(slice_x, slice_f, 0.5);
end;
KK = length(peaks);
centers_x = zeros(KK,D); centers_f = zeros(KK,1);
for k = 1:KK
    peak_x = peaks{k};
    temp = P_objective('value',SOP,peak_x, 1);
    peak_f = temp(:,1);
    [~, I] = min(peak_f);
    centers_x(k,:) = peak_x(I,:);
    centers_f(k,:) = peak_f(I);
end;

% remove redundant solutions
[centers_x, ia, ~] = unique(centers_x,'rows');
centers_f = centers_f(ia,:);
peaks = peaks(ia);

%%%%%%%%%%%%%%%%%%%%%%%%% local search %%%%%%%%%%%%%%%%%%%%%
K = length(centers_f); 
fes = floor((1 - G_Div)*FEs/K);
minf = min(centers_x, [], 1);
maxf = max(centers_x, [], 1);
for k = 1:K
    offset =  0.025*(Boundary(1,:) - Boundary(2,:))';
    lbounds = max(Boundary(2,:)', centers_x(k,:)' - offset);
    ubounds = min(Boundary(1,:)', centers_x(k,:)' + offset);
    
    % local optimization using CSO
    seedx = centers_x(k,:)';
    [bestx, bestf] = CSO(seedx, funcnum, fes, lbounds, ubounds);
    
    Population = [Population; bestx];
    FunctionValue = [FunctionValue; [bestf, 0]];
    clc; 
    fprintf('Problem: %s, Run: %s \n',Problem(6:end),num2str(Run));
    fprintf('Fitness Landscape Approximation 100%%\n');
    fprintf('Peak Detection 100%%\n');
    fprintf('Local Search %4s%%\n',num2str(roundn(k/K*100,-1)));
end;


%%%%%%%%%%%%%%%%%%%%%%%%% Output %%%%%%%%%%%%%%%%%%%%%

%%%%%% visualization %%%%%% 
% Parallel Peaks: A Visualization Method for Benchmark Studies of Multimodal Optimization, CEC2017
if(funcnum ~= 3)
    para_visualization(funcnum, Population, -FunctionValue(:,1)); 
end;
%%%%%% visualization %%%%%%

full_count = [2 5 1 4 2 18 36 81 216 12 6 8 6 6 8 6 8 6 6 8];
epsilon = [1e-1 1e-3 1e-5];
func_num = str2num(Problem(15:end));
for i = 1:length(epsilon)
    [count, ~] = count_goptima(Population, func_num, epsilon(i));
    fprintf('Peak Ratio (epsilon = %1.0e): %s\n', epsilon(i), num2str(count/full_count(func_num)));
end;

end