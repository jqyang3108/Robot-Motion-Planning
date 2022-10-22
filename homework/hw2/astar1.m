function path = astar1(G,n_ini,n_goal)
%%
%The implementation of A* algorithm with the heuristic function in the
%lecture (the least number of nodes)
%
%===inputs===:
%-G:    The n x n weighted adjacency matrix
%-n_ini:  Starting node
%-n_goal: n_goal node
%
%===Ouputs===:
%-path: The shortest path represented by nodes 
% 
%===Discussion===: This heuristic function is not good because h(n),which represents the path with the least
% number of nodes it not always equivalent to the shortest path.
%% initial setup
O = [n_ini];
C = [];
n=size(G,1);
for i = 1:n
    f(i) = inf;
    g(i) = inf; 
    prev(i) = NaN;
end
[pathf] = dijkstra((G),n_ini,n_goal);    %Find the path with the least number of nodes
f(n_ini) = length(pathf);               %f(n_ini) = h(n)
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
        f(x) = g(x) + length(pathx);    %f(x) = g(x) + h(x)
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