function [path, V, E] = build_RRT(qI , qG, NumNodes, delta_q, O, xmax, ymax)
% Function Name: build_RRT
% get vertices, edges of the graph and find the shortest path from qI to qG
%======================================
% inputs:
% -qI: 1x2 matrix coordinates of the initial point
% -qG: 1x2 matrix coordinates of the goal point
% -NumNodes: Number of node of the map
% -delta_q: Delta q sample size
% -O: Cell array obstacles
% -xmax: Maxmimum size of x in a 2D square box of workspace
% -ymax: Maxmimum size of y in a 2D square box of workspace
%=======================================
% Ouputs:
% -path: 2xN path connecting qI and qG
% -V: The set of vertices V 
% -E: The set of edges E
%=======================================


%%
edge = [];
V = [];
E = [];
path = [];
Road = [];
dist_qG = [];
WS = [0 xmax xmax 0;0 0 ymax ymax];
%% test input
if (is_Cfree(O, qI,WS)==0)
   fprintf('\nError: qI is not in C free! Check your qI ') ;
   return;
elseif (is_Cfree(O, qG,WS)==0)
   fprintf('\nError: qG is not in C free! Check your qG ') ;
   return;
end

%%  1. Initialize the graph (or tree) G with qinit
V = [V qI];

%% build the graph of nodes, get vertices V and edges E
for k = 1:NumNodes
    %% Choose a random configuration, qrand, in C    
    qrand = rand_conf(O, WS);
    [qnear,index] = Nearest_Vertex(qrand, V);
    qnew = New_Conf(qnear,qrand,delta_q,O,WS);
    %% check if new edge collides with obs and qnew in Cfree
    a=is_intersect_obs(O, qnear, qnew);          % check if edge collides with OBS
    b = is_Cfree(O, qnew,WS);                    % check if qnew is in C free 
    %% if not, run aagin until new edge doesn't collides with obs and qnew in Cfree
    while ((a==1)||(b==0))==1
        qrand = rand_conf(O, WS);
        [qnear,index] = Nearest_Vertex(qrand, V);
        qnew = New_Conf(qnear,qrand,delta_q,O,WS) ;  
        a=isintersect_linepolygon([qnear qnew],O{1});
        b = is_Cfree(O, qnew,WS);
    end 
    %% Get vertices and edges
    V = [V qnew];
    E{1,k} = [qnear qnew];
    %plot([qnear(1,1) qnew(1,1)],[qnear(2,1) qnew(2,1)],'black'); % connect qnear and qnew
    %plot(V(1,k),V(2,k),'bo','MarkerSize',3);                                    % mark all the vertices
    edge = [edge [qnear;qnew]];
    %% break when reach qG
    if norm(qnew-qG) <= delta_q
        E{1,k+1} = [qnew,qG];
        break
    end
end
%% check if out of nodes
if norm(qnew-qG) > delta_q*2
    fprintf('\n out of node, add more nodes!');
    return
end

%% build the map
num_E = size(edge) ;

for i = 1:num_E(2)
    a = find(V==edge(1:2,i));          %%index of q0 in V
    b = find(V==edge(3:4,i));         %% index of q1 in V
    q0_index = a(2,1)/2;
    q1_index = b(2,1)/2;
    Road = [Road [q0_index;q1_index]];    %% road is 4xN matrix, each column is the edge
end

%% find the last one in the graph closest to qG
num_V  = size(V);
for i = 1:num_V(2)
    dist = norm(qG-V(:,i));
    dist_qG = [dist_qG dist];
end
[min_qG_dist,min_qG_index] = min(dist_qG);
Road
%% find the shortest path
a = find(V == V(:,min_qG_index));
[P ,D]= shortestpath(graph(Road(1,:),Road(2,:)),1,a(2,1)/2);
num_path = size(P);
for i = 1:num_path(2)
    path = [path V(:,P(i))];  
end

%% plot
%{
%plot([path(1,num_path(2)) qG(1,1)],[path(2,num_path(2)) qG(2,1)],'green','LineWidth',3); % qG & the last point of path
% draw the shortest path
for i = 1:num_path(2)
    if i~=1
        %plot([V(1,P(i-1)) V(1,P(i))],[V(2,P(i-1)) V(2,P(i))],'green','LineWidth',3)
    end
end
%}
%% output
path = [path qG];
end
