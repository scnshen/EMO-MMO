function [MaxValue, MinValue, FEs, N, D] =  SOP_Init(SOP)
global initial_flag
switch SOP
   case {'CEC13MM_f1', 'CEC13MM_f2', 'CEC13MM_f3', 'CEC13MM_f4', 'CEC13MM_f5', 'CEC13MM_f6','CEC13MM_f7', 'CEC13MM_f8', 'CEC13MM_f9', 'CEC13MM_f10', 'CEC13MM_f11', 'CEC13MM_f12',...
           'CEC13MM_f13', 'CEC13MM_f14', 'CEC13MM_f15', 'CEC13MM_f16', 'CEC13MM_f17', 'CEC13MM_f18','CEC13MM_f19', 'CEC13MM_f20'}
       initial_flag = 0;
       func_num = str2num(SOP(10:end));
       D = get_dimension(func_num); 
       MaxValue = get_ub(func_num);
       MinValue = get_lb(func_num);
       if(D ~= length(MaxValue))
           MaxValue = repmat(MaxValue(1), [1 D]);
           MinValue = repmat(MinValue(1), [1 D]);
       end;
       N = 500;
       FEs = get_maxfes(func_num);
end
end