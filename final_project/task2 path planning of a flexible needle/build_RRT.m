function [path, V, E,triangle_pos,uw_out] = build_RRT(qI , qG, NumNodes, O,WS,u_phi,u_w,radius,robot_config)
% Function Name: build_RRT
% get vertices, edges of the graph and find the shortest path from qI to qG
%======================================
% inputs:
% -qI: 1x3 matrix coordinates of the initial point
% -qG: 1x2 matrix coordinates of the goal point
% -NumNodes: Number of node of the map
% -WS: Workspace
% -O: Cell array obstacles
% -u_phi:Padaling angular speed of the wheel
% -u_w: Angular speed of wheel about xy-plaane
% -radius: Radius of the wheel in unicycle model
% -triangle: 2x3 configuration of the needle robot
%

%=======================================
% Ouputs:
% -path: 2xN path connecting qI and qG
% -V: The set of vertices V 
% -E: The set of edges E
% -triangle_pos: Cell array of all needle robot configuration on the path
% -uw_out; List of angular speed of wheel about xy-plane at each node on path
%=======================================

%%
edge = [];Va = [];E = [];path = [];uw_set = [];dist_qG = [];triangle_pos = {};uw_out = [];

%%  1. Initialize the graph (or tree) G with qinit
Va = [Va [qI;1]];
Vid = [];
Vid = [Vid 1];
xnew_id = 1;
E_id = [];
uw_set = [uw_set qI(3,1)];
linear_speed = u_phi*radius;

length = robot_config(1);
width = robot_config(2);


%% build the graph of nodes, get vertices V and edges E
for k = 1:NumNodes
    %% Choose a random configuration, qrand, in C   
    xnew_id = xnew_id+1;
    qrand = rand_conf(O, WS);       %% define random points 
    [qnear] = Nearest_Vertex(qrand, Va);   %% find the closest node on Tree  
    [end_tip, end_base,end_A0,end_uw]= generate_path(linear_speed,u_w,qnear(1:3,1),length,width,O,WS); %% generate possible paths

    while isempty(end_tip)
        qrand = rand_conf(O, WS);       %% define random points 
        [qnear] = Nearest_Vertex(qrand, Va);   %% find the closest node on Tree    
        [end_tip, end_base,end_A0,end_uw]= generate_path(linear_speed,u_w,qnear(1:3,1),length,width,O,WS) ;%% generate possible paths         
    end
    %%
    
    [x_new,x_new_tip,A0_new,uw_new] = New_Conf(qrand,O,WS,end_tip, end_base,end_A0,end_uw); %% find the path leads to the nodes which has the cloest distance to qrand
    
    %% Get vertices and edges
    Va = [Va [x_new;xnew_id]];
    uw_set = [uw_set uw_new];
    E_id = [E_id [qnear;[x_new;xnew_id]]];
    E{1,k} = [qnear(1:2,1) x_new(1:2,1)];
    %plot([x_new(1,1) x_new_tip(1,1)],[x_new(2,1) x_new_tip(2,1)],'blue','LineWidth',6); % connect qnear and qnew
    %plot(V(1,k),V(2,k),'bo','MarkerSize',3);                                    % mark all the vertices
    edge = [edge [qnear(1:3,1);x_new(1:3,1)]];
    
    %% break when reach qG

    dist_tip = norm(x_new_tip(1:2,1)-qG);
    dist_base = norm(x_new(1:2,1)-qG);
    if ( dist_tip<= 0.2*length)&&(dist_tip<dist_base)%&&(abs(ThetaInDegrees)<u_w)
        qG = [qG;0];
        E{1,k+1} = [x_new,qG];
        V = Va(1:3,:);
        break
    end
end

%% check if out of nodes
if k >= NumNodes
    fprintf('\nOut of node, add more nodes and try again!\n');
    path = [];
    V = Va(1:3,:);
    return
end
%% find the shortest path

Eid0 = round(E_id(4,:));
Eid1 = round(E_id(8,:));
Eid1(1,size(Eid1,2));
try 
    [P ,D]= shortestpath(graph(Eid0,Eid1),1,Eid1(1,size(Eid1,2)));
catch
   fprintf('\nUnable to find a approprate path, try again!\n') 
   path = [];
   return  
end
for i = 1:size(P,2)
    path = [path V(:,P(i))];  

    add = triangle_vertex(V(:,P(i)),length,width);
    uw_out = [uw_out uw_set(P(i))];
    triangle_pos{i} = [add];
end

%% output
if isempty(path)
   fprintf('\nUnable to find a approprate path, try again!\n') 
   path = [];
   return
end
fprintf('\n Success!\n') 
path = [path qG];
end

%%
function [qnew] =  Nearest_Vertex(qrand, G)
% Function Name: 
% Find a nearest node qnear in G to qrand. Initially, the nearest node is qinit.
%=======================================
% inputs:
% -qrand: Random configuration
% -G: Array of all nodes q
%=======================================
% Ouputs:
% -qnew: qnew node
% -index: Index of the qnear in G
%=======================================

%

