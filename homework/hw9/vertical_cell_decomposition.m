function [V, G, n_init, n_goal] = vertical_cell_decomposition(qI, qG, CB, bounds)
% Function Name:  vertical_cell_decomposition(qI, qG, CB, bounds)
% Vertical cell decomposition for planar rigid-body robot cases
% inputs:
% -qI: initial position of the robot
% -qG: goal position of the robot
% -CB: : C-obstacles
% -bounds: coordinates of the vertices of the rectangular box (environment or the world).
%
% Ouputs:
% -V: the set of vertices of the graph
% -G: the weighted adjacency matrix for the graph
% -n_init: the node numbers for qI 
% -n_goal: the node numbers for qG

V_bounds = [];                 % vertices of bounds
line_seg = {};
V = [qI];



%% cell array line segment of bounds;
xrange = [min(bounds(1,:)),max(bounds(1,:))];
yrange = [min(bounds(2,:)),max(bounds(2,:))];
xmax = max(bounds(1,:));
xmin = min(bounds(1,:));
ymax = max(bounds(2,:));
ymin = min(bounds(2,:));
line_seg{1} = [[xrange(1,1) yrange(1,1)] ;[xrange(1,2) yrange(1,1)]];
line_seg{2} = [[xrange(1,2) yrange(1,1)] ;[xrange(1,2) yrange(1,2)]];
line_seg{3} = [[xrange(1,2) yrange(1,2)] ;[xrange(1,1) yrange(1,2)]];
line_seg{4} = [[xrange(1,1) yrange(1,2)] ;[xrange(1,1) yrange(1,1)]];
WS = [0 xmax xmax 0;0 0 ymax ymax];
%% input test
if (is_Cfree(CB, qI,WS)==0)
   fprintf('==========================================================================\n| Error: qI is not in C free (out of workspace or inside obs)! Check your qI | \n========================================================================\n\n\n ') ;
   return;
elseif (is_Cfree(CB, qG,WS)==0)
   fprintf('==========================================================================\n| Error: qG is not in C free (out of workspace or inside obs)! Check your qG | \n========================================================================\n\n\n ') ;
   return;
end

%% cell array each line segment of bounds & obs
num_CB = size(CB);  % number of obstacles
for i = 1:num_CB(2)
    num_V = size(CB{i});
    obs = CB{i};
    for j = 1:num_V(2)
        vertex = obs(:,j);
        V_bounds = [V_bounds [obs(1,j) ;obs(2,j)]];
        %% add each line segment of obs
        if (j>1)&&(j<=num_V(2))
          line_seg=[line_seg,{[[obs(1,j-1) obs(2,j-1)] ;[obs(1,j) obs(2,j)]]}];
        end
        if (j+1>num_V(2))
          line_seg = [line_seg,{[[obs(1,num_V(2)) obs(2,num_V(2))] ;[obs(1,1) obs(2,1)]]}];
        end
    end
end
%% find all intersection points
[out, node]  = FindIntersections(line_seg,CB);

%% Connect qI and qG to the nodes
node = [qI node qG];
%find the V line next to qI on the right
for i = 1:size(out,2)      %% for every vertical line 
    if (qI(1,1)>=out{i}(1,1)) &&(qI(1,1)<out{i+1}(1,1))
        next_node = i+1;        
        break
    elseif xmin>= qI(1,1)
        next_node = 2;
        break
    end     
end


%% get V
for i = 1:size(out,2)      %% for every vertical line 
    if (qG(1,1)>=out{i}(1,1)) &&(qG(1,1)<out{i+1}(1,1))
        last_node = i;        
        break
    elseif xmax<= qG(1,1)
        last_node = size(out,2)-1;
        break
    end   
end


for i = next_node:1:last_node+1    
    num_node = size(out{i});
    % connect qI
    if i == next_node
        for j  = 2:size(out{i},1)         
            if is_intersect_obs(CB, out{i}(j,:), qI') == 0    % connect if path doesn't intersect with obs
                prev_node = out{i}(j,:)';
                V = [V prev_node];
               break 
            end
        end
    % connect qG
    elseif i == last_node+1
         V = [V qG];
   % connect nodes
    else
        for j  = 2:size(out{i},1) 
            if is_intersect_obs(CB, out{i}(j,:), prev_node') == 0  % connect if path doesn't intersect with obs
                prev_node = out{i}(j,:)';
                V = [V prev_node];
                break
            end
        end
    end
end

%% generate adj matrix G
G = zeros(size(V,2));
for i = 2:size(V,2)
    dist = norm(V(:,i-1)-V(:,i));
    G(i-1,i) = dist;
    G(i,i-1) = dist;
end

%% plot
%{
% draw vertical lines

num_Q = size(Q);
num_out = size(out);
route = [];

x_line = unique( sort(V_bounds(1,:),2));
num_x = size(x_line);
for i = 1:num_x(2)
    sweep_line{i} = [[x_line(i) yrange(1,1)];[x_line(i) yrange(1,2)]];
    if i == num_x(2)
        sweep_line  = [{[[xrange(1,1) yrange(1,1)];[xrange(1,1) yrange(1,2)]]}, sweep_line,{[[xrange(1,2) yrange(1,1)];[xrange(1,2) yrange(1,2)]]}];
    end
end
for i = 1:num_x(2)+2
    line = sweep_line{i};
    plot([line(1,1) line(2,1)],[yrange(1,1) yrange(1,2)],'red','LineWidth',.2)
end
for i= 1:num_Q(2)
  
    x = Q(1,:);
    y = Q(2,:);
    plot(x,y,'r*')
end



for i  = 1:size(out,2)    %% for each vertical line 
   if i < size(out,2)-1   %% find the next verticle line right to current line
      next_vertical_line = out{i+1};
   end 
   vertical_line = out{i}  ;
   for j = 2:size(vertical_line,1)              %% each node on vertical lines
       fprintf('\nline %d node %d',i,j-1)
       ver_node = vertical_line(j,:);
       [i j-1 ;ver_node];
       for k = 2:size(next_vertical_line,1)       %% each node on the next vertical lines
           next_ver_node = next_vertical_line(k,:);
           if is_intersect_obs(CB, next_ver_node, ver_node) ==0           %% if line segment of two nodes doesn't intersect with obs
               route = [route [ver_node'; next_ver_node']];               %% route map of all modes              
           end
       end
   end   
end
%}
%% output
n_init = 1;
n_goal = size(V,2);
V;
G;
end