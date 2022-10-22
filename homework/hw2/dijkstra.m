function path = dijkstra(G,s,d)
%%
%The implementation of Dijkstra's algorithm 
%inputs:
%-G:    The n x n weighted adjacency matrix
%-ini:  Starting node
%-goal: Goal node
%
%Ouputs:
%-path: The shortest path represented by nodes 
%% inital setup
n=size(G,1);
count = 1;
U = [];
for i = 1:n
    U = [U i];        %U is the set of all nodes
    dist(i) = inf;
    prev(i) = NaN;
end
dist(s) = 0;

%% Repeat the steps 3-6 in Dijkstra’s Algorithm handout
while ismember(d,U)     %while ngoal is in U
    [min_dist,C_i] = min(dist);         %Find the smallest distance and its index
    if count > 1                        % At the second iteration, eliminate the zero in dist because                               
        d2 = dist;                      % there is an extra zero in dist 
        d2(C_i) = [];                   % which makes C incorrect.
        [min_dist,C_i] = min(d2); 
    end
    C = U(C_i);                         
    U(C_i) = [];                        % Remove C from U
    count = count + 1;
    
    for v=1:n
        if(dist(C)+G(C,v)) < dist(v)         
            dist(v)=dist(C) + G(C,v);
            prev(v) = C;
        end
    end
end
distance = dist(d);
%% construct the path based on prev
path = [d];
while path(1) ~= s
    if prev(path(1)) <= n           % Stating from the goal node,
        path = [prev(path(1)) path]; % contruct the path by prev backward
    end
end
end