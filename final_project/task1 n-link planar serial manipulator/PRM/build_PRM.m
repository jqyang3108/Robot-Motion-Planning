function [path, V, G] = build_PRM(qI,qG,NumNodes,K,O,WS,root,length)
% Function Name: build_PRM
% get vertices, edges of the graph and find the shortest path from qI to qG
%=======================================
% inputs:
% -qI: 1x2 matrix coordinates of the initial point
% -qG: 1x2 matrix coordinates of the goal point
% -K: Number of nearest nieghbors
% -NumNodes: Number of node of the map
% -O: Cell array obstacles
% -WS: workspace
% -root: 2x1 postion of proximal end
% -length: nx1 length of each link
%=======================================
% Ouputs:
% -path: 5xN path connecting qI and qG each row represents joint angles
% -V: The set of vertices V 
% -G: The weighted adjacency matrix G

%% get path
qI_ang = qI;qG_ang = qG;path = [];
qI= draw_link(root,qI,length,'red','red.');
qG = draw_link(root,qG,length,'blue','blue.');
[P,V,G,Vcurrent_set,qprime_set] = PRM_Path(qI,qG,NumNodes,K,O,WS);
if isempty(P)
    path = [];
    return   
end
num_path = size(P);
% if path intersect with obs or did not reach qG, run again
while isempty(P)||(P(num_path(2))~= NumNodes)
   [P,V,G,Vcurrent_set,qprime_set] = PRM_Path(qI,qG,NumNodes,K,O,WS);
   num_path = size(P);
end
for i = 1:num_path(2)
    path = [path V(:,P(i))];
end
%% output
patha = [path qG];
path = get_path(patha,V,qI_ang,qI,qG,length,root,WS,O);

end
%%
function path = get_path(path,V,qI_ang,qI,qG,length,root,WS,CB)
path_pos = [];count = 1;p = [];joint_out  =[];n = size(length,2);
%% find the shortest path
if isempty(path)
   fprintf('\nUnable to find a approprate path, try again!\n') 
   path = [];
   return
end
%% output
path_pos = [path_pos qG];
for i = 1:size(path,2)  
    [a,b] = find_xnew(n,qI_ang,length,root,WS,CB,path(:,i));
    theta = b;
    if i==1
        x = a;
    end
end
while (norm(a-qG)>2)||(norm(x-qI)>2)
    for i = 1:size(path,2)  
        [a,b] = find_xnew(n,theta,length,root,WS,CB,path(:,i));
        theta = b;
        a = [p a];
        joint_out = [joint_out; b];
    end
    if count > 3
        path = [];      
       return 
    end
    count = count+1;
end
path = joint_out;
end
%%
function [xnew,out_joint] = find_xnew(n,joint_angle,length,root,WS,CB,xnear)
    end_p_cand = [];joint_cand = []; dist = [];i = 1;
    delta_t = 10;
    for n1 = [0,1,-1]
        theta = [joint_angle(1)+delta_t*n1*pi/180 joint_angle(2) joint_angle(3) joint_angle(4) joint_angle(5)];
        [end_p,joint,valid] = check_xnew(n,root,theta,length,WS,CB);
        if valid == true
            end_p_cand = [ end_p_cand end_p];
            joint_cand = [joint_cand; theta];
        end
        for n2 = [0,1,-1]
            theta = [joint_angle(1)+delta_t*n1*pi/180 joint_angle(2)+delta_t*n2*pi/180 joint_angle(3) joint_angle(4) joint_angle(5)];
            [end_p,joint,valid] = check_xnew(n,root,theta,length,WS,CB);
            if valid == true
                end_p_cand = [ end_p_cand end_p];
                joint_cand = [joint_cand; theta];
            end      
            for n3 = [0,1,-1]
                theta = [joint_angle(1)+delta_t*n1*pi/180 joint_angle(2)+delta_t*n2*pi/180 joint_angle(3)+delta_t*i*pi/180 joint_angle(4) joint_angle(5)];
                [end_p,joint,valid] = check_xnew(n,root,theta,length,WS,CB);
                if valid == true
                    end_p_cand = [ end_p_cand end_p];
                    joint_cand = [joint_cand; theta];
                end                
                for n4 = [0,1,-1]
                    theta = [joint_angle(1)+delta_t*n1*pi/180 joint_angle(2)+delta_t*n2*pi/180 joint_angle(3)+delta_t*n3*pi/180 joint_angle(4)+delta_t*n4*pi/180 joint_angle(5)];
                    [end_p,joint,valid] = check_xnew(n,root,theta,length,WS,CB);
                    if valid == true
                        end_p_cand = [ end_p_cand end_p];
                        joint_cand = [joint_cand; theta];
                    end              
                    for n5 = [0,1,-1]
                        theta = [joint_angle(1)+delta_t*n1*pi/180 joint_angle(2)+delta_t*n2*pi/180 joint_angle(3)+delta_t*n3*pi/180 joint_angle(4)+delta_t*n4*pi/180 joint_angle(5)+delta_t*n5*pi/180];
                        [end_p,joint,valid] = check_xnew(n,root,theta,length,WS,CB);
                        if valid == true
                            end_p_cand = [ end_p_cand end_p];
                            joint_cand = [joint_cand; theta];
                        end
                    end
                end
            end      
        end
    end   
    for i = 1:size(end_p_cand,2)  
        dist = [dist norm(end_p_cand(:,i)-xnear)];
    end

    [mind,index] = min(dist);
    out_joint = joint_cand(index,:);
    xnew = end_p_cand(:,index);
end
%%
function [out,joint,valid] = check_xnew(n,q0,theta,length,WS,CB)
a = [];b = [];
for i = 1:n
    if i == 1
        start_p = q0;
        end_p = [start_p(1,1)+cos(theta(i))*length(i);start_p(2,1)+sin(theta(i))*length(i)];
        if (is_Cfree(CB, end_p,WS) == 0) || (is_intersect_obs(CB, start_p, end_p)==1)
           out = [];
           joint = [];
           valid = false;
           return
        end
    else
        start_p = end_p;
        end_p = [start_p(1,1)+cos(theta(i))*length(i);start_p(2,1)+sin(theta(i))*length(i)];
        if (is_Cfree(CB, end_p,WS) == 0) || (is_intersect_obs(CB, start_p, end_p)==1)
            out = [];
            joint = [];
            valid = false;
           return
        end
    end
    a = [a end_p];
    b = theta;
    a = end_p;
end
out = a;
joint = b;
valid = true;

end
