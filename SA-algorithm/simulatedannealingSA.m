
          cost_matrix = [70 30 24 7 28 22;
              12 22 43 49 23 81;
              73 22 12 34 5 12;
               22 9 33 55 77 22;
              22 12 45 65 28 91;
              11 11 11 11 11 11 ];
          
  solution = randperm(6,6);
            
    alpha = 0.3; %Geometric cooling factor
    T_init =100; % Initial temperature
    T_min = 1e-5; % Final stopping temperature
    T=T_init; %Iterator variable
    max_rej=2500; % Maximum number of rejections
    max_run=500; % Maximum number of runs
    max_accept = 15; % Maximum number of accept
    k = 1; % Boltzmann constant
    i= 0; j = 0; accept = 0; totaleval = 0;

    x = rand ;
    cost_solution=0;
    for i=1:(length(solution) - 1)
        cost_solution = cost_solution + cost_matrix(solution(i),solution(i+1))- x*30;
    end
     cost_solution = cost_solution + cost_matrix(solution(length(solution)),solution(1));
    f_x=cost_solution;

    while ((T > T_min) & (j <= max_rej))
        i = i+1;
        if (i >= max_run) | (accept >= max_accept*(T_init+1-T)) 
            % Cooling according to a cooling schedule
            T = T_init/(1 + (alpha * i));
            totaleval = totaleval + i;

            % reset the counters
            i = 1; accept = 1;
        end
        
        newsolution= randperm(6,6);
        newx = rand ;
    
        new_cost_solution=0;
    for i=1:(length(newsolution) - 1)
        new_cost_solution = new_cost_solution + cost_matrix(newsolution(i),newsolution(i+1))- newx*30;
    end
     new_cost_solution =  new_cost_solution + cost_matrix(newsolution(length(newsolution)),newsolution(1));
  
        new_f_x=new_cost_solution;
        

        if new_f_x < f_x
            
            cost_solution= new_cost_solution;
            f_x = new_f_x;
            solution=newsolution;
            accept=accept+1;
        else
            r = rand(1);
            Probability = exp(-1*(new_f_x-f_x)/T);
            if Probability > r
                cost_solution = new_cost_solution;
                solution=newsolution;
                f_x = new_f_x;
                accept=accept+1;
            else
                j=j+1;
            end
        end
    end
    
    fprintf('\nTHE BEST KNOWN SOLUTION COST: %.8f \n',f_x);
    fprintf('\nCURRENT SOLUTION: ');disp(solution);