function [BestNetwork, BestCost, BestChart] = TrainUsingWOA_Fcn(Xtr,Ytr,N,max_it,NumOfInputs,NumOfHiddens ,NumOfOutputs , Vmax, Vmin )

%% Network Structure
pr = [-1 1];
PR = repmat(pr,NumOfInputs,1);
Network = newff(PR,[NumOfHiddens NumOfOutputs],{'tansig' 'tansig'});
Network.trainparam.goal = .0001;

%% Problem Statement
ProblemParams.CostFuncName = 'CostFunction_Fcn';    % You should state the name of your cost function here.
CostFuncExtraParams.Network = Network;
CostFuncExtraParams.Xtr = Xtr;
CostFuncExtraParams.Ytr = Ytr;
ProblemParams.CostFuncExtraParams = CostFuncExtraParams;               % Reserved for the extra parameters in cost function. In normal application do not use it that is use [].

IW = Network.IW{1};
LW = Network.LW{2};
b = Network.b{1};
ProblemParams.NPar =  numel(IW) + numel(LW) + numel(b);                          % Number of optimization variables of your objective function. "NPar" is the dimention of the optimization problem.
ProblemParams.VarMin = Vmin ;                         % Lower limit of the optimization parameters. You can state the limit in two ways. 1)   2)
ProblemParams.VarMax = Vmax;                       % Lower limit of the optimization parameters. You can state the limit in two ways. 1)   2)

% Modifying the size of VarMin and VarMax to have a general form
if numel(ProblemParams.VarMin)==1
    ProblemParams.VarMin=repmat(ProblemParams.VarMin,ProblemParams.NPar,1);
    ProblemParams.VarMax=repmat(ProblemParams.VarMax,ProblemParams.NPar,1);
end

ProblemParams.SearchSpaceSize = ProblemParams.VarMax - ProblemParams.VarMin;


dim=ProblemParams.NPar ;
%% Creation of Initial Particles

ub=Vmax;
lb=Vmin;
BestChart=zeros(1,max_it);
X = GenerateNewPop(N , ProblemParams);




%create chart of best so far and average fitnesses.
% BestChart=[];
% 
% V=zeros(dim,N);
SearchAgents_no=N;
Leader_pos=zeros(1,dim);
Leader_score=inf; %change this to -inf for maximization problems
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
Positions=X';
t=0;% Loop counter
                                       
for iteration=1:max_it
    
   
        for i=1:size(Positions,1)
        
        % Return back the search agents that go beyond the boundaries of the search space
%         Flag4ub=Positions(i,:)>ub;
%         Flag4lb=Positions(i,:)<lb;
%         Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        
        % Calculate objective function for each search agent
            if isempty(ProblemParams.CostFuncExtraParams)
        fitness = feval(ProblemParams.CostFuncName,Positions(i,:)');
            else
        
        fitness = feval(ProblemParams.CostFuncName,Positions(i,:)',ProblemParams.CostFuncExtraParams);
            end
    
        
        % Update the leader
        if fitness<Leader_score % Change this to > for maximization problem
            Leader_score=fitness; % Update alpha
            Leader_pos=Positions(i,:);
        end
        
        end
    
    
    a=2-t*((2)/max_it); % a decreases linearly fron 2 to 0 in Eq. (2.3)
    
    % a2 linearly dicreases from -1 to -2 to calculate t in Eq. (3.12)
    a2=-1+t*((-1)/max_it);
    
    % Update the Position of search agents 
    for i=1:size(Positions,1)
        r1=rand(); % r1 is a random number in [0,1]
        r2=rand(); % r2 is a random number in [0,1]
        
        A=2*a*r1-a;  % Eq. (2.3) in the paper
        C=2*r2;      % Eq. (2.4) in the paper
        
        
        b=1;               %  parameters in Eq. (2.5)
        l=(a2-1)*rand+1;   %  parameters in Eq. (2.5)
        
        p = rand();        % p in Eq. (2.6)
        
        for j=1:size(Positions,2)
            
            if p<0.5   
                if abs(A)>=1
                    rand_leader_index = floor(SearchAgents_no*rand()+1);
                    X_rand = Positions(rand_leader_index, :);
                    D_X_rand=abs(C*X_rand(j)-Positions(i,j)); % Eq. (2.7)
                    Positions(i,j)=X_rand(j)-A*D_X_rand;      % Eq. (2.8)
                    
                elseif abs(A)<1
                    D_Leader=abs(C*Leader_pos(j)-Positions(i,j)); % Eq. (2.1)
                    Positions(i,j)=Leader_pos(j)-A*D_Leader;      % Eq. (2.2)
                end
                
            elseif p>=0.5
              
                distance2Leader=abs(Leader_pos(j)-Positions(i,j));
                % Eq. (2.5)
                Positions(i,j)=distance2Leader*exp(b.*l).*cos(l.*2*pi)+Leader_pos(j);
                
            end
            
        end
    end
    t=t+1;
    BestChart(t)= Leader_score;


end %iteration

 BestCost = Leader_score;

BestNetwork = ConstructNetwork_Fcn(Network,Leader_pos');
end % End of Algorithm