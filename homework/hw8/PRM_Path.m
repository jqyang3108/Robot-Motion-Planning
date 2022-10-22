function [P,V,G,Vcurrent_set,qprime_set] = PRM_Path(qI,qG,NumNodes,K,O,WS)
% Function Name: PRM_Path
% Find the shortest path 
%=======================================
% inputs:
% -qI: 1x2 matrix coordinates of the initial point
% -qG: 1x2 matrix coordinates of the goal point
% -K: Number of nearest nieghbors
% -O: Cell array obstacles
% -WS: Workspace
%=======================================
% Ouputs:
% -P: Array of the indices of the nodes on the shortest path
% -V: The set of vertices V 
% -G: The weighted adjacency matrix G
% -Vcurrent_set: Set of all Vcurrent positions
% -qprime_set: Set of all qprime positions
%=======================================
%% define variables
V  = [];
E = [];
Vcurrent_set = [];
qprime_set = [];
Road = [];
path = [];
NumNodes = NumNodes -2;         %%assume qI and qG is included in NumNodes,then exclude qI and qG for find the graph between them
%% Generate n number of collision-free random configurations.
for i = 1:NumNodes
    qrand = rand_conf(O, WS);
    V = [V qrand];
end

V = [qI V qG];
num = size(V);
for i = 1:num(2)
    Vcurrent = V(:,i);
    Vtemp = V;
    Vtemp(:,i) = [];       % NumNodes -1 neighbors
    %% find dist with all neighbors
    dist_set = [];
    %fprintf('\n==============\nnode %d',i)
    for j = 1:num(2)-1
        dist = norm(Vcurrent-Vtemp(:,j));
        dist_set = [dist_set dist];
    end
    %% find K closest neighbors
    [min_dist,min_index] = mink(dist_set, K);
    for p = 1:K
        qprime = Vtemp(:,min_index(p));
        %plot(qprime(1,1),qprime(2,1),'bo'); 
       %% for qprime in Nq
        if (is_intersect_obs(O,Vcurrent,qprime) == 0)
            qprime_set = [qprime_set qprime];
            Vcurrent_set = [Vcurrent_set Vcurrent];
            E = [E [Vcurrent;qprime]];
        end    
    end
end
%% build the road map
num_E = size(E) ;
for i = 1:num_E(2)
    q0 = E(1:2,i);       
    q1 = E(3:4,i);
    a = find(V==q0);          %%index of q0 in V
    b = find(V==q1) ;         %% index of q1 in V
    q0_index = a(2,1)/2;
    q1_index = b(2,1)/2;
    Road = [Road [q0_index;q1_index;norm(q0-q1)]];
end

%% generate adj matrix G
G  = zeros(NumNodes+2);
num_Road = size(Road);
for i = 1:num_Road(2)
    G(Road(1,i),Road(2,i)) = Road(3,i);
    G(Road(2,i),Road(1,i)) = Road(3,i);
end

%% find the path
A = graph(Road(1,:),Road(2,:),Road(3,:));

[P ,D]= shortestpath(A,1,NumNodes+2);
end