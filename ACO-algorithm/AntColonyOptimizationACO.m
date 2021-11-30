clc;
clear;

% THE COSTMATRIX(7Aircrafts(rows)/ 7Routes(columns))
%Airbus 747(aircrafts1,2) 
%Airbus 703(aircrafts3,4,5)
%Airbus T-42(aircrafts6,7)
Cost_Matrix = [179000 17000 21000 4000 1000 3080 27510;
               179000 17000 21000 4000 1000 3080 27510;
               143200 13600 16800 1600 400 2464 33012;
               143200 13600 16800 1600 400 2464 33012;
               143200 13600 16800 1600 400 2464 33012;
               161100 10200 12600 2400 600 1848 33012;
               161100 10200 12600 2400 600 1848 33012];

% PROBLEM SIZE 
pr_size = size(Cost_Matrix, 1);
ants = 2; % NUMBER OF ANTS
max_assigns = 1000; % NUMBER OF ASSIGNMENTS

% (WHEN TO STOP)
optimal_cost = 107;       % OPTIMAL SOLUTION
a = 1;                    % WEIGHT OF PHEROMONE
b = 5;                    % WEIGHT OF HEURISTIC INFO
lamda = 0.9;              % EVAPORATION PARAMETER
Q = 10;                   % CONSTANT FOR PHEROMONE UPDATING
AM = ones(ants,pr_size);  % ASSIGNMENTS OF EACH ANT
min_cost = -1;

% HEURISTIC INFO - SUM OF Costs of flights
for i=1:pr_size
    D(i) =sum( Cost_Matrix(1:i-1,i))+sum(Cost_Matrix(i,i+1:pr_size));
end

% START THE ALGORITHM
assign = 1;
while (assign <= max_assigns) & ( (min_cost > optimal_cost)|(min_cost == -1) )

    % =============== FIND PHEROMONE ===============
    % AT FIRST LOOP, INITIALIZE PHEROMONE
    if assign==1
    % SET 1 AS INITIAL PHEROMONE
    pher = ones(8);
    % IN THE REST OF LOOPS, COMPUTE PHEROMONE
    else
        for i=1:pr_size
            for j=1:pr_size
                tmp = zeros(ants,pr_size);
                tmp(find(AM==j)) = 1;
                tmp = tmp(:,i);
                tmp = tmp .* costs';
                tmp( find(tmp==0) ) = [];
                tmp = Q ./ tmp;
                delta(i,j) = sum(tmp);
            end
        end
        pher = lamda * pher + delta;
    end

   
    % ============ ASSIGN AIRCRAFTS TO ROUTES ============
    % EACH ANT MAKES ASSIGNMENTS

    for ant=1:ants
        % GET RANDOM ORDER
        aircrafts = rand(pr_size, 2);
        for i=1:pr_size
            aircrafts(i,1) = i;
        end
        aircrafts = sortrows(aircrafts,2);
        % KEEP AVAILABLE ROUTES IN A VECTOR
        for i=1:pr_size
            free_routes(i) = i;
        end
        pref = ones(pr_size,1); % PREFERENCE FOR EACH SITE
        prob=ones(pr_size,1);% PROBABILITIES FOR EACH DEPT
        for aircraft_index=1:pr_size
            % GET SUM OF THE PREFERENCES
            % AND THE PREFERENCE FOR EACH SITE
            pref_sum = 0;
        for route_index=1:size(free_routes,2)
            tmp_pher=pher(aircrafts(aircraft_index),free_routes(route_index));
            pref(route_index) = tmp_pher^a *( 1/D(free_routes(route_index)) )^b;
            pref_sum = pref_sum + pref(route_index);
        end

        % GET PROBABILITIES OF ASSIGNING THE DEPT
        % TO EACH FREE SITE
        prob = free_routes';
        prob(:,2) = pref / pref_sum;
        % GET THE SITE WHERE THE DEPT WILL BE ASSIGNED
        prob = sortrows(prob,2);
        AM(ant,aircraft_index) = prob(1);
        % ELIMINATE THE SELECTED SITE FROM THE
        % FREE SITES
        index = find(free_routes==prob(1));
        prob(1,:) = [];
        free_routes(index) = [];
        pref(index) = [];
        end
        % GET THE COST OF THE ANT’S ASSIGNMENT
        costs(ant) = 0;
        for i=1:pr_size
            for j=1:i-1
                aircraft_flow = Cost_Matrix(i,j);
                route1 = AM(ant,i);
                route2 = AM(ant,j);
                if route1  route2
                    routes_distance = Cost_Matrix(route1, route2);
                else
                routes_distance = Cost_Matrix(route2, route1);
               end
            costs(ant) = costs(ant) + aircraft_flow * routes_distance;
            end
        end
        if costs(ant)  min_cost | min_cost==-1
        min_cost = costs(ant);
        ch_assign = AM(ant,:);
        end
        if mod(assign,100) == 0
        disp( sprintf('Assignments so far : % d Cheapest cost : % d', assign, min_cost));
        end
        assign = assign + 1;
    end
end
    disp( sprintf('Cheapest Cost : % d', min_cost));
    disp( sprintf('Assignments : % d', assign-1));
    disp(' ');
    disp('Assignment');
    disp('----------');
    ant_index = find(costs==min(costs));
    for i=1:pr_size
        disp( sprintf('Dept % d to Site % d', i, ch_assign(i)));
end