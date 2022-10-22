function path = astar2(G,n_ini,n_goal)
%%
%The implementation of A* algorithm with the heuristic function in the
%second question. ( The sum of each row in G' where G'
%is the same as G except “Inf” is replaced by 0 (i.e., G'
%is just the adjacency matrix).)
%
%===inputs===:
%-G:    The n x n weighted adjacency matrix
%-n_ini:  Starting node
%-n_goal: n_goal node
%
%===Ouputs===:
%-path: The shortest path represented by nodes 
% 
%===Discussion===: This heuristic function is not good because h(n),which
% represents the shortest path is not always equivalent to the path with the least numeber of nodes 
%% initial setup
O = [n_ini]; 
C = [];
n=size(G,1);
for i = 1:n
    f(i) = inf;
    g(i) = inf; 
    prev(i) = NaN;
end

% The sum of each row in G' where G' is the same as G except “Inf” is replaced by 0
f(n_ini) = sum(G(n_ini,:));     %f(n_ini) = h(n)
g(n_ini) = 0;
%% %% Repeat the steps 3-6 in A* Algorithm handout
while ~isempty(O)              % While O is not an empet set
    %pick nbest
    list = [];
    for i = 1:length(O)        %contruct the list of f(o) for sorting
        list = [list f(O(i))];
    end
    [min_v min_i] = min(list);
    nbest = O(min_i);
    O(min_i) = [];             %remove nbest from open set
    C = [C nbest];             %add nbest to close set

    %if nbest reaches n_goal, exit
    if nbest == n_goal
        break 
    end

    for x = 1:n                    % for each neighbor, x, of nbest
        if ismember(x,C)
            continue
        end
   
        dist_nbest_x = G(nbest,x);  % distance between nbest and x
        g_temp = g(nbest) + dist_nbest_x;
   
        if ~ismember(x,O)           %if neighbor is not in the open set
            O = [O x];               %add x to open set
        elseif g_temp >= g(x)
            continue
        end
        prev(x) = nbest;
        g(x) = g_temp;
        [pathx] = dijkstra((G),x,n_goal); 
        
        % The sum of each row in G' where G' is the same as G except “Inf” is replaced by 0
        f(x) = g(x) + sum(G(nbest,:));   %f(x) = g(x) + h(x) 
    end
end
distance = g(n_goal);
%% construct the path based on prev
path = [n_goal];
while path(1) ~= n_ini
    if prev(path(1)) <= n               % Stating from the goal node,
        path = [prev(path(1)) path];    % contruct the path by prev backward
    end
end
end