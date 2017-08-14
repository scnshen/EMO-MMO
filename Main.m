
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Implementation of the Evolutionary Multiobjective Optimization Based Multimodal Optimization (EMO-MMO)
%%
%%  See the details of EMO-MMO in the following paper:
%%
%%  R. Cheng, M. Li, K. Li, X. Yao, Evolutionary Multiobjective Optimization Based Multimodal Optimization:
%%  Fitness Landscape Approximation and Peak Detection, Under Review, 2017
%%
%%  The test instances are the CEC'2013 benchmark functions for multimodal optimization
%%
%%  The srouce code is implemented by Ran Cheng
%%
%%  If you have any questions about the code, please contact:
%%  Ran Cheng at ranchengcn@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Main()
clc;format short;
currentFolder = pwd;
addpath(genpath(currentFolder));
    
Problems = {'MNCS_CEC13MM_f1','MNCS_CEC13MM_f2','MNCS_CEC13MM_f3','MNCS_CEC13MM_f4','MNCS_CEC13MM_f5','MNCS_CEC13MM_f6',...
    'MNCS_CEC13MM_f7','MNCS_CEC13MM_f8','MNCS_CEC13MM_f9','MNCS_CEC13MM_f10','MNCS_CEC13MM_f11','MNCS_CEC13MM_f12',...
    'MNCS_CEC13MM_f13','MNCS_CEC13MM_f14','MNCS_CEC13MM_f15','MNCS_CEC13MM_f16','MNCS_CEC13MM_f17','MNCS_CEC13MM_f18',...
    'MNCS_CEC13MM_f19','MNCS_CEC13MM_f20'};

RunNum = 1;

global initial_flag

rng(0,'twister');
for Prob = 9 % problem
    initial_flag = 0;
    for Run = 1:RunNum % Run number
        rng('default'); rng(Run);
        Problem = Problems{Prob};
        MAIN(Problem,Run)
    end;
end;

end