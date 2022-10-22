function [path, V, E] = build_RRT(qI , qG, NumNodes, CB,WS,length,root)
% Function Name: build_RRT
% get vertices, edges of the graph and find the shortest path from qI to qG
%======================================
% inputs:
% -qI: 1xn matrix joint angles
% -qG: 1x2 matrix joint angles of the goal point
% -NumNodes: Number of node of the map
% -CB: Cell array obstacles
% -WS: workspace
% -length: length of links
% -root: proximal end
%=======================================
% Ouputs:
% -path: 2xN path connecting qI and qG
% -V: The set of vertices V 
% -E: The set of edges E
%=======================================

%%
path = [qI];V = []; E = [];E_id=[];Vid = [];endqG = qG;
qI = rad_to_deg(qI);qG = rad_to_deg(qG);V = [V ;[qI]];Vid = [Vid 1];n = size(length,2);xnew_id = 1;
for k = 1:NumNodes  
    xnew_id = xnew_id+1;
%% generate xrand
    xrand = rand_conf(qI,length,root,WS,CB);    
%% find xnear 
    [xnear,near_id]= Nearest_Vertex(xrand,V,Vid);
%% find xnew
    xnew = find_xnew(xnear,xrand,length,root,WS,CB);
    %draw_link(root,xnew,length,'black','black.'); % plot xnew
%% build Vertex and Edge
    xnew = rad_to_deg(xnew);
    V = [V ;xnew];
    Vid = [Vid xnew_id];
    E_id = [E_id [near_id ;xnew_id]];
    %draw_link(root,deg_to_rad(xnew),length,'black','blackx');
%% break if reach qG
    dist_angle(qG,xnew);
    if dist_angle(qG,xnew)<10
        %draw_link(root,deg_to_rad(xnew),length,'green','blackx');
        break
    end
end
%% check if exceeds number of nodes
if k>= NumNodes
   path = [];
   fprintf('\nOut of nodes, try again!')
   return
end
%% find path
Eid0 = round(E_id(1,:));
Eid1 = round(E_id(2,:));
try 
    [P ,D]= shortestpath(graph(Eid0,Eid1),1,Eid1(1,size(Eid1,2)));
catch
   fprintf('\nUnable to find a approprate path, try again!\n') 
   return  
end
for i = 2:size(P,2)
    a = deg_to_rad(V(P(i),:));
    path = [path ;a ];
end
path = [path ;endqG];
end
%% addtional functions 1 rad_to_deg
function deg = rad_to_deg(rad)
% Function Name: rad_to_deg
% convert radian to degree
%======================================
% inputs:
% -rad: angle in rad
%=======================================
% Ouputs:
% -deg: angle in deg
    deg = [];
    for i = 1:size(rad,2)
        a = rad(i)*180/pi;
        if a<0
            a = 360+a;
        end
        if a>360
           a= a-360; 
        end
        deg = [deg a];       
    end
end
%% addtional functions 2 deg_to_rad
function rad = deg_to_rad(deg)
% Function Name: rad_to_deg
% convert degree to radian
%======================================
% inputs:
% -deg: angle in deg
%=======================================
% Ouputs:
% -rad: angle in rad
    rad = deg*pi/180;
end