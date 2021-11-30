clc;
clear;
close all;

w=            [70 30 24 7 28 22;
              12 22 43 49 23 81;
              73 22 12 34 5 12;
               22 9 33 55 77 22;
              22 12 45 65 28 91;
              11 11 11 11 11 11 ];
          
  n=size(w,1);
     
  %m=numel(solution);
 
  nVar=6;       % Number of Decision Variables
  VarSize=[1 nVar];   % Size of Decision Variables Matrix
  VarMin=0;         % Lower Bound of Variables
  VarMax=1;         % Upper Bound of Variables

%% Firefly Algorithm Parameters

MaxIt=1000;         % Maximum Number of Iterations

nPop=20;            % Number of Fireflies (Swarm Size)

gamma=1;            % Light Absorption Coefficient

beta0=2;            % Attraction Coefficient Base Value

alpha=0.2;          % Mutation Coefficient

alpha_damp=0.98;    % Mutation Coefficient Damping Ratio

delta=0.05*(VarMax-VarMin);     % Uniform Mutation Range

m=2;

if isscalar(VarMin) && isscalar(VarMax)
    dmax = (VarMax-VarMin)*sqrt(nVar);
else
    dmax = norm(VarMax-VarMin);
end

nMutation = 2;      % Number of Additional Mutation Operations


%% Initialization

% Empty Firefly Structure
firefly.Position=[];
firefly.Cost=[];
firefly.Sol=[];

% Initialize Population Array
pop=repmat(firefly,nPop,1);

% Initialize Best Solution Ever Found
BestSol.Cost=inf;

% Create Initial Fireflies
for i=1:nPop
   pop(i).Position=unifrnd(VarMin,VarMax,VarSize);
   
    solution= randperm(6,6);
    z=0;
    x=rand;
    for i=1:n
        for j=i+1:n
            z=z+w(i,j)-x*30;
        end
    end
    pop(i).Cost =z;
    pop(i).Sol = solution;
   
   if pop(i).Cost<=BestSol.Cost
       BestSol=pop(i);
   end
end

% Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);








%% Firefly Algorithm Main Loop

for it=1:MaxIt
    
    newpop=repmat(firefly,nPop,1);
    for i=1:nPop
        newpop(i).Cost = inf;
        for j=1:nPop
            if pop(j).Cost < pop(i).Cost
                rij=norm(pop(i).Position-pop(j).Position)/dmax;
                beta=beta0*exp(-gamma*rij^m);
                e=delta*unifrnd(-1,+1,VarSize);
                %e=delta*randn(VarSize);
                
                newsol.Position = pop(i).Position ...
                                + beta*rand(VarSize).*(pop(j).Position-pop(i).Position) ...
                                + alpha*e;
                
                newsol.Position=max(newsol.Position,VarMin);
                newsol.Position=min(newsol.Position,VarMax);
                
                newsolution= randperm(6,6);
                  z=0;
                  newx=rand;
                   for i=1:n
                       for j=i+1:n
                           newz=newz+w(i,j)-newx*30;
                       end
                   end
                   newsol.Cost= newz;
                   newsol.Sol= newsolution;
                
                
                if newsol.Cost <= newpop(i).Cost
                    newpop(i) = newsol;
                    if newpop(i).Cost <= BestSol.Cost
                        BestSol=newpop(i);
                    end
                end
                
            end
        end
        
        % Perform Mutation
        for k=1:nMutation
            
             n=numel(pop(i).Position);
    
              sa=randsample(n,2);
               sa1=sa(1);
               sa2=sa(2);

           newsol.Position=pop(i).Position;
           newsol.Position([sa1 sa2])=pop(i).Position([sa2 sa1]);
            
             solutionnew= randperm(6,6);
                  znew=0;
                  xnew=rand;
                   for i=1:n
                       for j=i+1:n
                           znew=znew+w(i,j)-xnew*30;
                       end
                   end
                   
                   newsol.Cost=znew;
                   newsol.Sol=solutionnew;
            
            if newsol.Cost <= newpop(i).Cost
                newpop(i) = newsol;
                if newpop(i).Cost <=BestSol.Cost
                    BestSol=newpop(i);
                end
            end
        end
                
    end
    
    % Merge
    pop=[pop
         newpop];  %#ok
    
    % Sort
    [~, SortOrder]=sort([pop.Cost]);
    pop=pop(SortOrder);
    
    % Truncate
    pop=pop(1:nPop);
    
    % Store Best Cost Ever Found
    BestCost(it)=BestSol.Cost;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
    % Damp Mutation Coefficient
    alpha = alpha*alpha_damp;
    

end





