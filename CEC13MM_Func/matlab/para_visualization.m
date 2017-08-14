
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Implementation of Parallel Peaks Visualization Method for Multimodal Optimization
%%
%%  See the details of EMO-MMO in the following paper:
%%
%%  R. Cheng, M. Li, X. Yao. Parallel Peaks: A Visualization Method for Benchmark Studies of Multimodal Optimization, 
%%  IEEE Congress on Evolutionary Computation (CEC'2017), Spain, 2017.
%%
%%  This function MUST BE put in the folder of the CEC'2013 test suite for multimodal optimization
%%
%%  The srouce code is implemented by Ran Cheng
%%
%%  If you have any questions about the code, please contact:
%%  Ran Cheng at ranchengcn@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = para_visualization(func_num, x, y)
% x: the decision vectors
% y: the function (fitness) values

% get the normalized grayscale values according to y
grayscale = 1 - (y - min(y) + 1e-200)/(max(y) - min(y) + 1e-200);
if(size(unique(grayscale)) == 1)
    grayscale(:) = 0;
end;

% get x positions of true optima
centers = get_xgoptima(func_num); % this function is available in the lastest version of the CEC'2013 test suite

% distance from each data point to true optima
dist = pdist2(x,centers);

% plot the distance with respect to each true optimum
opt_num = size(centers,1);
x_axis = 1:opt_num;

for i = 1:size(dist,1)
    y_axis = dist(i,:);
    color = [0 0 0] + grayscale(i);
    semilogy(x_axis, y_axis, 'Color', color);
    if(i == 1)
        hold on;
    end;
end;
xlim([1 opt_num]);

xlabel('Optimum Index');
ylabel('Distance');
set(gca,'fontsize',16);

hold off;
end