d = inf;
num = size(G);
for i = 1:num(2)
    vi = G(:,i);
    if norm(qrand-vi(1:2,1)) < d
        vnew = vi;
        d = norm(qrand-vi(1:2,1));
    end
end
%% output
qnew = vnew;
end
function qrand = rand_conf(O,WS)
% Function Name: 
% Generate random configurations
%=======================================
% inputs:
% -O: Cell array obstacles
% -WS: Workspace
%=======================================
% Ouputs:
% -qramd: The random configuration
%=======================================
%% Generate random configuration
pt = [ rand(1)*(max(abs(WS(1,:))));rand(1)*(max(abs(WS(2,:))))];
%% if qrand is not in the Cfree, generate again
while is_Cfree(O, pt,WS) ~= 1
	pt = [ rand(1)*(max(abs(WS(1,:))));rand(1)*(max(abs(WS(2,:))))];
end
qrand = pt;
end
function [x_new,x_new_tip,A0_new,uw_new] =  New_Conf(qrand,O,WS,end_tip, end_base,end_A0,uw_set)
% Function Name: New_Conf
% Select a new configuration qnew by moving from qnear by the step size ∆q.
%=======================================
% inputs:
% -qnear: Point qneat
% -qrand: Random configuration
% -delta_q: Step size
% -O: Cell array obstacles
% -WS: Workspace
%=======================================
% Ouputs:
% -qnew: node qnew
%=======================================

%%
dist = [];
for i  = 1:size(end_base,2)
    dist = [dist norm(qrand(1:2,1)-end_base(1:2,i))];
end

[mind,index] = min(dist);

x_new = end_base(:,index);
x_new_tip = end_tip(:,index);
uw_new =uw_set(index);
if index == 1
    A0_new = end_A0(:,1:3);
elseif index == 2
    A0_new = end_A0(:,4:6);
elseif  index == 3
        A0_new = end_A0(:,7:9);
end
end
function is_Cfree = is_Cfree(O, pt,WS)
% Function Name: 
% Check if point is in the C free space.
% inputs:
% -O: Cell array obstacles
% -pt; Point to check
% -WS: Workspace
% Ouputs:
% -b: Binary value, true for point in Cfree and false for not


%% test if qrand in any obs : 0 for not in all obs
num_obs = size(O);
for i = 1:1:num_obs(2)
    obs = O{i};
    if i == 1
        inobs = inpolygon(pt(1,1),pt(2,1),obs(1,:),obs(2,:));
    end
    inobs = inobs||inpolygon(pt(1,1),pt(2,1),obs(1,:),obs(2,:));
end
%% test if qrand in the workspace: 1 for in the WS
in_ws = inpolygon(pt(1,1),pt(2,1),WS(1,:),WS(2,:));
%% valid if qrand in WS and qrand not in obs
is_Cfree = (inobs==0)&& (in_ws == 1); 
end
function A0_new = triangle_vertex(base_pose,length,width)
    tip_pos = [base_pose(1,1)+length*cos(base_pose(3,1));base_pose(2,1)+length*sin(base_pose(3,1));base_pose(3,1)]; %% postive of tip when starts
    [left_p,right_p ]=find_points(tip_pos(1:2,1),base_pose,width);
    A0_new = [ left_p tip_pos(1:2,1) right_p];
end
%%

function [height,width] = iso_vertex(a)
p1 =  [a(:,1)' a(:,2)' norm(a(:,1)-a(:,2)) ]';
p2 = [a(:,2)' a(:,3)' norm(a(:,2)-a(:,3)) ]';
p3 = [a(:,3)' a(:,1)' norm(a(:,3)-a(:,1)) ]';
g = [p1 p2 p3];
[mind,i] = min(g(5,:));
basep1 = g(1:2,i);
basep2 = g(3:4,i);
if i ==1
    tip = a(:,3);
elseif i==2
    tip = a(:,1); 
elseif i==3
    tip = a(:,2);
end

dy = (basep1(2,1)-basep2(2,1))/(basep1(1,1)-basep2(1,1));
    
if dy==-Inf
    midp = [(basep1(1,1)-basep2(1,1))*0.5+basep2(1,1);-norm(basep1-basep2)*0.5+basep2(2,1)];
elseif dy==Inf
    midp = [(basep1(1,1)-basep2(1,1))*0.5+basep2(1,1);norm(basep1-basep2)*0.5+basep2(2,1)];
elseif dy==0
    if basep1(1,1)<basep2(1,1)
        midp = [norm(basep1-basep2)*0.5+basep1(1,1);norm(basep1-basep2)*0.5+basep2(2,1)];
    elseif basep1(1,1)>basep2(1,1)
        midp = [norm(basep1-basep2)*0.5+basep2(1,1);norm(basep1-basep2)*0.5+basep2(2,1)];
    end
else
    midp = [(basep1(1,1)-basep2(1,1))*0.5+basep2(1,1);dy*(basep1(1,1)-basep2(1,1))*0.5+basep2(2,1)];
end
%% output
width = norm(basep1-basep2);
height=norm (tip-midp);
end