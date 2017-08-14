
function [Output,Boundary] = P_objective(Operation,SOP,Input, theta)
     [Output,Boundary] = P_MNCS(Operation,SOP,Input, theta);
end

% Transformation from a SOP to an MOP
function [Output,Boundary] = P_MNCS(Operation,SOP,Input, theta)
    Boundary = NaN; 
    switch Operation
        case 'init'
            N = Input;
            [MaxValue, MinValue, ~, ~, D] = SOP_Init(SOP);

            % Latin hypercube
            Population = lhsdesign(N,D);
            Population = Population.*repmat(MaxValue,N,1)+(1-Population).*repmat(MinValue,N,1);
            

            Output   = Population;
            Boundary = [MaxValue;MinValue];
        case 'value'
            Population    = Input;
            [N,~] = size(Population);
            FunctionValue = zeros(N,2);
            switch SOP
                case {'CEC13MM_f1', 'CEC13MM_f2', 'CEC13MM_f3', 'CEC13MM_f4', 'CEC13MM_f5', 'CEC13MM_f6','CEC13MM_f7', 'CEC13MM_f8', 'CEC13MM_f9', 'CEC13MM_f10', 'CEC13MM_f11', 'CEC13MM_f12',...
                        'CEC13MM_f13', 'CEC13MM_f14', 'CEC13MM_f15', 'CEC13MM_f16', 'CEC13MM_f17', 'CEC13MM_f18','CEC13MM_f19', 'CEC13MM_f20'}
                    func_num = str2num(SOP(10:end));
                    Conv = -niching_func(Population, func_num);
            end

            FunctionValue(:,1) = Conv; % the first objective
            FunctionValue(:,2) =  -diversity_indicator(Population, theta); % the second objective
            Output = FunctionValue;
    end
end
