  function [best_solution,best_cost] = simulatedannealing(cost_matrix)
   
    alpha = 0.3;                  %0.3Geometric cooling factor
    T_init =100;                  % Initial temperature
    %T_min = 1e-10;                % Final stopping temperature
   T_min = 1e-5; 
   T=T_init;                     %Iterator variable
    max_rej=1500;                 % Maximum number of rejections
    max_run=500;                  % Maximum number of runs
    max_accept = 15;              % Maximum number of accept
    k = 1;                        % Boltzmann constant
    i= 0; j = 0; accept = 0; totaleval = 0;
   
     [initial_solution, initial_cost] = getInitialSolution(cost_matrix,1);
     
      disp('-------------------------------------------------------------------------------------------------------------');
      fprintf('-------- INITIAL SOLUTION: '); disp(initial_solution);
      fprintf('-------- INITIAL COST: %d \n',initial_cost);
      disp('-------------------------------------------------------------------------------------------------------------');
    
     
     [num_rows, num_columns] = size(cost_matrix); % Number of nodes.
     num_nodes = num_rows;
    
     
     current_solution = initial_solution; 
     best_solution = initial_solution;    
     best_cost = initial_cost;            
     f_x = initial_cost;
    
    
     while ((T > T_min) & (j <= max_rej))
       
         i = i+1;   
          fprintf('\n--------------- ITERATION %d ---------------\n',j);
       
          if (i >= max_run) | (accept >= max_accept*(T_init+1-T)) 
            T = T_init/(1 + (alpha * i));
            totaleval = totaleval + i;
            i = 1; accept = 1;
        end
        
        
        [best_neighborhood_solution, best_neighborhood_cost] = getNeighborhood (current_solution, best_cost, cost_matrix);
        current_solution = best_neighborhood_solution;
        
        if (best_neighborhood_cost < best_cost)
            best_solution = best_neighborhood_solution;
            best_cost = best_neighborhood_cost;
            accept=accept+1;
           new_f_x = best_cost;
           f_x= new_f_x;
        else
          
         % if (new_f_x > f_x) 
           new_f_x = best_neighborhood_cost;
            r = rand(1);
            Probability = exp(-1*(new_f_x-f_x)/T);
           
                 if Probability > r 
                      f_x = new_f_x;
                       accept=accept+1;  
                 else
               
                      j = j+1;
                 end
           end
       
     end
    
     
    disp('-------------------------------------------------------------------------------------------------------------');
    fprintf('-------- THE BEST SOLUTION OBTAINED IN %d ITERATIONS: ',i); disp(best_solution);
    fprintf('-------- COST OF THE BEST SOLUTION: %1.4f \n',f_x);
    disp('-------------------------------------------------------------------------------------------------------------');

 end
    
    
     
  function [best_neighborhood_solution, best_neighborhood_cost] = getNeighborhood (current_solution, best_cost,cost_matrix)

  
    fprintf('\nTHE BEST KNOWN SOLUTION COST: %d \n',best_cost);
    fprintf('\nCURRENT SOLUTION: ');disp(current_solution);
   
    best_neighborhood_solution = [];
    best_neighborhood_cost = 0;
    best_node1 = 0;
    best_node2 = 0;
    
    min_cost = 0;
    num_nodes = length(current_solution);
    
    for i=2:num_nodes
        for j=i+1:num_nodes
            neighborhood_solution = current_solution;
            % Node (i, j) swapping.
            neighborhood_solution(i) = current_solution(j);
            neighborhood_solution(j) = current_solution(i);
            
            fprintf('- CANDIDATE NEIGHBORHOOD SOLUTION:'); disp(neighborhood_solution);
            
            neighborhood_cost = getCostSolution (neighborhood_solution, cost_matrix);
           
            diversification_cost = neighborhood_cost;
                
             if ((min_cost == 0) || (diversification_cost < min_cost))
                    % best solution obatined so far
                    min_cost = diversification_cost;
                    best_neighborhood_solution = neighborhood_solution;
                    best_neighborhood_cost = neighborhood_cost;
                    best_node1 = neighborhood_solution(i);
                    best_node2 = neighborhood_solution(j);
                end
           
                
            end
        end
  end
  
    
    
    
    function [cost_solution] = getCostSolution (solution, cost_matrix)
    x = rand * 6;
    cost_solution = 0;
    for i=1:(length(solution) - 1)
        cost_solution = cost_solution + cost_matrix(solution(i),solution(i+1))- x*30;
    end
    % Total cost between intial and final nodes.
    cost_solution = cost_solution + cost_matrix(solution(length(solution)),solution(1));
    end
  
    
  function [initial_path, total_cost] = getInitialSolution (cost_matrix, initial_node)

    [num_rows, num_columns] = size(cost_matrix);
    
    num_nodes = num_rows; % Number of nodes.

    initial_path(1) = initial_node;
    total_cost = 0; % Total cost.
    
    while (length(initial_path) < num_nodes)
        current_node = initial_path(length(initial_path)); % Nodo actual.

        % List of costs for the current nodes:
        node_cost_list = cost_matrix(current_node,:);
        
        % The mearest node:
        [nearest_node, min_cost] = getNearestNode (node_cost_list, initial_path);
        
        initial_path(length(initial_path) + 1) = nearest_node;
        total_cost = total_cost + min_cost;
    end
    
    % Including the intial node.
    total_cost = total_cost + cost_matrix(nearest_node, initial_node);

  end
  
  
  
function [is_visited_node] = inVisitedNodes (node, visited_nodes)
    is_visited_node = false;
    num_visited_nodes = length(visited_nodes);
    
    for i=1:num_visited_nodes
        if (node == visited_nodes(i))
            is_visited_node = true;
            break;
        end
    end
end


function [nearest_node, min_cost] = getNearestNode (node_cost_list, initial_path)
    num_nodes = length(node_cost_list); % Number of nodes.
    visited_nodes = initial_path;
    min_cost = 0; % Minimum cost.
    nearest_node = 0; % Selected node.
    
    for node=1:num_nodes
        if (inVisitedNodes(node, visited_nodes) == false)
            % Not visted node
            if ((min_cost == 0) || (node_cost_list(node) < min_cost))
                % The nearest node so far.
                min_cost = node_cost_list(node);
                visited_nodes(size(visited_nodes) + 1) = node;
                nearest_node = node;
            end     
        end
    end
end
  
  
  
    
    