function Offspring = P_generator(MatingPool,Boundary,Coding,MaxOffspring)
%  SBX and Polynomial Mutation

    [NN,D] = size(MatingPool);
    if nargin < 4 || MaxOffspring < 1 || MaxOffspring > NN
        MaxOffspring = NN;
    end
    
    switch Coding
        case 'Real'
            ProC = 0.9;       %Crossover probability
            ProM = 0.01;     %Mutation probability
            DisC = 50;   	%Crossover index
            DisM = 20;   	%Mutation index

            %SBX
            Offspring = zeros(NN,D);
            for i = 1 : 2 : NN
                beta = zeros(1,D);
                miu  = rand(1,D);
                beta(miu<=0.5) = (2*miu(miu<=0.5)).^(1/(DisC+1));
                beta(miu>0.5)  = (2-2*miu(miu>0.5)).^(-1/(DisC+1));
                beta = beta.*(-1).^randi([0,1],1,D);
                beta(rand(1,D)>ProC) = 1;
                Offspring(i,:)   = (MatingPool(i,:)+MatingPool(i+1,:))/2+beta.*(MatingPool(i,:)-MatingPool(i+1,:))/2;
                Offspring(i+1,:) = (MatingPool(i,:)+MatingPool(i+1,:))/2-beta.*(MatingPool(i,:)-MatingPool(i+1,:))/2;
            end
            Offspring = Offspring(1:MaxOffspring,:);

            %Polynomial Mutation
            if MaxOffspring == 1
                MaxValue = Boundary(1,:);
                MinValue = Boundary(2,:);
            else
                MaxValue = repmat(Boundary(1,:),MaxOffspring,1);
                MinValue = repmat(Boundary(2,:),MaxOffspring,1);
            end
            k    = rand(MaxOffspring,D);
            miu  = rand(MaxOffspring,D);
            Temp = k<=ProM & miu<0.5;
            Offspring(Temp) = Offspring(Temp)+(MaxValue(Temp)-MinValue(Temp)).*((2.*miu(Temp)+(1-2.*miu(Temp)).*(1-(Offspring(Temp)-MinValue(Temp))./(MaxValue(Temp)-MinValue(Temp))).^(DisM+1)).^(1/(DisM+1))-1);
            Temp = k<=ProM & miu>=0.5; 
            Offspring(Temp) = Offspring(Temp)+(MaxValue(Temp)-MinValue(Temp)).*(1-(2.*(1-miu(Temp))+2.*(miu(Temp)-0.5).*(1-(MaxValue(Temp)-Offspring(Temp))./(MaxValue(Temp)-MinValue(Temp))).^(DisM+1)).^(1/(DisM+1)));

            
            %Boundary control
            Offspring(Offspring>MaxValue) = MaxValue(Offspring>MaxValue);
            Offspring(Offspring<MinValue) = MinValue(Offspring<MinValue);

    end
end